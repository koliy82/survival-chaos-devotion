if Commands == nil then
	print ( '[Commands] creating Commands' )
	Commands = {}
	Commands.__index = Commands
end

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
    
	CustomGameEventManager:RegisterListener("StartProfiler", Dynamic_Wrap(Commands, 'UIStartProfiler'))
	CustomGameEventManager:RegisterListener("StopProfiler", Dynamic_Wrap(Commands, 'UIStopProfiler'))
    CustomGameEventManager:RegisterListener("LogProfiler", Dynamic_Wrap(Commands, 'UILogProfiler'))
    
    Commands.admins = {}
end

function Commands:AdminLogin(key, strid)
    print("AdminLogin")
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
	if cmdPlayer and (tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" or tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198090912161") then
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
	if cmdPlayer and (tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" or tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198090912161") then
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
	if cmdPlayer and tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" then
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
	if cmdPlayer and (tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" or tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198090912161" or tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198073992510") then
		if raceid ~= nil then
			GameRules.AddonTemplate:SelectRace({PlayerID = cmdPlayer:GetPlayerID(), race = tonumber(raceid)})
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
	if cmdPlayer and tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" then
        if keyid ~= nil then
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
	if cmdPlayer and tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" then
		if str ~= nil then
			print(str)
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
			_G:UpdateSelectedEntity( cmdPlayer:GetPlayerID() )
			Timers:CreateTimer(0.2, function()
				_G.selected_entity[cmdPlayer:GetPlayerID()]:AddAbility(spell):SetLevel(tonumber(lvl or "1"))
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
	local playerID = cmdPlayer:GetPlayerID()
	if cmdPlayer and (tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" or tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198090912161"  or tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198107820614") then
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
	local playerID = cmdPlayer:GetPlayerID()
	if cmdPlayer and (tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" or tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198090912161" or tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198107820614") then
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
	local playerID = cmdPlayer:GetPlayerID()
	if cmdPlayer and (tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" or tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198090912161"  or tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198107820614") then
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
	if cmdPlayer and (tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" or tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198070071399"  or tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198107820614") then
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
	if cmdPlayer and (tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" or tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198070071399"  or tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198107820614") then
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
	if cmdPlayer and (tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" or tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198070071399"  or tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198107820614") then
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
	if cmdPlayer and tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" then
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
	if cmdPlayer and tostring(PlayerResource:GetSteamID(cmdPlayer:GetPlayerID())) == "76561198112013738" then
		CustomGameEventManager:Send_ServerToPlayer(cmdPlayer, "display_custom_error", { message = loadstring(code)()})
	end
end
