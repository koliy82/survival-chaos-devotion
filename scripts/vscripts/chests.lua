Chests = {}
Chests.playersData = {}
Chests.PlayersLoaded = true

function Chests:Init()
	Chests.chests = LoadKeyValues("scripts/kv/chests.kv")

    CustomGameEventManager:RegisterListener( "get_chests", function( _, data )
		if data.PlayerID ~= nil then
			local player = PlayerResource:GetPlayer( data.PlayerID )

			if player then
				CustomGameEventManager:Send_ServerToPlayer( player, "load_chests", Chests.chests )
			end

			if Chests.PlayersLoaded then
				Chests:UpdatePlayer(data.PlayerID)
			end
		end
	end )

	CustomGameEventManager:RegisterListener( "chests_try_open", Dynamic_Wrap(Chests, 'TryOpenChest'))

	-- CustomGameEventManager:RegisterListener( "store_equip_item", Dynamic_Wrap(Store, 'EquipItem'))

	-- CustomGameEventManager:RegisterListener( "store_purchase_item", Dynamic_Wrap(Store, 'BuyItem'))

end

function Chests:TryOpenChest(data)
	print("TryOpenChest")
	local id = data.PlayerID
	if id then
		local chest_name = data.chest_name
		local count = data.count
		if Chests.playersData[id].chests[chest_name] and count > 0 and Chests.playersData[id].chests[chest_name] >= count then
			print(count)
			Chests.playersData[id].chests[chest_name] = Chests.playersData[id].chests[chest_name] - count
			Chests:UpdatePlayer(id)
			local tr = WebBD:CreateTransaction()
			local items = {}
			for i=1, count do
				table.insert( items, Chests:OpenChest(id, chest_name, tr) )
			end
			tr:Set("UPDATE `chests` SET `"..chest_name.."`=`"..chest_name.."`-"..count.." WHERE `id`="..PlayerResource:GetSteamAccountID(id))
			tr:Commit()
			local player = PlayerResource:GetPlayer( id )
			CustomGameEventManager:Send_ServerToPlayer( player, "open_chests", items )
		end
	end
end

function Chests:OpenChest(id, chest_name, tr)
	print("OpenChest")

	local GiveStoreItem = function(id, item_name, loctr)
		if Store.playersData[id].itemsData.playerOwns[item_name] then
			if Store.items[item_name].coinsPrice > 0 then
				Store.playersData[id].coins = Store.playersData[id].coins + round(Store.items[item_name].coinsPrice * 0.25)
			elseif Store.items[item_name].eliteCoinsPrice > 0 then
				Store.playersData[id].ecoins = Store.playersData[id].ecoins + round(Store.items[item_name].eliteCoinsPrice * 0.25)
			end
			Store:UpdatePlayer(id)
		else
			Store.playersData[id].itemsData.playerOwns[item_name] = true
			Store:UpdatePlayerOwns(id)
		end
		Store:Save(id, loctr)
	end

	if chest_name == "common_chest" then
		local random = RandomInt(1, 10000)
		if random <= 2500 then
			Store.playersData[id].coins = Store.playersData[id].coins + 500
			Store:UpdatePlayer(id)
			return "file://{images}/custom_game/battlepass/items/coins500.png"
		elseif random <= 3500 then
			Store.playersData[id].coins = Store.playersData[id].coins + 1500
			Store:UpdatePlayer(id)
			return "file://{images}/custom_game/battlepass/items/coins1500.png"
		elseif random <= 4000 then
			Store.playersData[id].coins = Store.playersData[id].coins + 4500
			Store:UpdatePlayer(id)
			return "file://{images}/custom_game/battlepass/items/coins4500.png"
		elseif random <= 6000 then
			local frames = {}
			for item_name, item in pairs(Store.items) do
				if item.type == "portrait" and item.available == "buy" then
					table.insert( frames, item_name )
				end
			end
			local frame = frames[RandomInt(1, #frames)]
			GiveStoreItem(id, frame, tr)
			return Store.items[frame].image
		elseif random <= 6800 then
			local baps = {}
			for item_name, item in pairs(Store.items) do
				if item.type == "building_attack_particle" and item.available == "buy" then
					table.insert( baps, item_name )
				end
			end
			local bap = baps[RandomInt(1, #baps)]
			GiveStoreItem(id, bap, tr)
			return Store.items[bap].image
		elseif random <= 7300 then
			Store.playersData[id].ecoins = Store.playersData[id].ecoins + 60
			Store:UpdatePlayer(id)
			return "file://{images}/custom_game/battlepass/items/ecoins60.png"
		elseif random <= 7600 then
			Store.playersData[id].ecoins = Store.playersData[id].ecoins + 120
			Store:UpdatePlayer(id)
			return "file://{images}/custom_game/battlepass/items/ecoins120.png"
		elseif random <= 7800 then
			Store.playersData[id].ecoins = Store.playersData[id].ecoins + 220
			Store:UpdatePlayer(id)
			return "file://{images}/custom_game/battlepass/items/ecoins220.png"
		elseif random <= 8200 then
			local buildings = {}
			for item_name, item in pairs(Store.items) do
				if item.type == "buildings" and item.available == "buy" then
					table.insert( buildings, item_name )
				end
			end
			local buildings_item = buildings[RandomInt(1, #buildings)]
			GiveStoreItem(id, buildings_item, tr)
			return Store.items[buildings_item].image
		elseif random <= 9000 then
			local couriers = {}
			for item_name, item in pairs(Store.items) do
				if item.type == "pet" and item.available == "buy" then
					table.insert( couriers, item_name )
				end
			end
			local cour = couriers[RandomInt(1, #couriers)]
			GiveStoreItem(id, cour, tr)
			return Store.items[cour].image
		elseif random <= 9900 then
			return Chests:OpenChest(id, "set_chest")
		elseif random <= 9935 then
			GiveStoreItem(id, "race_ec_13", tr)
			return Store.items["race_ec_13"].image
		elseif random <= 9965 then
			GiveStoreItem(id, "race_ec_14", tr)
			return Store.items["race_ec_14"].image
		elseif random <= 9985 then
			GiveStoreItem(id, "race_ec_15", tr)
			return Store.items["race_ec_15"].image
		elseif random <= 9995 then
			GiveStoreItem(id, "race_ec_16", tr)
			return Store.items["race_ec_16"].image
		else
			GiveStoreItem(id, "race_ec_17", tr)
			return Store.items["race_ec_17"].image
		end
	elseif chest_name == "courier_chest" then
		local couriers = {}
		for item_name, item in pairs(Store.items) do
			if item.type == "pet" and item.available == "buy" then
				table.insert( couriers, item_name )
			end
		end
		local cour = couriers[RandomInt(1, #couriers)]
		GiveStoreItem(id, cour, tr)
		return Store.items[cour].image
	elseif chest_name == "set_chest" then
		local random = RandomInt(1, 100)
		local sets = {}
		if random <= 14 then
			for item_name, item in pairs(Store.items) do
				if item.type == "hero_set" and item.available == "buy" and item.coinsPrice == 10000 then
					table.insert( sets, item_name )
				end
			end
		elseif random <= 54 then
			for item_name, item in pairs(Store.items) do
				if item.type == "hero_set" and item.available == "buy" and item.coinsPrice == 15000 then
					table.insert( sets, item_name )
				end
			end
		elseif random <= 79 then
			for item_name, item in pairs(Store.items) do
				if item.type == "hero_set" and item.available == "buy" and item.coinsPrice == 20000 then
					table.insert( sets, item_name )
				end
			end
		elseif random <= 90 then
			for item_name, item in pairs(Store.items) do
				if item.type == "hero_set" and item.available == "buy" and item.coinsPrice == 25000 then
					table.insert( sets, item_name )
				end
			end
		elseif random <= 95 then
			for item_name, item in pairs(Store.items) do
				if item.type == "hero_set" and item.available == "buy" and item.coinsPrice == 30000 then
					table.insert( sets, item_name )
				end
			end
		else
			for item_name, item in pairs(Store.items) do
				if item.type == "hero_set" and item.available == "buy" and item.coinsPrice == 35000 then
					table.insert( sets, item_name )
				end
			end
		end
		local set = sets[RandomInt(1, #sets)]
		GiveStoreItem(id, set, tr)
		return Store.items[set].image
	end
end

function Chests:UpdatePlayer(id)
	if PlayerResource:IsValidPlayerID(id) then
		local player = PlayerResource:GetPlayer( id )

		if player then
			CustomGameEventManager:Send_ServerToPlayer( player, "chests_update_player", Chests.playersData[id])
		end
	end
end

function Chests:LoadPlayers()
	local tr = WebBD:CreateTransaction()
	local plc = PlayerResource:GetPlayerCount()
	for i=0, plc-1 do
		Chests.playersData[i] = {}
		tr:Get("SELECT * FROM `chests` WHERE `id`="..PlayerResource:GetSteamAccountID(i))
	end
	tr:Commit(function(chestsdata)
		-- DeepPrintTable(chestsdata)
		for i=1, plc do
			if chestsdata[tostring(i)] and chestsdata[tostring(i)][1] then
				Chests.playersData[i-1].chests = chestsdata[tostring(i)][1]
				for k, v in pairs(Chests.playersData[i-1].chests) do
					if k == "id" then
						Chests.playersData[i-1].chests[k] = nil
					else
						Chests.playersData[i-1].chests[k] = tonumber(v)
					end
				end
			else
				Chests.playersData[i-1].chests = {}
			end
			Chests:UpdatePlayer(i-1)
		end
		DeepPrintTable(Chests.playersData)
		Chests.PlayersLoaded = true
	end)
end

function Chests:AddChest(id, chest_name, count, tr)
	local commit = false
	if tr == nil then
		tr = WebBD:CreateTransaction()
		commit = true
	end
	local sign = "+"
	if count < 0 then
		sign = ""
	end
	tr:Set("INSERT INTO `chests` (`id`, `"..chest_name.."`) VALUES ("..PlayerResource:GetSteamAccountID(id)..", "..count..") ON DUPLICATE KEY UPDATE `"..chest_name.."`=`"..chest_name.."`"..sign..count,
		function()
			Chests.playersData[id].chests[chest_name] = (Chests.playersData[id].chests[chest_name] or 0) + count
			Chests:UpdatePlayer(id)
		end)
	if commit then
		tr:Commit()
	end
end