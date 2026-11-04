require "bit"

BattlePasses = {}
BattlePasses.pass_name = "9"
BattlePasses.vip_level = 2
BattlePasses.playersData = {}
BattlePasses.PlayersLoaded = false

function BattlePasses:Init()
	BattlePasses.battlepasses = LoadKeyValues("scripts/kv/battlepasses.kv")
	local pass = BattlePasses.battlepasses[BattlePasses.pass_name]

	for i=1, pass.MaxLevel do
		local levelrew = pass.Rewards[tostring(i)]
		if levelrew then
			if levelrew.FreeRewards then
				local index = 1
				while levelrew.FreeRewards[tostring(index)] do
					local item = levelrew.FreeRewards[tostring(index)]
					if item.type == "item" then
						if not Store.items[item.name] then
							print("ERROR: item "..item.name.." not found!")
						else
							item.icon = Store.items[item.name].image
						end
					elseif item.type == "coins" then
						if item.count <= 500 then
							item.icon = "file://{images}/custom_game/battlepass/items/coins500.png"
						elseif item.count <= 1500 then
							item.icon = "file://{images}/custom_game/battlepass/items/coins1500.png"
						else
							item.icon = "file://{images}/custom_game/battlepass/items/coins4500.png"
						end
					elseif item.type == "ecoins" then
						if item.count <= 60 then
							item.icon = "file://{images}/custom_game/battlepass/items/ecoins60.png"
						elseif item.count <= 120 then
							item.icon = "file://{images}/custom_game/battlepass/items/ecoins120.png"
						else
							item.icon = "file://{images}/custom_game/battlepass/items/ecoins220.png"
						end
					elseif item.type == "chest" then
						if not Chests.chests[item.name] then
							print("ERROR: chest "..item.name.." not found!")
						else
							item.icon = Chests.chests[item.name].image
						end
					elseif item.type == "xpboost" then
						item.icon = "file://{images}/custom_game/battlepass/items/xpbooster.png"
					end
					index = index + 1
				end
			end
			if levelrew.VipRewards then
				local index = 1
				while levelrew.VipRewards[tostring(index)] do
					local item = levelrew.VipRewards[tostring(index)]
					if item.type == "item" then
						item.icon = Store.items[item.name].image
					elseif item.type == "coins" then
						if item.count <= 500 then
							item.icon = "file://{images}/custom_game/battlepass/items/coins500.png"
						elseif item.count <= 1500 then
							item.icon = "file://{images}/custom_game/battlepass/items/coins1500.png"
						else
							item.icon = "file://{images}/custom_game/battlepass/items/coins4500.png"
						end
					elseif item.type == "ecoins" then
						if item.count <= 60 then
							item.icon = "file://{images}/custom_game/battlepass/items/ecoins60.png"
						elseif item.count <= 120 then
							item.icon = "file://{images}/custom_game/battlepass/items/ecoins120.png"
						else
							item.icon = "file://{images}/custom_game/battlepass/items/ecoins220.png"
						end
					elseif item.type == "chest" then
						item.icon = Chests.chests[item.name].image
					elseif item.type == "xpboost" then
						item.icon = "file://{images}/custom_game/battlepass/items/xpbooster.png"
					end
					index = index + 1
				end
			end
		end
	end

	pass.xp = {}
	pass.xp[1] = 100
	for i=2, 10 do
		pass.xp[i] = pass.xp[i-1] + 100--1000
	end
	for i=11, 20 do
		pass.xp[i] = pass.xp[i-1] + 150--2500
	end
	for i=21, 40 do
		pass.xp[i] = pass.xp[i-1] + 200--6500
	end
	for i=41, 60 do
		pass.xp[i] = pass.xp[i-1] + 250--11500
	end
	for i=61, 80 do
		pass.xp[i] = pass.xp[i-1] + 300--17500
	end
	for i=81, 100 do
		pass.xp[i] = pass.xp[i-1] + 450--26500
	end

    CustomGameEventManager:RegisterListener( "get_battlepass", function( _, data )
		if data.PlayerID ~= nil then
			local player = PlayerResource:GetPlayer( data.PlayerID )

			if player then
				CustomGameEventManager:Send_ServerToPlayer( player, "load_battlepass", BattlePasses.battlepasses[BattlePasses.pass_name] )
			end

			if BattlePasses.PlayersLoaded then
				BattlePasses:UpdatePlayer(data.PlayerID)
			end
		end
	end )

	CustomGameEventManager:RegisterListener( "battlepass_get_reward", Dynamic_Wrap(BattlePasses, 'TryGetReward'))

	CustomGameEventManager:RegisterListener( "battlepass_get_all_rewards", Dynamic_Wrap(BattlePasses, 'TryGetAllRewards'))

	CustomGameEventManager:RegisterListener( "battlepass_get_vip_exp", Dynamic_Wrap(BattlePasses, 'TryGetVipXP'))

end

function BattlePasses:TryGetVipXP(data)
	local id = data.PlayerID
	if id and BattlePasses.playersData[id].vipexp > 0 then
		if BattlePasses:IsVIP(id) then
			BattlePasses.playersData[id].exp = BattlePasses.playersData[id].exp + BattlePasses.playersData[id].vipexp
			BattlePasses.playersData[id].vipexp = 0
			BattlePasses:UpdatePlayer(id)
			local vipexptr = WebBD:CreateTransaction()
			vipexptr:Set("UPDATE `battlepasses__"..BattlePasses.pass_name.."` SET `exp`=`exp`+"..BattlePasses.playersData[id].vipexp..", `vipexp`=0 WHERE `id`="..PlayerResource:GetSteamAccountID(id))
			vipexptr:Commit()
		else
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "display_custom_error", { message = "#battlepass_need_vip" })
		end
	end
end

function BattlePasses:TryGetReward(data)
	local id = data.PlayerID
	local itemID = data.itemID
	if id and not BattlePasses.playersData[id].cantget and itemID then
		if BattlePasses:GetItemAvailable(id, itemID) then
			BattlePasses.playersData[id].cantget = true
			local item = BattlePasses:GetItem(itemID)
			BattlePasses.playersData[id].data[itemID] = true
			local tr = WebBD:CreateTransaction()
			tr:Set("UPDATE `battlepasses__"..BattlePasses.pass_name.."` SET `data` = '"..json.encode(BattlePasses.playersData[id].data).."' WHERE `id`="..PlayerResource:GetSteamAccountID(id))
			
			if item.type == "item" then
				Store.playersData[id].itemsData.playerOwns[item.name] = true
				Store:UpdatePlayerOwns(id)
				Store:Save(id, tr)
			elseif item.type == "coins" then
				Store.playersData[id].coins = Store.playersData[id].coins + item.count
				Store:UpdatePlayer( id )
				Store:Save(id, tr)
			elseif item.type == "ecoins" then
				Store.playersData[id].ecoins = Store.playersData[id].ecoins + item.count
				Store:UpdatePlayer( id )
				Store:Save(id, tr)
			elseif item.type == "chest" then
				Chests:AddChest(id, item.name, 1, tr)
			elseif item.type == "xpboost" then
				tr:Set("INSERT INTO `bp_xp_boosters` (`id`, `count`) VALUES ("..PlayerResource:GetSteamAccountID(id)..", "..item.count..") ON DUPLICATE KEY UPDATE `count`=`count`+"..item.count)
			end

			tr:Commit(function(result)
				BattlePasses.playersData[id].cantget = nil
			end)
			BattlePasses:UpdatePlayer(id)
		end
	end
end

function BattlePasses:TryGetAllRewards(data)
	local id = data.PlayerID
	if id and not BattlePasses.playersData[id].cantget and not BattlePasses.playersData[id].cantgetall then
		local tr = WebBD:CreateTransaction()
		local isvip = BattlePasses:IsVIP(id)
		local level = 1

		local store_UpdatePlayerOwns = false
		local store_UpdatePlayer = false
		local store_Save = false

		local playerexp = BattlePasses.playersData[id].exp
		while playerexp >= BattlePasses.battlepasses[BattlePasses.pass_name].xp[level] do
			local levelrew = BattlePasses.battlepasses[BattlePasses.pass_name].Rewards[tostring(level)]
			if levelrew then
				if levelrew.FreeRewards then
					local index = 1
					while levelrew.FreeRewards[tostring(index)] do
						local item = levelrew.FreeRewards[tostring(index)]
						local itemID = BattlePasses:GetItemID(level, isvip, index)
						
						if BattlePasses:GetItemAvailable(id, itemID) then
							BattlePasses.playersData[id].data[itemID] = true
							if item.type == "item" then
								Store.playersData[id].itemsData.playerOwns[item.name] = true
								store_UpdatePlayerOwns = true
								store_Save = true
							elseif item.type == "coins" then
								Store.playersData[id].coins = Store.playersData[id].coins + item.count
								store_UpdatePlayer = true
								store_Save = true
							elseif item.type == "ecoins" then
								Store.playersData[id].ecoins = Store.playersData[id].ecoins + item.count
								store_UpdatePlayer = true
								store_Save = true
							elseif item.type == "chest" then
								Chests:AddChest(id, item.name, 1, tr)
							elseif item.type == "xpboost" then
								tr:Set("INSERT INTO `bp_xp_boosters` (`id`, `count`) VALUES ("..PlayerResource:GetSteamAccountID(id)..", "..item.count..") ON DUPLICATE KEY UPDATE `count`=`count`+"..item.count)
							end
						end

						index = index + 1
					end
				end
				if isvip and levelrew.VipRewards then
					local index = 1
					while levelrew.VipRewards[tostring(index)] do
						local item = levelrew.VipRewards[tostring(index)]
						
						if BattlePasses:GetItemAvailable(id, itemID) then
							BattlePasses.playersData[id].data[itemID] = true
							if item.type == "item" then
								Store.playersData[id].itemsData.playerOwns[item.name] = true
								store_UpdatePlayerOwns = true
								store_Save = true
							elseif item.type == "coins" then
								Store.playersData[id].coins = Store.playersData[id].coins + item.count
								store_UpdatePlayer = true
								store_Save = true
							elseif item.type == "ecoins" then
								Store.playersData[id].ecoins = Store.playersData[id].ecoins + item.count
								store_UpdatePlayer = true
								store_Save = true
							elseif item.type == "chest" then
								Chests:AddChest(id, item.name, 1, tr)
							elseif item.type == "xpboost" then
								tr:Set("INSERT INTO `bp_xp_boosters` (`id`, `count`) VALUES ("..PlayerResource:GetSteamAccountID(id)..", "..item.count..") ON DUPLICATE KEY UPDATE `count`=`count`+"..item.count)
							end
						end

						index = index + 1
					end
				end
			end
			playerexp = playerexp - BattlePasses.battlepasses[BattlePasses.pass_name].xp[level]
			local level = level + 1
		end
		BattlePasses.playersData[id].cantget = true
		BattlePasses.playersData[id].cantgetall = true

		tr:Set("UPDATE `battlepasses__"..BattlePasses.pass_name.."` SET `data` = '"..json.encode(BattlePasses.playersData[id].data).."' WHERE `id`="..PlayerResource:GetSteamAccountID(id))
		
		if store_UpdatePlayerOwns then
			Store:UpdatePlayerOwns(id)
		end
		if store_UpdatePlayer then
			Store:UpdatePlayer( id )
		end
		if store_Save then
			Store:Save(id, tr)
		end

		tr:Commit(function(result)
			BattlePasses.playersData[id].cantget = nil
		end)
		BattlePasses:UpdatePlayer(id)
	end
end

function BattlePasses:GetItemID(level, vip, index)
	local vipNum = 0
	if vip then
		vipNum = 1
	end
	return bit.bor(bit.bor(bit.lshift(level,16),bit.lshift(vipNum,15)),index)
end

function BattlePasses:GetItem(itemID)
	local level = bit.rshift(itemID, 16)
	local isVip = bit.rshift(itemID, 15) % 2
	local index = itemID % bit.lshift(1, 15)
	local vipstr = "FreeRewards"
	if isVip == 1 then
		vipstr = "VipRewards"
	end
	return BattlePasses.battlepasses[BattlePasses.pass_name].Rewards[tostring(level)][vipstr][tostring(index)]
end

function BattlePasses:GetItemAvailable(id, itemID)
	if BattlePasses.playersData[id].data[itemID] then
		return false
	end
	local isVip = bit.rshift(itemID, 15) % 2
	if isVip == 1 and not BattlePasses:IsVIP(id) then
		return false
	end
	local level = bit.rshift(itemID, 16)
	return BattlePasses.playersData[id].exp >= BattlePasses.battlepasses[BattlePasses.pass_name].xp[level]
end

function BattlePasses:IsVIP(id)
	if PlayerResource:IsValidPlayerID(id) then
		return (_G.patreons[tostring(PlayerResource:GetSteamAccountID(id))] or 0) >= BattlePasses.vip_level
	end
end

function BattlePasses:UpdatePlayer(id)
	if PlayerResource:IsValidPlayerID(id) then
		local player = PlayerResource:GetPlayer( id )

		if player then
			CustomGameEventManager:Send_ServerToPlayer( player, "battlepasses_update_player", {
				exp = BattlePasses.playersData[id].exp,
				vipexp = BattlePasses.playersData[id].vipexp,
				vip = BattlePasses:IsVIP(id),
				data = BattlePasses.playersData[id].data
			} )
		end
	end
end

function BattlePasses:LoadPlayers()
	local tr = WebBD:CreateTransaction()
	local plc = PlayerResource:GetPlayerCount()
	for i=0, plc-1 do
		BattlePasses.playersData[i] = {}
		tr:Get("SELECT exp,vipexp,data FROM `battlepasses__"..BattlePasses.pass_name.."` WHERE `id`="..PlayerResource:GetSteamAccountID(i))
	end
	for i=0, plc-1 do
		tr:Get("SELECT count FROM `bp_xp_boosters` WHERE `id`="..PlayerResource:GetSteamAccountID(i))
	end
	tr:Commit(function(expdata)
		DeepPrintTable(expdata)
		for i=1, plc do
			if expdata[tostring(i)] and expdata[tostring(i)][1] then
				BattlePasses.playersData[i-1].exp = tonumber(expdata[tostring(i)][1].exp)
				BattlePasses.playersData[i-1].vipexp = tonumber(expdata[tostring(i)][1].vipexp)
				BattlePasses.playersData[i-1].data = json.decode(expdata[tostring(i)][1].data) or {}
			else
				BattlePasses.playersData[i-1].exp = 0
				BattlePasses.playersData[i-1].vipexp = 0
				BattlePasses.playersData[i-1].data = {}
			end
			BattlePasses:UpdatePlayer(i-1)
		end
		for i=1, plc do
			local new_index = i+plc
			if expdata[tostring(new_index)] and expdata[tostring(new_index)][1] and expdata[tostring(new_index)][1].count then
				BattlePasses.playersData[i-1].boosted = tonumber(expdata[tostring(new_index)][1].count) > 0
			else
				BattlePasses.playersData[i-1].boosted = false
			end
			print(BattlePasses.playersData[i-1].boosted)
		end
		BattlePasses.PlayersLoaded = true
	end)
end

function BattlePasses:AddExp(playerID, pass_name, exp, vipexp)
	local tr = WebBD:CreateTransaction()
	tr:Set("INSERT INTO `battlepasses__"..pass_name.."` (`id`, `exp`, `vipexp`) VALUES ("..PlayerResource:GetSteamAccountID(playerID)..", "..exp..", "..vipexp..") ON DUPLICATE KEY UPDATE `exp`=`exp`+"..exp..", `vipexp`=`vipexp`+"..vipexp)
	tr:Commit(--[[function(result)
		DeepPrintTable(result)
	end]])
end

function BattlePasses:OnPlayerDefeat(id, place, winner)
	local plc = PlayerResource:GetPlayerCount()
	if not GameRules:IsCheatMode() and (GameRules:GetDOTATime(false,false) > 1200) and plc == 4 then--(GameRules:GetDOTATime(false,false) > 600 and _G.turbo) or 
		local place_xp = nil
		local bonus = 0
		-- if not _G.duos then
		-- 	if not _G.turbo then
				if GameRules:GetDOTATime(false,false) > 2400 then
					--if 40 < time < 60 (min)
					place_xp = {
						{133, 265},
						{106, 212},
						{106, 212},
						{85, 170}
					}
				else--if 20 < time < 40 (min)
					place_xp = {
						{160, 320},
						{133, 266},
						{133, 266},
						{106, 212}
					}
				end

				local isvip = BattlePasses:IsVIP(id)
				local player_xp = place_xp[place]
				if BattlePasses.playersData[id].boosted then
					player_xp[1] = player_xp[1] * 2
					player_xp[2] = player_xp[2] * 2
					local tr = WebBD:CreateTransaction()
					tr:Set("UPDATE `bp_xp_boosters` SET `count`='count'-1 WHERE `id`="..PlayerResource:GetSteamAccountID(id))
					tr:Commit()
				end
				if isvip then
					BattlePasses:AddExp(id, BattlePasses.pass_name, player_xp[2], 0)
				else
					BattlePasses:AddExp(id, BattlePasses.pass_name, player_xp[1], player_xp[2] - player_xp[1])
				end
				if winner then
					local isvipwinner = BattlePasses:IsVIP(winner)
					local winner_xp = place_xp[1]
					if BattlePasses.playersData[winner].boosted then
						winner_xp[1] = winner_xp[1] * 2
						winner_xp[2] = winner_xp[2] * 2
						local tr = WebBD:CreateTransaction()
						tr:Set("UPDATE `bp_xp_boosters` SET `count`='count'-1 WHERE `id`="..PlayerResource:GetSteamAccountID(winner))
						tr:Commit()
					end
					if isvipwinner then
						BattlePasses:AddExp(winner, BattlePasses.pass_name, winner_xp[2], 0)
					else
						BattlePasses:AddExp(winner, BattlePasses.pass_name, winner_xp[1], winner_xp[2] - winner_xp[1])
					end
				end
		-- 	else
				
		-- 	end
		-- else
			
		-- end
	end
end