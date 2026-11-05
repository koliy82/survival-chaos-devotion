if Commands == nil then
	print ( '[Commands] creating Commands' )
	Commands = {}
	Commands.__index = Commands
end

-- [SCD-OFFLINE] ========= доступ к dev-командам кастомки =========
-- В оригинале в 15 местах были вшиты длинные цепочки сравнений SteamID с ID
-- автора кастомки (Niker323) и его соавторов:
--   76561198112013738, 76561198090912161, 76561198107820614,
--   76561198073992510, 76561198070071399
-- В своей копии доступ нужен её владельцу, а не автору. Все цепочки заменены на
-- один вызов _G.SCD_IsDevPlayer(cmdPlayer), а список ID живёт здесь, в одном
-- месте. Оригинальные ID сохранены в комментарии выше и в git-истории.
--
-- ВАЖНО, почему сравниваем НЕ SteamID64, а AccountID:
-- числа в Lua 5.1 — это double (мантисса 53 бита, точно представляются целые
-- до 2^53 = 9007199254740992). Любой SteamID64 вида 765611983... ≈ 7.7e16
-- БОЛЬШЕ этого предела, поэтому PlayerResource:GetSteamID() отдаёт значение с
-- потерей точности, а tostring() печатает его в экспоненциальной форме
-- ("7.6561198313888e+16"). Сравнение со строкой "76561198313888459" не проходит
-- НИКОГДА — авторская авторизация dev-команд была мертва изначально, просто её
-- никто не проверял.
-- 32-битный AccountID в double помещается точно, поэтому сравнение надёжно.
-- Пересчёт: accountID = steamID64 - 76561197960265728
_G.SCD_DEV_ACCOUNT_IDS = _G.SCD_DEV_ACCOUNT_IDS or {
	[353622731] = true, -- 76561198313888459, Koliy82 (владелец копии)
}

-- Оставлен для совместимости и как документация: SteamID64 -> AccountID.
-- Сравнение по нему ненадёжно (см. выше), но если движок в какой-то сборке
-- вернёт строку, оно сработает как запасной путь.
_G.SCD_DEV_STEAMIDS = _G.SCD_DEV_STEAMIDS or {
	["76561198313888459"] = true, -- Koliy82
}

-- Одноразовые заметки (не спамим на каждый вызов команды).
_G.SCD_DevNotes = _G.SCD_DevNotes or {}
local function SCD_Note(key, msg)
	if _G.SCD_DevNotes[key] then
		return
	end
	_G.SCD_DevNotes[key] = true
	print("[SCD-OFFLINE] " .. msg)
end

-- Определяет PlayerID по объекту, который вернул Convars:GetCommandClient().
--
-- В живой игре проверено: у этого объекта НЕТ метода GetPlayerID —
-- "attempt to call method 'GetPlayerID' (a nil value)". Из-за этого ломались ВСЕ
-- dev-команды автора: они все написаны как cmdPlayer:GetPlayerID(), причём
-- KillUnit/AddUnitXP/GiveItem вызывают его ДО проверки авторизации, то есть
-- падали сразу, а остальные молча не пускал гейт.
--
-- Поэтому пробуем несколько способов и возвращаем также описание того, какой
-- сработал (оно печатается в лог один раз — чтобы мы знали правду, а не гадали).
_G.SCD_ResolveCallerID = _G.SCD_ResolveCallerID or function(client)
	if client == nil then
		return nil, "client is nil"
	end
	if type(client) == "number" then
		if PlayerResource:IsValidPlayerID(client) then
			return client, "number"
		end
		return nil, "numeric id is not a valid player"
	end

	-- прямые методы объекта
	for _, m in ipairs({ "GetPlayerID", "GetPlayerOwnerID" }) do
		if type(client[m]) == "function" then
			local ok, id = pcall(function()
				return client[m](client)
			end)
			if ok and type(id) == "number" and PlayerResource:IsValidPlayerID(id) then
				return id, "client:" .. m .. "()"
			end
		end
	end

	-- через индекс энтити: entindex -> hscript -> владелец
	if type(client.entindex) == "function" then
		local ok1, ei = pcall(function()
			return client:entindex()
		end)
		if ok1 and type(ei) == "number" and ei >= 0 then
			local ok2, ent = pcall(function()
				return EntIndexToHScript(ei)
			end)
			if ok2 and ent ~= nil and type(ent.GetPlayerOwnerID) == "function" then
				local ok3, id = pcall(function()
					return ent:GetPlayerOwnerID()
				end)
				if ok3 and type(id) == "number" and PlayerResource:IsValidPlayerID(id) then
					return id, "entindex->GetPlayerOwnerID()"
				end
			end
		end
	end

	-- Последний путь: если в матче ровно один игрок (наш обычный случай — юзер
	-- играет один или проверяет локально), вызвавший однозначно он.
	-- При двух и более игроках так гадать нельзя — возвращаем отказ.
	local okCount, count = pcall(function()
		return PlayerResource:GetPlayerCount()
	end)
	if okCount and count == 1 then
		for i = 0, 23 do
			if PlayerResource:IsValidPlayerID(i) then
				return i, "single-player fallback"
			end
		end
	end

	local descr = "unknown"
	pcall(function()
		descr = type(client) .. "/" .. tostring(client)
	end)
	return nil, "cannot resolve caller id (" .. descr .. ")"
end

-- Печатает реальный AccountID игрока — чтобы сверить его со списком, а не гадать.
local function SCD_LogDevAuth(id, how, allowed)
	local accountid = nil
	pcall(function()
		accountid = PlayerResource:GetSteamAccountID(id)
	end)
	SCD_Note("auth:" .. tostring(id) .. ":" .. tostring(allowed),
		"dev auth: player " .. tostring(id)
		.. " accountID=" .. tostring(accountid)
		.. " resolved via " .. tostring(how)
		.. " allowed=" .. tostring(allowed))
end

-- Принимает объект игрока (как Convars:GetCommandClient() / PlayerResource:GetPlayer(id))
-- или числовой PlayerID. Возвращает true, если игрок в списке разработчиков.
function _G.SCD_IsDevPlayer(playerOrId)
	if playerOrId == nil then
		return false
	end
	local id, how = _G.SCD_ResolveCallerID(playerOrId)
	if id == nil then
		SCD_Note("auth:unresolved", "dev auth: " .. tostring(how) .. " - access denied")
		return false
	end

	local okAcc, accountid = pcall(function()
		return PlayerResource:GetSteamAccountID(id)
	end)
	if okAcc and type(accountid) == "number" and _G.SCD_DEV_ACCOUNT_IDS[accountid] == true then
		SCD_LogDevAuth(id, how, true)
		return true
	end

	-- запасной путь: если движок всё же вернул SteamID64 строкой
	local okId, steamid = pcall(function()
		return tostring(PlayerResource:GetSteamID(id))
	end)
	if okId and steamid ~= nil and _G.SCD_DEV_STEAMIDS[steamid] == true then
		SCD_LogDevAuth(id, how .. "+steamid64", true)
		return true
	end

	SCD_LogDevAuth(id, how, false)
	return false
end
-- [SCD-OFFLINE] ==================================================

function Commands:Init()
	Convars:RegisterCommand( "win", Dynamic_Wrap(Commands, 'Win'), "A console command example", 0 )
	Convars:RegisterCommand( "check_key", Dynamic_Wrap(Commands, 'CheckKey'), "A console command example", 0 )
	Convars:RegisterCommand( "check_connect", Dynamic_Wrap(Commands, 'CheckConnect'), "A console command example", 0 )
	Convars:RegisterCommand( "add_ability", Dynamic_Wrap(Commands, 'AddAbilityCommand'), "A console command example", 0 )
	Convars:RegisterCommand( "select_race", Dynamic_Wrap(Commands, 'SelectRaceCommand'), "A console command example", 0 )
	Convars:RegisterCommand( "lag_test", Dynamic_Wrap(Commands, 'LagTest'), "A console command example", 0 )
	Convars:RegisterCommand( "get_neutrals", Dynamic_Wrap(Commands, 'GetAllNeutrals'), "A console command example", 0 )
	Convars:RegisterCommand( "up_neutrals", Dynamic_Wrap(Commands, 'UpAllNeutrals'), "A console command example", 0 )
	Convars:RegisterCommand( "kill_unit", Dynamic_Wrap(Commands, 'KillUnit'), "A console command example", 0 )
	Convars:RegisterCommand( "add_xp", Dynamic_Wrap(Commands, 'AddUnitXP'), "A console command example", 0 )
	Convars:RegisterCommand( "start_profiler", Dynamic_Wrap(Commands, 'StartProfiler'), "A console command example", 0 )
	Convars:RegisterCommand( "stop_profiler", Dynamic_Wrap(Commands, 'StopProfiler'), "A console command example", 0 )
	Convars:RegisterCommand( "log_profiler", Dynamic_Wrap(Commands, 'LogProfiler'), "A console command example", 0 )
	Convars:RegisterCommand( "check_connection_state", Dynamic_Wrap(Commands, 'CheckConnectionState'), "A console command example", 0 )
	Convars:RegisterCommand( "give_item", Dynamic_Wrap(Commands, 'GiveItem'), "A console command example", 0 )
    Convars:RegisterCommand( "run_code", Dynamic_Wrap(Commands, 'RunCodeCmd'), "A console command example", 0 )
    Convars:RegisterCommand( "admin_login", Dynamic_Wrap(Commands, 'AdminLogin'), "A console command example", 0 )
    -- [SCD-OFFLINE] отладка топ-бара SCD_TopBar в одиночном матче: только автономная сборка,
    -- без SteamID-гейта, применяется строго к вызвавшему игроку. Существующие dev-команды
    -- автора (run_code / kill_unit / win / get_neutrals / ...) не открываются и не меняются.
    Convars:RegisterCommand( "scd_topbar_test", Dynamic_Wrap(Commands, 'SCDTopBarTest'), "SCD offline: change own base state to verify top bar", 0 )
    
	CustomGameEventManager:RegisterListener("StartProfiler", Dynamic_Wrap(Commands, 'UIStartProfiler'))
	CustomGameEventManager:RegisterListener("StopProfiler", Dynamic_Wrap(Commands, 'UIStopProfiler'))
    CustomGameEventManager:RegisterListener("LogProfiler", Dynamic_Wrap(Commands, 'UILogProfiler'))
    
    Commands.admins = {}
end

function Commands:AdminLogin(key, strid)
    print("AdminLogin")
    -- [SCD-OFFLINE] GetDedicatedServerKeyV3 в автономной игре не вызываем: ключ нужен был
    -- только как параметр "v" для запросов к dotascd.ru, а в локальной игре он пустой,
    -- то есть старое условие key == GetDedicatedServerKeyV3("3") не пускало никого.
    -- Что охраняет команда: только UI-панель разработчика - Commands.admins[id] проверяют
    -- UIStartProfiler / UIStopProfiler / UILogProfiler (профайлер). На игровой процесс и на
    -- локального игрока она не влияет, но и блокировать его не должна.
    -- Решение: авторизуем того, кто реально выполнил команду (Convars:GetCommandClient()
    -- возвращает клиента, а для серверной консоли - nil, тогда берем strid или id 0).
    if _G.SCD_OFFLINE then
        local cmdPlayer = Convars:GetCommandClient()
        local id = cmdPlayer and (_G.SCD_ResolveCallerID(cmdPlayer)) or tonumber(strid) or 0
        if PlayerResource:IsValidPlayerID(id) then
            SCD_OfflineNote("admin_login: dev panel allowed for player " .. tostring(id))
            local player = PlayerResource:GetPlayer(id)
            if player then
                CustomGameEventManager:Send_ServerToPlayer( player, "AdminPanel", {})
            end
            Commands.admins[id] = true
        end
        return
    end
    if key == GetDedicatedServerKeyV3("3") then
        print("true")
        local id = tonumber(strid)
        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(id), "AdminPanel", {})
        Commands.admins[id] = true
    end
end

function Commands:UIStartProfiler(data)
    local id = data.PlayerID
    if Commands.admins[id] then
        Say(PlayerResource:GetSelectedHeroEntity(id), "Start Profiler", false)
        _G.profiler.start()
    end
end

function Commands:UIStopProfiler(data)
    local id = data.PlayerID
    if Commands.admins[id] then
        Say(PlayerResource:GetSelectedHeroEntity(id), "Stop Profiler", false)
        _G.profiler.stop()
    end
end

function Commands:UILogProfiler(data)
    local id = data.PlayerID
    if Commands.admins[id] then
        _G.profiler.attachPrintFunction(function(msg) CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "display_custom_error", { message = msg }) end, true)
		_G.profiler.report("profiler.log")
    end
end

function Commands:Win()
	-- local cmdPlayer = Convars:GetCommandClient()
	if IsInToolsMode() then
		for id, _ in pairs(_G.playersinfo) do
			_G:Defeat(id)
        end
	end
end

function Commands:GetAllNeutrals(team)
	local cmdPlayer
	if IsInToolsMode() then
		cmdPlayer = PlayerResource:GetPlayer(0) 
	else
		cmdPlayer = Convars:GetCommandClient()
	end
	if cmdPlayer and _G.SCD_IsDevPlayer(cmdPlayer) then
		for i=1,8 do
			_G.additional_buildings[i]:SetNewCustomOwner(tonumber(team))
		end
	end
end

function Commands:UpAllNeutrals(team)
	local cmdPlayer
	if IsInToolsMode() then
		cmdPlayer = PlayerResource:GetPlayer(0) 
	else
		cmdPlayer = Convars:GetCommandClient()
	end
	if cmdPlayer and _G.SCD_IsDevPlayer(cmdPlayer) then
		for i=1,8 do
			_G.additional_buildings[i]:UpgradeNeutral()
		end
	end
end

function Commands:LagTest(raceid)
	local cmdPlayer
	if IsInToolsMode() then
		cmdPlayer = PlayerResource:GetPlayer(0) 
	else
		cmdPlayer = Convars:GetCommandClient()
	end
	if cmdPlayer and _G.SCD_IsDevPlayer(cmdPlayer) then
		print(collectgarbage("count"))
		print(collectgarbage("collect"))
	end
end

--function Commands:SelectRaceCommand(place, raceid)
--	local cmdPlayer
--	if IsInToolsMode() then
--		cmdPlayer = PlayerResource:GetPlayer(0) 
--	else
--		if place ~= nil then cmdPlayer = PlayerResource:GetPlayer(tonumber(place)) end
--	end
--	if cmdPlayer then
--		if raceid ~= nil then
--			GameRules.AddonTemplate:SelectRace({PlayerID = cmdPlayer:GetPlayerID(), race = tonumber(raceid)})
--        end
--	end
--end

function Commands:SelectRaceCommand(raceid)
	local cmdPlayer
	if IsInToolsMode() then
		cmdPlayer = PlayerResource:GetPlayer(0) 
	else
		cmdPlayer = Convars:GetCommandClient()
	end
	if cmdPlayer and _G.SCD_IsDevPlayer(cmdPlayer) then
		if raceid ~= nil then
			GameRules.AddonTemplate:SelectRace({PlayerID = (_G.SCD_ResolveCallerID(cmdPlayer)), race = tonumber(raceid)})
        end
	end
end

function Commands:CheckKey(keyid)
	local cmdPlayer
	if IsInToolsMode() then
		cmdPlayer = PlayerResource:GetPlayer(0) 
	else
		cmdPlayer = Convars:GetCommandClient()
	end
	if cmdPlayer and _G.SCD_IsDevPlayer(cmdPlayer) then
        if keyid ~= nil then
			-- [SCD-OFFLINE] GetDedicatedServerKeyV3 не вызываем вообще: ключ выдавался
			-- только для dotascd.ru. Отладочная команда остается, но сообщает об офлайне.
			if _G.SCD_OFFLINE then
				SCD_OfflineNote("check_key: dedicated server key is not used offline")
				CustomGameEventManager:Send_ServerToPlayer(cmdPlayer, "display_custom_error", { message = "[SCD-OFFLINE] no dedicated server key" })
				return
			end
			CustomGameEventManager:Send_ServerToPlayer(cmdPlayer, "display_custom_error", { message = GetDedicatedServerKeyV3(keyid) })
        end
	end
end

function Commands:CheckConnect(str)
	local cmdPlayer
	if IsInToolsMode() then
		cmdPlayer = PlayerResource:GetPlayer(0) 
	else
		cmdPlayer = Convars:GetCommandClient()
	end
	if cmdPlayer and _G.SCD_IsDevPlayer(cmdPlayer) then
		if str ~= nil then
			print(str)
			-- [SCD-OFFLINE] произвольный GET наружу в автономной игре не выполняется.
			-- Колбэк ничего не инициализировал (только выводил тело ответа игроку),
			-- поэтому фоллбек - сообщение в тот же display_custom_error.
			if _G.SCD_OFFLINE then
				SCD_OfflineNote("check_connect: HTTP request skipped")
				CustomGameEventManager:Send_ServerToPlayer(cmdPlayer, "display_custom_error", { message = "[SCD-OFFLINE] " .. tostring(str) })
				return
			end
			local req = CreateHTTPRequestScriptVM( "GET", str)
			req:Send(function(result)
				-- print(result.Body)
				CustomGameEventManager:Send_ServerToPlayer(cmdPlayer, "display_custom_error", { message = result.Body })
			end)
        end
	end
end

--function Commands:AddAbilityCommand(spell, lvl)
--	local cmdPlayer
--	if IsInToolsMode() then
--		cmdPlayer = PlayerResource:GetPlayer(0) 
--	else
--		cmdPlayer = Convars:GetCommandClient()
--	end
--	if cmdPlayer and (tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" or tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198090912161") then
--		if spell ~= nil then
--			_G:UpdateSelectedEntity( cmdPlayer:GetPlayerID() )
--			Timers:CreateTimer(0.2, function()
--				_G.selected_entity[cmdPlayer:GetPlayerID()]:AddAbility(spell):SetLevel(tonumber(lvl or "1"))
--			end)
--        end
--	end
--end

function Commands:AddAbilityCommand(place, spell, lvl)
	local cmdPlayer
	if IsInToolsMode() then
		cmdPlayer = PlayerResource:GetPlayer(0) 
	else
		if place ~= nil then cmdPlayer = PlayerResource:GetPlayer(tonumber(place)) end
	end
	if cmdPlayer then
		if spell ~= nil then
			_G:UpdateSelectedEntity( (_G.SCD_ResolveCallerID(cmdPlayer)) )
			Timers:CreateTimer(0.2, function()
				_G.selected_entity[(_G.SCD_ResolveCallerID(cmdPlayer))]:AddAbility(spell):SetLevel(tonumber(lvl or "1"))
			end)
        end
	end
end

function Commands:KillUnit()
	local cmdPlayer
	if IsInToolsMode() then
		cmdPlayer = PlayerResource:GetPlayer(0) 
	else
		cmdPlayer = Convars:GetCommandClient()
	end
	local playerID = (_G.SCD_ResolveCallerID(cmdPlayer))
	if cmdPlayer and _G.SCD_IsDevPlayer(cmdPlayer) then
		_G:UpdateSelectedEntity( playerID )
		Timers:CreateTimer(0.2, function()
			_G.selected_entity[playerID]:Kill(nil, nil)
		end)
	end
end

function Commands:AddUnitXP(xp_count)
	local cmdPlayer
	if IsInToolsMode() then
		cmdPlayer = PlayerResource:GetPlayer(0) 
	else
		cmdPlayer = Convars:GetCommandClient()
	end
	local playerID = (_G.SCD_ResolveCallerID(cmdPlayer))
	if cmdPlayer and _G.SCD_IsDevPlayer(cmdPlayer) then
		if xp_count then
			_G:UpdateSelectedEntity( playerID )
			Timers:CreateTimer(0.2, function()
				if _G.selected_entity[playerID]:HaveCustomXP() then
					_G.selected_entity[playerID]:AddCustomXP(tonumber(xp_count))
				end
			end)
		end
	end
end

function Commands:GiveItem(item_name)
	local cmdPlayer
	if IsInToolsMode() then
		cmdPlayer = PlayerResource:GetPlayer(0) 
	else
		cmdPlayer = Convars:GetCommandClient()
	end
	local playerID = (_G.SCD_ResolveCallerID(cmdPlayer))
	if cmdPlayer and _G.SCD_IsDevPlayer(cmdPlayer) then
		if item_name then
			_G:UpdateSelectedEntity( playerID )
			Timers:CreateTimer(0.2, function()
				_G.selected_entity[playerID]:AddItemByName(item_name)
			end)
		end
	end
end

function Commands:StartProfiler()
	local cmdPlayer
	if IsInToolsMode() then
		cmdPlayer = PlayerResource:GetPlayer(0) 
	else
		cmdPlayer = Convars:GetCommandClient()
	end
	if cmdPlayer and _G.SCD_IsDevPlayer(cmdPlayer) then
		_G.profiler.start()
	end
end

function Commands:StopProfiler()
	local cmdPlayer
	if IsInToolsMode() then
		cmdPlayer = PlayerResource:GetPlayer(0) 
	else
		cmdPlayer = Convars:GetCommandClient()
	end
	if cmdPlayer and _G.SCD_IsDevPlayer(cmdPlayer) then
		_G.profiler.stop()
	end
end

function Commands:LogProfiler(log)
	local cmdPlayer
	if IsInToolsMode() then
		cmdPlayer = PlayerResource:GetPlayer(0) 
	else
		cmdPlayer = Convars:GetCommandClient()
	end
	if cmdPlayer and _G.SCD_IsDevPlayer(cmdPlayer) then
		if log then
			if log == "client" then
				_G.profiler.attachPrintFunction(function(msg) CustomGameEventManager:Send_ServerToPlayer(cmdPlayer, "display_custom_error", { message = msg }) end, true)
			elseif log == "server" then
				_G.profiler.attachPrintFunction(print, true)
			end
		else
			_G.profiler.attachPrintFunction(print, true)
		end
		_G.profiler.report("profiler.log")
	end
end

function Commands:CheckConnectionState(keyid)
	local cmdPlayer
	if IsInToolsMode() then
		cmdPlayer = PlayerResource:GetPlayer(0)
	else
		cmdPlayer = Convars:GetCommandClient()
	end
	if cmdPlayer and _G.SCD_IsDevPlayer(cmdPlayer) then
        if keyid ~= nil then
			CustomGameEventManager:Send_ServerToPlayer(cmdPlayer, "display_custom_error", { message = PlayerResource:GetConnectionState(tonumber(keyid)) })
        end
	end
end

function Commands:RunCodeCmd(code)
	local cmdPlayer
	if IsInToolsMode() then
		cmdPlayer = PlayerResource:GetPlayer(0) 
	else
		cmdPlayer = Convars:GetCommandClient()
	end
	if cmdPlayer and _G.SCD_IsDevPlayer(cmdPlayer) then
		CustomGameEventManager:Send_ServerToPlayer(cmdPlayer, "display_custom_error", { message = loadstring(code)()})
	end
end

-- [SCD-OFFLINE] ==============================================================================
-- Отладочная команда для проверки ЖИВЫХ обновлений топ-бара SCD_TopBar в одиночном матче.
-- В FFA на 4 игрока юзер один: здания никто не бьет, поэтому цифры в топ-баре стоят на месте.
-- Штатные dev-команды кастомки закрыты зашитыми SteamID автора; эта - отдельная: работает
-- ТОЛЬКО при _G.SCD_OFFLINE, без SteamID-гейта и строго для вызвавшего игрока.
--
-- Синтаксис (консоль Dota):
--   scd_topbar_test                    - напечатать справку
--   scd_topbar_test damage <pct>       - HP своего главного здания в <pct>% от максимума
--                                        (целое 0..100; 100 = вылечить; 0 = снести здание)
--   scd_topbar_test killbarrack [n]    - снести свой барак. Без n - следующий живой по
--                                        порядку (счетчик пойдет 3/3 -> 2/3 -> 1/3 -> 0/3),
--                                        с n - конкретный, n = 1..3
--   scd_topbar_test defeat             - штатно пометить себя выбывшим ("Поражение").
--                                        Если это последний живой игрок - матч завершится.
--
-- Бараки и здание убиваются штатно (ForceKill), а не удалением юнита: тогда срабатывает
-- SCGameMode:OnEntityKilled, который обнуляет _G.playersinfo[id].ancient, чистит
-- _G.playersinfo[id].baracks и считает остатки, а SCGameMode:UpdateTopBarNetTable в OnThink
-- сам обновляет net-таблицу SCD_TopBar.
-- Обёртка-диагностика. Движок на ошибку внутри консольной команды печатает
-- непрозрачное "[VScript] Script Runtime Error: error in error handling" без
-- трассировки, поэтому ловим ошибку сами и печатаем её текст вместе с тем,
-- какие аргументы реально пришли. Как только причина найдена, обёртку можно
-- снять — она ничего не меняет в поведении.
function Commands:SCDTopBarTest(...)
	local argv = { ... }
	local argc = select("#", ...)
	local dump = {}
	for i = 1, argc do
		dump[i] = "[" .. i .. "]=" .. type(argv[i]) .. ":" .. tostring(argv[i])
	end
	local ok, err = pcall(function()
		return Commands:SCDTopBarTestImpl(unpack(argv, 1, argc))
	end)
	if not ok then
		print("[SCD-OFFLINE] scd_topbar_test FAILED: " .. tostring(err))
		print("[SCD-OFFLINE] scd_topbar_test argc=" .. tostring(argc) .. " args: " .. table.concat(dump, " "))
	end
end

function Commands:SCDTopBarTestImpl(...)
	if not _G.SCD_OFFLINE then
		print("[SCD-OFFLINE] scd_topbar_test: available only in the offline build")
		return
	end

	local function usage()
		print("[SCD-OFFLINE] usage: scd_topbar_test damage <0..100> | killbarrack [1..3] | defeat")
	end

	-- аргументы приходят из консоли строками; часть сборок движка передает первым аргументом
	-- имя команды - отсекаем его, чтобы mode/value не съехали
	local args = { ... }
	if args[1] == "scd_topbar_test" then
		table.remove(args, 1)
	end
	local mode = nil
	if args[1] ~= nil then
		mode = string.lower(tostring(args[1]))
	end
	local value = args[2]

	-- вызвавший игрок. GetCommandClient() в этой сборке возвращает объект БЕЗ
	-- метода GetPlayerID, поэтому резолвим через общий _G.SCD_ResolveCallerID.
	local cmdPlayer
	if IsInToolsMode() then
		cmdPlayer = PlayerResource:GetPlayer(0)
	else
		cmdPlayer = Convars:GetCommandClient()
	end
	local id, how = _G.SCD_ResolveCallerID(cmdPlayer)
	if id == nil then
		print("[SCD-OFFLINE] scd_topbar_test: cannot resolve the calling player (" .. tostring(how) .. ")")
		return
	end
	-- команда доступна только разработчику копии: она ломает СВОЮ базу, но в матче
	-- с друзьями её мог бы дёргать кто угодно, поэтому гейт ставим.
	if not _G.SCD_IsDevPlayer(id) then
		print("[SCD-OFFLINE] scd_topbar_test: access denied for player " .. tostring(id)
			.. " (add their accountID to _G.SCD_DEV_ACCOUNT_IDS in scripts/vscripts/commands.lua)")
		return
	end
	-- _G.playersinfo[id] создается в SCGameMode:OnNPCSpawned - до старта игры его нет
	local info = nil
	if _G.playersinfo ~= nil then
		info = _G.playersinfo[id]
	end
	if info == nil then
		print("[SCD-OFFLINE] scd_topbar_test: player " .. tostring(id) .. " has no _G.playersinfo yet - run it after the game has started")
		return
	end

	if mode == nil then
		usage()
		return
	end

	if mode == "damage" then
		local ancient = info.ancient
		if ancient == nil or ancient:IsNull() then
			print("[SCD-OFFLINE] scd_topbar_test damage: player " .. tostring(id) .. " has no ancient (already destroyed)")
			return
		end
		local pct = tonumber(value)
		if pct == nil then
			print("[SCD-OFFLINE] scd_topbar_test damage: expected a number 0..100, got " .. tostring(value))
			usage()
			return
		end
		pct = math.floor(pct)
		if pct < 0 then
			pct = 0
		elseif pct > 100 then
			pct = 100
		end
		local maxhp = ancient:GetMaxHealth()
		if maxhp == nil or maxhp <= 0 then
			print("[SCD-OFFLINE] scd_topbar_test damage: ancient GetMaxHealth() = " .. tostring(maxhp))
			return
		end
		if pct == 0 then
			-- SetHealth(0) здание не убивает, поэтому сносим штатно: OnEntityKilled обнулит
			-- _G.playersinfo[id].ancient, и топ-бар покажет 0% HP как при реальном разгроме
			ancient:ForceKill(false)
			print("[SCD-OFFLINE] scd_topbar_test damage: player " .. tostring(id) .. " ancient destroyed (0%)")
			return
		end
		local hp = math.floor(maxhp * pct / 100 + 0.5)
		if hp < 1 then
			hp = 1
		end
		ancient:SetHealth(hp)
		print("[SCD-OFFLINE] scd_topbar_test damage: player " .. tostring(id) .. " ancient hp " .. tostring(hp) .. "/" .. tostring(maxhp) .. " (" .. tostring(pct) .. "%)")
		return
	end

	if mode == "killbarrack" then
		local baracks = info.baracks
		if baracks == nil then
			print("[SCD-OFFLINE] scd_topbar_test killbarrack: player " .. tostring(id) .. " has no baracks table")
			return
		end
		local target = nil
		local targetKey = nil
		local n = tonumber(value)
		if n ~= nil then
			n = math.floor(n)
			targetKey = n
			-- all_baracks хранит изначальные 3 барака (индексы 1..3), baracks - только живые
			if info.all_baracks ~= nil then
				target = info.all_baracks[n]
			end
			if target ~= nil and baracks[n] == nil then
				print("[SCD-OFFLINE] scd_topbar_test killbarrack: barrack #" .. tostring(n) .. " of player " .. tostring(id) .. " is already destroyed")
				return
			end
		else
			-- следующий живой: наименьший индекс, чтобы повторный вызов сносил следующий
			local aliveKeys = {}
			for k, v in pairs(baracks) do
				if v ~= nil and not v:IsNull() and v:IsAlive() then
					table.insert(aliveKeys, k)
				end
			end
			table.sort(aliveKeys)
			targetKey = aliveKeys[1]
			if targetKey ~= nil then
				target = baracks[targetKey]
			end
		end
		if target == nil or target:IsNull() then
			print("[SCD-OFFLINE] scd_topbar_test killbarrack: no barrack to kill for player " .. tostring(id))
			return
		end
		if not target:IsAlive() then
			print("[SCD-OFFLINE] scd_topbar_test killbarrack: barrack #" .. tostring(targetKey) .. " of player " .. tostring(id) .. " is not alive")
			return
		end
		target:ForceKill(false)
		-- считаем остатки уже ПОСЛЕ ForceKill: если OnEntityKilled отработал синхронно,
		-- убитого барака в таблице нет, а если нет - его отсеет проверка IsAlive()
		local left = 0
		for _, v in pairs(baracks) do
			if v ~= nil and not v:IsNull() and v:IsAlive() then
				left = left + 1
			end
		end
		print("[SCD-OFFLINE] scd_topbar_test killbarrack: player " .. tostring(id) .. " barrack #" .. tostring(targetKey) .. " killed, alive left " .. tostring(left))
		return
	end

	if mode == "defeat" then
		if info.alive == false then
			print("[SCD-OFFLINE] scd_topbar_test defeat: player " .. tostring(id) .. " is already defeated")
			return
		end
		-- штатный путь, а не присвоение alive = false: иначе разойдутся состояние игры и UI.
		-- Если это последний живой игрок, _G:Defeat завершит матч - это ожидаемо.
		print("[SCD-OFFLINE] scd_topbar_test defeat: player " .. tostring(id) .. " -> _G:Defeat (the match ends if he was the last one alive)")
		_G:Defeat(id)
		return
	end

	print("[SCD-OFFLINE] scd_topbar_test: unknown mode " .. tostring(mode))
	usage()
end
