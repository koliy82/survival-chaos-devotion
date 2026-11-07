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
-- [SCD-FIX] Общий фоллбек «единственный игрок» и «единственный dev-игрок».
-- Вынесено в функцию, потому что нужно ОБЕИМ веткам резолвера: и когда клиента нет
-- вовсе, и когда клиент есть, но не отдаёт валидный PlayerID. Раньше вторая ветка
-- возвращала отказ раньше, чем доходила до проверки dev-игрока, из-за чего второй
-- бот не добавлялся: с одним ботом GetPlayerCount() == 2, одиночный фоллбек уже не
-- срабатывал, а до dev-фоллбека дело не доходило.
local function SCD_LonePlayerFallback()
	local okN, n = pcall(function()
		return PlayerResource:GetPlayerCount()
	end)
	if okN and n == 1 then
		for i = 0, 23 do
			if PlayerResource:IsValidPlayerID(i) then
				return i, "single-player fallback"
			end
		end
	end
	return nil, nil
end

-- Единственный dev-игрок в матче. Гадать здесь безопасно и это НЕ поблажка
-- авторизации: команда всё равно гейтится _G.SCD_IsDevPlayer, а боты не имеют
-- Steam-аккаунта (их accountID = 0), поэтому в список разработчиков попасть не могут
-- и определению не мешают. Если dev-игроков двое и более - возвращаем nil, а не
-- произвольный выбор: foundCount == 1 проверяется явно.
local function SCD_LoneDevPlayerFallback()
	if type(_G.SCD_DEV_ACCOUNT_IDS) ~= "table" then
		return nil
	end
	local found, foundCount = nil, 0
	for i = 0, 23 do
		if PlayerResource:IsValidPlayerID(i) then
			local okAcc, acc = pcall(function()
				return PlayerResource:GetSteamAccountID(i)
			end)
			if okAcc and acc and _G.SCD_DEV_ACCOUNT_IDS[acc] then
				found, foundCount = i, foundCount + 1
			end
		end
	end
	if foundCount == 1 then
		return found
	end
	return nil
end

-- Поэтому пробуем несколько способов и возвращаем также описание того, какой
-- сработал (оно печатается в лог один раз — чтобы мы знали правду, а не гадали).
_G.SCD_ResolveCallerID = _G.SCD_ResolveCallerID or function(client)
	if client == nil then
		-- [SCD-FIX] Вызывающего объекта может не быть вовсе: команду дёргают не из
		-- консоли, а из кода (таймер, обработчик события). Раньше здесь был
		-- немедленный отказ. Пробуем оба фоллбека - одиночного игрока и единственного
		-- dev-игрока: второй как и нужен, когда в матче уже есть боты.
		local id, how = SCD_LonePlayerFallback()
		if id ~= nil then
			return id, "nil client -> " .. how
		end
		local dev = SCD_LoneDevPlayerFallback()
		if dev ~= nil then
			return dev, "nil client -> single dev-player fallback"
		end
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

	-- Последние два пути - общие фоллбеки (см. SCD_LonePlayerFallback и
	-- SCD_LoneDevPlayerFallback выше). Второй нужен потому, что первый перестаёт
	-- работать, как только в матч добавлен бот: GetPlayerCount() становится 2.
	-- Именно так проявлялся баг «второго бота добавить нельзя»:
	--   cannot resolve caller id (table/table: 0x4ef34328)
	local id1, how1 = SCD_LonePlayerFallback()
	if id1 ~= nil then
		return id1, how1
	end
	local dev = SCD_LoneDevPlayerFallback()
	if dev ~= nil then
		return dev, "single dev-player fallback"
	end

	local descr = "unknown"
	pcall(function()
		descr = type(client) .. "/" .. tostring(client)
	end)
	-- [SCD-DIAG] Какие поля и методы вообще есть у объекта вызвавшего. Без этого каждый
	-- следующий такой отказ приходилось чинить вслепую: tostring() даёт только
	-- "table: 0x...", и понять, чем объект можно опросить, невозможно. Печатаем один раз.
	pcall(function()
		if type(client) == "table" then
			local key = "scd_caller_fields:" .. tostring(client)
			if _G[key] == nil then
				_G[key] = true
				local names = {}
				for k, v in pairs(client) do
					names[#names + 1] = tostring(k) .. "(" .. type(v) .. ")"
				end
				table.sort(names)
				SCD_Note(key, "command client fields (" .. #names .. "): "
					.. table.concat(names, " "))
			end
		end
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
    -- [SCD-OFFLINE] бот в матч для одиночного тестирования (топ-бар на 2+ игрока, способности
    -- по вражеским постройкам). Гейт тот же: автономная сборка + _G.SCD_IsDevPlayer.
    Convars:RegisterCommand( "scd_add_bot", Dynamic_Wrap(Commands, 'SCDAddBot'), "SCD offline: add a bot player with a full base to a running match", 0 )
    -- [SCD-PERF] замер производительности: волны крипов по требованию, переключатель
    -- декоративных моделей (оригинальный вид против фикса FPS), счётчики и очистка поля.
    Convars:RegisterCommand( "scd_spawn_waves", Dynamic_Wrap(Commands, 'SCDSpawnWaves'), "SCD perf: spawn N creep waves through the real SpawnUnits path", 0 )
    Convars:RegisterCommand( "scd_cosmetics", Dynamic_Wrap(Commands, 'SCDCosmetics'), "SCD perf: toggle decorative creep models (original look vs the FPS fix)", 0 )
    Convars:RegisterCommand( "scd_perf", Dynamic_Wrap(Commands, 'SCDPerf'), "SCD perf: print the current unit/prop load", 0 )
    Convars:RegisterCommand( "scd_kill_creeps", Dynamic_Wrap(Commands, 'SCDKillCreeps'), "SCD perf: remove all creeps (heroes and buildings are kept)", 0 )
    
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

-- [SCD-OFFLINE] ==============================================================================
-- Добавление бота в идущий матч. Нужно для одиночного тестирования: без второго игрока
-- топ-бар показывает один слот, а способности по вражеским постройкам («Мини взрыв» бьёт по
-- _G.playersinfo игроков ДРУГОЙ команды) не имеют целей физически.
--
-- Синтаксис (консоль Dota):
--   scd_add_bot            - бот на свободную команду, раса случайная
--   scd_add_bot <race>     - то же, но с указанной расой (1..19)
--
-- Как устроено:
--   1. GameRules:AddBotPlayerWithEntityScript(hero, name, team, script, false) - штатный API
--      движка (строка и описание найдены в game/dota/bin/win64/server.dll: "Spawn a bot player
--      of the passed hero name, player name, and team"; в стабах dota_functions.lua:5213).
--      Консольной команды dota_create_fakeplayer в этой сборке НЕТ: во всех бинарниках
--      (client.dll/server.dll/host.dll/engine2.dll) есть только поле fakeplayer в структуре
--      player info, самого имени команды нет. GameRules:BotPopulate() не подходит - он
--      работает только в cheat mode.
--   2. Дальше бот идёт по ОБЫЧНОМУ пути: движок спавнит ему форс-героя
--      (mode:SetCustomGameForceHero("npc_dota_hero_wisp")), на npc_spawned срабатывает
--      SCGameMode:OnNPCSpawned, который создаёт ancient / 3 барака / 4 башни / spec и
--      _G.playerstats[id]. Отдельно база не склеивается.
--   3. Если игрок появился, а героя движок не заспавнил (база не создалась), форс-герой
--      создаётся сам - через тот же OnNPCSpawned.
--   4. Когда база есть, раса задаётся штатным SCGameMode:SelectRace.
-- Движок создаёт игрока асинхронно, поэтому результат проверяется таймером (0.5 с x 40 = 20 с)
-- и печатается одной итоговой строкой.
function Commands:SCDAddBot(...)
	local argv = { ... }
	local argc = select("#", ...)
	local ok, err = pcall(function()
		return Commands:SCDAddBotImpl(unpack(argv, 1, argc))
	end)
	if not ok then
		print("[SCD-OFFLINE] scd_add_bot FAILED: " .. tostring(err))
	end
end

function Commands:SCDAddBotImpl(...)
	if not _G.SCD_OFFLINE then
		print("[SCD-OFFLINE] scd_add_bot: available only in the offline build")
		return
	end

	-- аргументы из консоли приходят строками; часть сборок движка передаёт первым аргументом
	-- имя команды - отсекаем его, чтобы раса не съехала
	local args = { ... }
	if args[1] == "scd_add_bot" then
		table.remove(args, 1)
	end
	local raceArg = tonumber(args[1])

	-- вызвавший игрок: GetCommandClient() в этой сборке возвращает объект без GetPlayerID,
	-- поэтому резолвим общим _G.SCD_ResolveCallerID
	local cmdPlayer
	if IsInToolsMode() then
		cmdPlayer = PlayerResource:GetPlayer(0)
	else
		cmdPlayer = Convars:GetCommandClient()
	end
	local id, how = _G.SCD_ResolveCallerID(cmdPlayer)
	if id == nil then
		print("[SCD-OFFLINE] scd_add_bot: cannot resolve the calling player (" .. tostring(how) .. ")")
		return
	end
	if not _G.SCD_IsDevPlayer(id) then
		print("[SCD-OFFLINE] scd_add_bot: access denied for player " .. tostring(id)
			.. " (add their accountID to _G.SCD_DEV_ACCOUNT_IDS in scripts/vscripts/commands.lua)")
		return
	end
	if _G.playersinfo == nil or _G.playersinfo[id] == nil then
		print("[SCD-OFFLINE] scd_add_bot: run it after the game has started (player " .. tostring(id) .. " has no base yet)")
		return
	end

	-- раса: аргумент или случайная из доступных
	local raceCount = _G.race_count or 19
	local race = raceArg
	if race == nil then
		race = RandomInt(1, _G.free_race_count or raceCount)
	end
	race = math.floor(race)
	if race < 1 or race > raceCount then
		print("[SCD-OFFLINE] scd_add_bot: race must be 1.." .. tostring(raceCount) .. ", got " .. tostring(args[1]))
		return
	end

	-- снимок существующих игроков: по нему найдём того, кого добавит движок
	local before = {}
	for i = 0, 23 do
		if PlayerResource:IsValidPlayerID(i) then
			before[i] = true
		end
	end

	-- свободная команда. В duos живут только GOODGUYS/BADGUYS по 2 игрока (_G.duos_spawn
	-- инициализирован только для них, SetCustomGameTeamMaxPlayers тоже), иначе 4 команды по
	-- одному. Команда вызвавшего не годится: бот нужен как ЦЕЛЬ на другой стороне.
	local callerTeam = PlayerResource:GetTeam(id)
	local capacity = _G.duos and 2 or 1
	local candidates
	if _G.duos then
		candidates = { DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS }
	else
		candidates = { DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS, DOTA_TEAM_CUSTOM_1, DOTA_TEAM_CUSTOM_2 }
	end
	local team = nil
	local occupancy = {}
	for _, t in ipairs(candidates) do
		local cnt = 0
		for i = 0, 23 do
			if before[i] and PlayerResource:GetTeam(i) == t then
				cnt = cnt + 1
			end
		end
		occupancy[#occupancy + 1] = tostring(t) .. "=" .. cnt .. "/" .. capacity
		if team == nil and t ~= callerTeam and cnt < capacity then
			team = t
		end
	end
	if team == nil then
		print("[SCD-OFFLINE] scd_add_bot: no free team (caller team " .. tostring(callerTeam)
			.. ", occupancy " .. table.concat(occupancy, " ") .. ")")
		return
	end

	-- 1) просим движок добавить бота
	local heroName = "npc_dota_hero_wisp" -- тот же герой, что форсит SetCustomGameForceHero
	local okAdd, errAdd = pcall(function()
		return GameRules:AddBotPlayerWithEntityScript(heroName, "SCD_Bot", team, "", false)
	end)
	if not okAdd then
		print("[SCD-OFFLINE] scd_add_bot: AddBotPlayerWithEntityScript FAILED: " .. tostring(errAdd))
		return
	end
	print("[SCD-OFFLINE] scd_add_bot: bot requested (team " .. tostring(team) .. ", race " .. tostring(race)
		.. "), waiting for the engine...")

	-- 2) ждём игрока, его базу, затем назначаем расу
	Commands.scd_bots = Commands.scd_bots or {}
	local attempts = 0
	local maxAttempts = 40 -- 40 * 0.5 с = 20 с
	local heroSpawned = false
	local spawnedHero = nil
	local raceTries = 0
	Timers:CreateTimer(0.5, function()
		attempts = attempts + 1

		local botid = nil
		for i = 0, 23 do
			if before[i] == nil and i ~= id and PlayerResource:IsValidPlayerID(i) then
				botid = i
				break
			end
		end
		if botid == nil then
			if attempts >= maxAttempts then
				print("[SCD-OFFLINE] scd_add_bot: no new player appeared in 20 s - the engine refused"
					.. " to add a bot to a running match (see the report for the fallback plan)")
				return nil
			end
			return 0.5
		end

		local botTeam = PlayerResource:GetTeam(botid)
		local info = _G.playersinfo[botid]
		if info == nil then
			-- игрок есть, базы нет: значит герой не заспавнился, а база создаётся именно по
			-- npc_spawned реального героя (SCGameMode:OnNPCSpawned). Создаём форс-героя сами -
			-- путь тот же, и он сам же его убьёт, как у обычных игроков.
			if not heroSpawned and attempts >= 3 then
				heroSpawned = true
				local botPlayer = PlayerResource:GetPlayer(botid)
				local hero = PlayerResource:GetSelectedHeroEntity(botid)
				if hero == nil and botPlayer ~= nil then
					local okSpawn, errSpawn = pcall(function()
						spawnedHero = CreateUnitByName(heroName, Vector(0, 0, 0), true, botPlayer, botPlayer, botTeam)
					end)
					if okSpawn then
						print("[SCD-OFFLINE] scd_add_bot: engine did not spawn the bot hero - created "
							.. heroName .. " for pid=" .. tostring(botid) .. " so OnNPCSpawned builds its base")
					else
						print("[SCD-OFFLINE] scd_add_bot: CreateUnitByName FAILED: " .. tostring(errSpawn))
					end
				elseif hero == nil then
					print("[SCD-OFFLINE] scd_add_bot: PlayerResource:GetPlayer(" .. tostring(botid)
						.. ") is nil - cannot spawn the bot hero")
				end
			end
			if attempts >= maxAttempts then
				-- не оставляем в мире stray-героя, если база так и не создалась
				if spawnedHero ~= nil and not spawnedHero:IsNull() and spawnedHero:IsAlive() then
					spawnedHero:ForceKill(false)
				end
				print("[SCD-OFFLINE] scd_add_bot: bot pid=" .. tostring(botid) .. " exists (team "
					.. tostring(botTeam) .. ") but its base was NOT created in 20 s -"
					.. " SCGameMode:OnNPCSpawned did not run for it")
				return nil
			end
			return 0.5
		end

		-- gpt выставляется циклом в фазе GAME_IN_PROGRESS, который уже отработал. Без него
		-- OnTimerThink (каждые 10 с) сделал бы ModifyGold(id, nil), а в turbo - nil * 2,
		-- то есть ошибка Lua каждые 10 секунд до конца матча.
		if type(info.gpt) ~= "number" then
			info.gpt = 60
		end

		-- раса - штатным путём (иначе race = 0 и топ-бар показывает placeholder).
		-- SelectRace внутри шлёт клиентские события через PlayerResource:GetPlayer(id);
		-- если у бота в момент вызова ещё нет объекта игрока, вызов упадёт - поэтому pcall
		-- и ровно одна повторная попытка на следующем тике.
		if info.race == nil then
			raceTries = raceTries + 1
			local okRace, errRace = pcall(function()
				-- [SCD-FIX] Глобальный SCGameMode из контекста commands.lua виден как nil:
				-- живой прогон дал "attempt to index global 'SCGameMode' (a nil value)"
				-- на обеих попытках, при этом внутри addon_game_mode.lua тот же вызов
				-- работает (строки 1295, 949, 952). Рабочий путь - ЭКЗЕМПЛЯР
				-- GameRules.AddonTemplate, создаваемый в addon_game_mode.lua:382; ровно
				-- так вызывает SelectRace авторская команда select_race (строка 343).
				local mode = GameRules.AddonTemplate or SCGameMode
				if mode == nil then
					error("neither GameRules.AddonTemplate nor SCGameMode is available")
				end
				mode:SelectRace({ PlayerID = botid, race = race })
			end)
			if not okRace then
				print("[SCD-OFFLINE] scd_add_bot: SelectRace attempt " .. tostring(raceTries)
					.. " FAILED: " .. tostring(errRace))
			end
			if info.race == nil and raceTries < 2 and attempts < maxAttempts then
				return 0.5
			end
		end

		local barracks = 0
		for _ in pairs(info.baracks or {}) do
			barracks = barracks + 1
		end
		local barracksTotal = 0
		for _ in pairs(info.all_baracks or {}) do
			barracksTotal = barracksTotal + 1
		end
		Commands.scd_bots[botid] = { team = botTeam, race = info.race }
		if botTeam == callerTeam then
			-- Переназначать команду через SetCustomTeamAssignment уже ПОСЛЕ создания базы
			-- нельзя: здания созданы на команде, которая была в момент npc_spawned, и они
			-- останутся на старой. Поэтому только предупреждаем.
			print("[SCD-OFFLINE] scd_add_bot: WARNING - the bot landed on the caller's team "
				.. tostring(botTeam) .. ", so enemy-building abilities will not target it")
		end
		print("[SCD-OFFLINE] scd_add_bot: bot ready pid=" .. tostring(botid)
			.. " team=" .. tostring(botTeam)
			.. " race=" .. tostring(info.race)
			.. " base_pos=" .. tostring(info.base_pos)
			.. " barracks=" .. tostring(barracks) .. "/" .. tostring(barracksTotal)
			.. " ancient=" .. tostring(info.ancient ~= nil and not info.ancient:IsNull())
			.. " gpt=" .. tostring(info.gpt)
			.. " (top bar slot should appear within 0.2 s)")
		return nil
	end)
end

-- ============================================================================
-- [SCD-PERF] Инструменты замера производительности (dev-команды).
--
-- ЗАЧЕМ. Падение FPS к концу матча объяснялось декоративными моделями (prop_dynamic),
-- которые units_core.lua вешал на КАЖДОГО крипа из def_wearables в races.kv (50
-- не-геройских блоков по 4-5 предметов, в среднем ~2.6 модели на крипа). Фикс
-- отключает их у не-героев флагом _G.SCD_CREEP_COSMETICS.
--
-- Эти команды позволяют сравнить «как было» и «как стало» В ОДНОМ МАТЧЕ, а не
-- перезапуская две разные сборки: флаг переключается в рантайме.
--
-- Команды (консоль Dota):
--   scd_spawn_waves <N> [интервал_сек=5] [неуязвимые=0]
--   scd_spawn_waves stop
--   scd_cosmetics <on|off|status>
--   scd_perf                - текущая нагрузка: юниты, prop_dynamic, состояние флага
--   scd_kill_creeps         - убрать всех крипов (герои и здания не трогаются)
--
-- Порядок честного сравнения (иначе нагрузка в двух замерах не совпадёт):
--   scd_kill_creeps
--   scd_cosmetics on            <- вид как в оригинале
--   scd_spawn_waves 50 5        <- замерить FPS
--   scd_kill_creeps
--   scd_cosmetics off           <- фикс
--   scd_spawn_waves 50 5        <- замерить FPS
--
-- Волны спавнятся НАСТОЯЩИМ путём - unit_barrack_core_mod:SpawnUnits() на каждом
-- бараке каждого игрока. Это принципиально: прямой CreateUnitByName крипов ЧУЖОЙ расы
-- ронял units_core.lua:21 (unitsinfo[unit_name] = nil) и до Wearable:Wear дело не
-- доходило, то есть косметика не надевалась вовсе и замерялась не та игра - такие
-- крипы выходили заметно дешевле настоящих (459 живых -> 19-25 FPS против 437 -> 7.8).
--
-- FPS этими командами НЕ измеряется: в API панорамы частоты кадров нет. Смотреть
-- встроенным счётчиком Dota (в консоли клиента: cl_showfps 2) либо сэмплером
-- _dsh/inject_fps_sampler.py, который печатает [SCD-FPS] раз в 5 секунд.
--
-- Гейт тот же, что у остальных scd_-команд: автономная сборка + _G.SCD_IsDevPlayer.
-- ============================================================================

local function SCD_PerfGate(cmdName)
	if not _G.SCD_OFFLINE then
		print("[SCD-PERF] " .. cmdName .. ": available only in the offline build")
		return nil
	end
	local cmdPlayer
	if IsInToolsMode() then
		cmdPlayer = PlayerResource:GetPlayer(0)
	else
		cmdPlayer = Convars:GetCommandClient()
	end
	-- GetCommandClient() в этой сборке возвращает объект без GetPlayerID, поэтому резолвим
	-- общим помощником (см. _G.SCD_ResolveCallerID в шапке файла)
	local id, how = _G.SCD_ResolveCallerID(cmdPlayer)
	if id == nil then
		print("[SCD-PERF] " .. cmdName .. ": cannot resolve the calling player (" .. tostring(how) .. ")")
		return nil
	end
	if not _G.SCD_IsDevPlayer(id) then
		print("[SCD-PERF] " .. cmdName .. ": access denied for player " .. tostring(id))
		return nil
	end
	return id
end

local function SCD_PerfFindAll(classname)
	local ok, list = pcall(function() return Entities:FindAllByClassname(classname) end)
	if ok and list then return list end
	return {}
end

-- Здания аддона называются npc_dota_custom_* (их 12 из 295 определений), герои рас
-- содержат "_hero". Всё остальное с классом npc_dota_creature - крипы.
local function SCD_PerfIsCreep(u)
	local nm = u.GetUnitName and u:GetUnitName()
	if not nm then return false end
	if string.find(nm, "^npc_dota_custom_") then return false end
	if string.find(nm, "_hero", 1, true) then return false end
	return true
end

-- Критерий героя - ИМЯ, а не только IsRealHero(): живой замер показал, что у героя расы
-- (npc_dota_dragons_hero_mage_spec) IsRealHero() == false, потому что это
-- npc_dota_creature, а не настоящий герой Dota.
local function SCD_PerfIsHero(u)
	local nm = (u.GetUnitName and u:GetUnitName()) or ""
	if string.find(nm, "_hero", 1, true) then return true end
	return (u.IsRealHero and u:IsRealHero()) and true or false
end

local function SCD_PerfCountProps()
	local n = 0
	for _ in pairs(SCD_PerfFindAll("prop_dynamic")) do n = n + 1 end
	return n
end

local function SCD_PerfLoad()
	local alive, creeps, heroes = 0, 0, 0
	for _, u in pairs(SCD_PerfFindAll("npc_dota_creature")) do
		if u.IsAlive and u:IsAlive() then
			alive = alive + 1
			if SCD_PerfIsHero(u) then heroes = heroes + 1
			elseif SCD_PerfIsCreep(u) then creeps = creeps + 1 end
		end
	end
	return alive, creeps, heroes
end

-- Один раунд = SpawnUnits на всех живых бараках всех игроков.
local function SCD_PerfSpawnRound(invuln)
	local barracks, pinned = 0, 0
	for pid = 0, 7 do
		local info = _G.playersinfo and _G.playersinfo[pid]
		if info then
			for _, b in pairs(info.baracks or {}) do
				if b and not b:IsNull() and b.IsAlive and b:IsAlive() then
					local mod = b:FindModifierByName("unit_barrack_core_mod")
					if mod and mod.SpawnUnits then
						-- Точку спавна выставляет unit_barrack_core_mod:StartGame(), а это НЕ
						-- штатный колбэк модификатора: его один раз зовёт цикл по _G.onstartgame
						-- на старте матча. До этого момента caster.creepspawnpoint == nil и
						-- CreateUnitByName падает с нечитаемым "Parameter type mismatch"
						-- (unit_barrack_core.lua:128). Добираем точку по той же авторской
						-- формуле (unit_barrack_core.lua:43-44), а не подменяем логику.
						if b.creepspawnpoint == nil and b.GetAbsOrigin then
							b.creepspawnpoint = b:GetAbsOrigin() + b:GetForwardVector() * 100
							b.herospawnpoint = b:GetAbsOrigin() - b:GetForwardVector() * 100
						end
						barracks = barracks + 1
						local ok, err = pcall(mod.SpawnUnits, mod)
						if not ok then
							print("[SCD-PERF] SpawnUnits на бараке игрока " .. tostring(pid)
								.. " упал: " .. tostring(err))
						end
					end
				end
			end
		end
	end
	if invuln then
		for _, u in pairs(SCD_PerfFindAll("npc_dota_creature")) do
			if u.IsAlive and u:IsAlive() and SCD_PerfIsCreep(u)
					and not u:HasModifier("modifier_invulnerable") then
				pcall(function() u:AddNewModifier(u, nil, "modifier_invulnerable", {}) end)
				pinned = pinned + 1
			end
		end
	end
	return barracks, pinned
end

-- Серия волн хранится по id вызвавшего: повторный вызов ЗАМЕНЯЕТ прежнюю серию,
-- а не добавляет вторую поверх (иначе две серии спавнили бы вдвое чаще).
Commands.scd_wave_jobs = Commands.scd_wave_jobs or {}

function Commands:SCDSpawnWaves(...)
	local argv = { ... }
	local argc = select("#", ...)
	local ok, err = pcall(function()
		return Commands:SCDSpawnWavesImpl(unpack(argv, 1, argc))
	end)
	if not ok then
		print("[SCD-PERF] scd_spawn_waves FAILED: " .. tostring(err))
	end
end

function Commands:SCDSpawnWavesImpl(...)
	local id = SCD_PerfGate("scd_spawn_waves")
	if id == nil then return end

	-- часть сборок передаёт первым аргументом имя команды - отсекаем, чтобы числа не съехали
	local args = { ... }
	if args[1] == "scd_spawn_waves" then table.remove(args, 1) end

	if string.lower(tostring(args[1] or "")) == "stop" then
		if Commands.scd_wave_jobs[id] then
			Commands.scd_wave_jobs[id] = nil
			print("[SCD-PERF] scd_spawn_waves: серия игрока " .. tostring(id) .. " остановлена")
		else
			print("[SCD-PERF] scd_spawn_waves: у игрока " .. tostring(id) .. " нет запущенной серии")
		end
		return
	end

	local waves = tonumber(args[1])
	if not waves or waves < 1 then
		print("[SCD-PERF] usage: scd_spawn_waves <кол-во волн> [интервал_сек=5] [неуязвимые=0] | stop")
		print("[SCD-PERF]   неуязвимые=1 замораживает число крипов (они не умирают) - нагрузка")
		print("[SCD-PERF]   стабильная и два замера сравнимы, но это не похоже на живой матч;")
		print("[SCD-PERF]   неуязвимые=0 (по умолчанию) - обычная игра, крипы воюют и гибнут.")
		return
	end
	waves = math.floor(waves)
	local interval = tonumber(args[2]) or 5
	if interval < 0.5 then interval = 0.5 end
	local invuln = (tonumber(args[3]) or 0) ~= 0

	local alive0, creeps0 = SCD_PerfLoad()
	Commands.scd_wave_jobs[id] = { left = waves, total = waves, interval = interval, invuln = invuln }
	print(string.format("[SCD-PERF] scd_spawn_waves: %d волн с интервалом %.1f с, неуязвимые=%s, SCD_CREEP_COSMETICS=%s; сейчас живых %d (крипов %d), prop_dynamic %d",
		waves, interval, tostring(invuln), tostring(not not _G.SCD_CREEP_COSMETICS),
		alive0, creeps0, SCD_PerfCountProps()))

	Timers:CreateTimer(0, function()
		local job = Commands.scd_wave_jobs[id]
		if not job then return nil end          -- отменено через scd_spawn_waves stop
		local barracks, pinned = SCD_PerfSpawnRound(job.invuln)
		job.left = job.left - 1
		local alive, creeps = SCD_PerfLoad()
		print(string.format("[SCD-PERF] волна %d/%d: бараков %d, живых %d (крипов %d), prop_dynamic %d%s",
			job.total - job.left, job.total, barracks, alive, creeps, SCD_PerfCountProps(),
			pinned > 0 and (", сделано неуязвимыми " .. pinned) or ""))
		if job.left <= 0 then
			Commands.scd_wave_jobs[id] = nil
			print(string.format("[SCD-PERF] scd_spawn_waves: готово, %d волн. Итог: живых %d (крипов %d), prop_dynamic %d",
				job.total, alive, creeps, SCD_PerfCountProps()))
			return nil
		end
		return job.interval
	end)
end

function Commands:SCDCosmetics(...)
	local argv = { ... }
	local argc = select("#", ...)
	local ok, err = pcall(function()
		return Commands:SCDCosmeticsImpl(unpack(argv, 1, argc))
	end)
	if not ok then
		print("[SCD-PERF] scd_cosmetics FAILED: " .. tostring(err))
	end
end

function Commands:SCDCosmeticsImpl(...)
	local id = SCD_PerfGate("scd_cosmetics")
	if id == nil then return end

	local args = { ... }
	if args[1] == "scd_cosmetics" then table.remove(args, 1) end
	local mode = string.lower(tostring(args[1] or "status"))

	if mode == "status" then
		local alive, creeps, heroes = SCD_PerfLoad()
		print(string.format("[SCD-PERF] scd_cosmetics: SCD_CREEP_COSMETICS = %s (%s); живых %d (крипов %d, героев %d), prop_dynamic %d",
			tostring(not not _G.SCD_CREEP_COSMETICS),
			_G.SCD_CREEP_COSMETICS and "вид как в оригинале" or "фикс: крипы без декоративных моделей",
			alive, creeps, heroes, SCD_PerfCountProps()))
		return
	end
	if mode ~= "on" and mode ~= "off" then
		print("[SCD-PERF] usage: scd_cosmetics on|off|status")
		print("[SCD-PERF]   on  = декоративные модели крипов создаются (вид как в оригинале)")
		print("[SCD-PERF]   off = не создаются (фикс FPS); герои рас косметику сохраняют всегда")
		return
	end

	_G.SCD_CREEP_COSMETICS = (mode == "on")
	print(string.format("[SCD-PERF] scd_cosmetics %s -> SCD_CREEP_COSMETICS = %s",
		mode, tostring(not not _G.SCD_CREEP_COSMETICS)))
	print("[SCD-PERF] Влияет только на ВПЕРЁД создаваемых юнитов: уже живые крипы не")
	print("[SCD-PERF] переодеваются. Для сравнения сначала scd_kill_creeps, потом волны.")
end

function Commands:SCDPerf(...)
	-- '...' НЕЛЬЗЯ передавать внутрь вложенной не-vararg функции: Lua 5.1 отвечает
	-- "cannot use '...' outside a vararg function" и отвергает ВЕСЬ файл. Аргументы
	-- сначала захватываются в локальные переменные -- приём тот же, что в SCDSpawnWaves
	-- и в авторском SCDAddBot. Ошибку не ловит luaparser (_dsh/lua_check.py), её видно
	-- только настоящим компилятором (_dsh/lua51_check.py).
	local argv = { ... }
	local argc = select("#", ...)
	local ok, err = pcall(function()
		return Commands:SCDPerfImpl(unpack(argv, 1, argc))
	end)
	if not ok then
		print("[SCD-PERF] scd_perf FAILED: " .. tostring(err))
	end
end

function Commands:SCDPerfImpl(...)
	local id = SCD_PerfGate("scd_perf")
	if id == nil then return end

	local alive, creeps, heroes = SCD_PerfLoad()
	local props = SCD_PerfCountProps()
	local ft = 0
	pcall(function() ft = GameRules:GetGameFrameTime() or 0 end)
	print(string.format("[SCD-PERF] живых юнитов %d (крипов %d, героев %d) | prop_dynamic %d (%.2f на крипа) | SCD_CREEP_COSMETICS=%s | кадр сервера %.2f мс",
		alive, creeps, heroes, props, creeps > 0 and (props / creeps) or 0,
		tostring(not not _G.SCD_CREEP_COSMETICS), ft * 1000))
	local running = 0
	for _ in pairs(Commands.scd_wave_jobs or {}) do running = running + 1 end
	if running > 0 then
		print("[SCD-PERF] запущенных серий волн: " .. tostring(running) .. " (остановка: scd_spawn_waves stop)")
	end
	print("[SCD-PERF] FPS здесь не меряется: включи cl_showfps 2 в консоли клиента или сэмплер _dsh/inject_fps_sampler.py ([SCD-FPS] раз в 5 с)")
end

function Commands:SCDKillCreeps(...)
	local argv = { ... }
	local argc = select("#", ...)
	local ok, err = pcall(function()
		return Commands:SCDKillCreepsImpl(unpack(argv, 1, argc))
	end)
	if not ok then
		print("[SCD-PERF] scd_kill_creeps FAILED: " .. tostring(err))
	end
end

function Commands:SCDKillCreepsImpl(...)
	local id = SCD_PerfGate("scd_kill_creeps")
	if id == nil then return end

	local before = SCD_PerfCountProps()
	local removed = 0
	for _, u in pairs(SCD_PerfFindAll("npc_dota_creature")) do
		if u.IsAlive and u:IsAlive() and SCD_PerfIsCreep(u) then
			-- неуязвимость снимается первой, иначе юнит не убрать
			pcall(function() u:RemoveModifierByName("modifier_invulnerable") end)
			local done = false
			pcall(function() UTIL_Remove(u) done = true end)
			if not done then
				pcall(function() u:ForceKill(false) end)
			end
			removed = removed + 1
		end
	end
	-- пропы косметики движок убирает вместе с владельцем (проверено: после ForceKill
	-- 369 крипов prop_dynamic упал с 1196 до 111, осиротевших 0)
	local alive, creeps, heroes = SCD_PerfLoad()
	print(string.format("[SCD-PERF] scd_kill_creeps: убрано крипов %d; prop_dynamic %d -> %d; осталось живых %d (крипов %d, героев %d)",
		removed, before, SCD_PerfCountProps(), alive, creeps, heroes))
end
