
Store = {}
Store.playersData = {}
Store.saveTimer = {}
Store.saleEliteCoins = {
	-- {
	-- 	count = 2,
	-- 	price = 99 
	-- },
	-- {
	-- 	count = 12,
	-- 	price = 499,
	-- 	bonus = 10,
	-- 	popular = true
	-- },
	-- {
	-- 	count = 25,
	-- 	price = 999,
	-- 	bonus = 15
	-- },
	-- {
	-- 	count = 70,
	-- 	price = 2499,
	-- 	bonus = 20,
	-- 	popular = true
	-- },
	-- {
	-- 	count = 150,
	-- 	price = 4999,
	-- 	bonus = 30
	-- },
	-- {
	-- 	count = 330,
	-- 	price = 9999,
	-- 	bonus = 50
	-- },
}
Store.saleCoins = {
	-- {
	-- 	count = 100,
	-- 	price = 99 
	-- },
	-- {
	-- 	count = 550,
	-- 	price = 499,
	-- 	bonus = 10
	-- },
	-- {
	-- 	count = 1150,
	-- 	price = 999,
	-- 	bonus = 15,
	-- 	popular = true
	-- },
	-- {
	-- 	count = 3000,
	-- 	price = 2499,
	-- 	bonus = 20
	-- },
	-- {
	-- 	count = 6500,
	-- 	price = 4999,
	-- 	bonus = 30
	-- },
	-- {
	-- 	count = 15000,
	-- 	price = 9999,
	-- 	bonus = 50
	-- }
}

function Store:Init()
	Store.items = LoadKeyValues("scripts/kv/store.kv").items
	CustomGameEventManager:RegisterListener( "get_store", function( _, data )
		if data.PlayerID ~= nil then
			local player = PlayerResource:GetPlayer( data.PlayerID )

			if player then
				CustomGameEventManager:Send_ServerToPlayer( player, "store_items", Store.items )
				CustomGameEventManager:Send_ServerToPlayer( player, "store_coins", { coins = Store.saleCoins, ecoins = Store.saleEliteCoins } )
			end

			if Store.Loaded == true then
				Store:UpdatePlayer( data.PlayerID )
				Store:UpdatePlayerOwns(data.PlayerID)
				Store:UpdatePlayerEquips(data.PlayerID)
			end
		end
	end )

	CustomGameEventManager:RegisterListener( "store_unequip_item", Dynamic_Wrap(Store, 'UnequipItem'))

	CustomGameEventManager:RegisterListener( "store_equip_item", Dynamic_Wrap(Store, 'EquipItem'))

	CustomGameEventManager:RegisterListener( "store_purchase_item", Dynamic_Wrap(Store, 'BuyItem'))

	CustomGameEventManager:RegisterListener( "store_payment", function( _, data )
		
		-- CustomGameEventManager:Send_ServerToPlayer( player, "store_payment_browser", {
		-- 	url = "https://"
		-- } )
	
		local player = PlayerResource:GetPlayer( data.PlayerID )

		if player then
			local prod = nil
			if data.eliteCoins == true then
				prod = Store.saleEliteCoins[data.paymentID]
			end
			if data.eliteCoins == false then
				prod = Store.saleCoins[data.paymentID]
			end
			if prod ~= nil then
				if data.method == "checkout" then
					-- [SCD-OFFLINE] pay.php - покупка монет за реальные деньги через сервер.
					-- Колбэк ответа пустой (весь закомментирован), фоллбек не нужен: запрос
					-- просто не делается. В оригинале ветка и так недостижима - таблицы
					-- Store.saleCoins/Store.saleEliteCoins пусты, поэтому prod == nil.
					if _G.SCD_OFFLINE then
						SCD_OfflineNote("pay.php skipped: coin purchase is not available offline")
						return
					end
					local req = CreateHTTPRequestScriptVM( "GET", "https://dotascd.ru/pay.php")
					req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKeyV3("2"))
					req:SetHTTPRequestGetOrPostParameter("price", tostring(PlayerResource:GetSteamAccountID(playerID)))
					req:SetHTTPRequestGetOrPostParameter("ecoins", tostring(-Store.items[itemName].eliteCoinsPrice))
					req:Send(function(result)
						-- print(result.Body)
						-- if result.Body ~= "ok" then
							
						-- end
					end)
					-- CustomGameEventManager:Send_ServerToPlayer( player, "store_payment_html", {
					-- 	url = "https://"
					-- } )
				end
			end
		end
	end )
end

Store.Loaded = false
Store.playersBoostLoaded = true
Store.playersStoreLoaded = false
function Store:PlayersBoostLoaded()
	Store.playersBoostLoaded = true
	if Store.playersStoreLoaded == true then
		Store:PlayersDataLoaded()
	end
end

function Store:TestStore(id)
	Store.playersData[id] = {}
	Store.playersData[id].itemsData = {}
	Store.playersData[id].itemsData.playerEquips = {}
	Store.playersData[id].itemsData.playerOwns = {}
	for item_name, item in pairs(Store.items) do
		if item.available == "hidden" then
			Store.playersData[id].itemsData.playerOwns[item_name] = true
		end
	end
	Store.playersData[id].coins = 99999
	Store.playersData[id].ecoins = 99999

	Store.playersStoreLoaded = true
	if Store.playersBoostLoaded == true then
		Store:PlayersDataLoaded()
	end
end

-- [SCD-FIX] локальный фоллбек: магазин недоступен -> играем без него, но не зависаем
function Store:PlayersStoreFallback(reason)
	if Store.playersStoreLoaded or Store.Loaded then
		return
	end
	print("[SCD-FIX] store fallback: " .. tostring(reason))
	for i = 1, PlayerResource:GetPlayerCount() do
		local id = i - 1
		if Store.playersData[id] == nil then
			Store.playersData[id] = {}
			Store.playersData[id].itemsData = {}
			Store.playersData[id].itemsData.playerEquips = {}
			Store.playersData[id].itemsData.playerOwns = {}
			Store.playersData[id].coins = 0
			Store.playersData[id].ecoins = 0
		end
	end
	Store.playersStoreLoaded = true
	if Store.playersBoostLoaded == true then
		Store:PlayersDataLoaded()
	end
end

function Store:PlayersStoreLoaded(datastr)
	-- [SCD-FIX] раньше nil/мусор из сети валили колбэк (gsub по nil, json.decode по мусору)
	if type(datastr) ~= "string" or datastr == "" then
		Store:PlayersStoreFallback("empty store.php body")
		return
	end
	local ok, data = pcall(json.decode, datastr:gsub( ":null", ":"..'"'..'"' ))
	if not ok or data == nil then
		print("[SCD-DIAG] store.php body is not valid JSON: " .. tostring(data):sub(1, 200))
		Store:PlayersStoreFallback("bad store.php json")
		return
	end
	if data and data["loaded"] then
		DeepPrintTable(data)
		for i=1,PlayerResource:GetPlayerCount() do
			local id = i - 1
			if Store.playersData[id] == nil then
				Store.playersData[id] = {}
				Store.playersData[id].itemsData = {}
				Store.playersData[id].itemsData.playerEquips = {}
				Store.playersData[id].itemsData.playerOwns = {}
			end

			local steamid = tostring(PlayerResource:GetSteamAccountID(id))
			-- print(steamid)
			if data[steamid] ~= nil then
				Store.playersData[id].coins = tonumber(data[steamid]["coins"]) or 0
				Store.playersData[id].ecoins = tonumber(data[steamid]["ecoins"]) or 0
				local okSaved, savedData = pcall(json.decode, data[steamid]["itemsData"] or "")
				if okSaved and savedData ~= nil then
					for _, item in pairs(savedData.playerOwns or {}) do
						Store.playersData[id].itemsData.playerOwns[item] = true
					end
					for _, item in pairs(savedData.playerEquips or {}) do
						Store.playersData[id].itemsData.playerEquips[item] = true
					end
				end
				-- DeepPrintTable(Store.playersData[id].itemsData)
			else
				Store.playersData[id].coins = 0
				Store.playersData[id].ecoins = 0
			end
		end
		Store.playersStoreLoaded = true
		if Store.playersBoostLoaded == true then
			Store:PlayersDataLoaded()
		end
	else
		Store:PlayersStoreFallback("store.php loaded=false")
	end
end

function Store:HaveRace(id, race)
	local races = CustomNetTables:GetTableValue("Patrons","races")
	if races == nil then
		return false
	end
	local race_table = races[tostring(id)]
	if race_table == nil then
		return false
	end
	if race_table[tostring(race)] then
		return true
	else
		return false
	end
end

-- [SCD-OFFLINE] выдать игроку ВСЕ предметы магазина (только владение; насильно экипируются
-- лишь предметы типа "race", как в оригинальном коде выдачи по донат-тирам).
-- Вызывается из Store:PlayersDataLoaded и из Store:OnPlayerLoaded (игрок, подключившийся
-- позже фазы CUSTOM_GAME_SETUP, когда локальный фоллбек магазина уже отработал).
function Store:UnlockAllCosmeticsForPlayer(id)
	if id == nil then
		return
	end
	if Store.playersData[id] == nil then
		Store.playersData[id] = { itemsData = { playerEquips = {}, playerOwns = {} }, coins = 0, ecoins = 0, discount = 0 }
	end
	for item, itemData in pairs(Store.items or {}) do
		Store.playersData[id].itemsData.playerOwns[item] = true
		if itemData.type == "race" then
			Store.playersData[id].itemsData.playerEquips[item] = true
		end
	end
end

function Store:PlayersDataLoaded()
	local portraits = CustomNetTables:GetTableValue("Patrons","portraits")
	if portraits == nil then
		portraits = {}
	end
	local races = CustomNetTables:GetTableValue("Patrons","races")
	if races == nil then
		races = {}
	end
	for i=1,PlayerResource:GetPlayerCount() do
		local id = i - 1
		local boost_lvl = _G.patreons[tostring(PlayerResource:GetSteamAccountID(id))] or 0
		-- [SCD-OFFLINE] защита: данные игрока могли не создаться к этому моменту
		-- (ниже идет обращение Store.playersData[id].itemsData..., оно не должно упасть)
		if Store.playersData[id] == nil then
			Store.playersData[id] = { itemsData = { playerEquips = {}, playerOwns = {} }, coins = 0, ecoins = 0 }
		end
		if _G.SCD_UNLOCK_ALL_COSMETICS then
			-- [SCD-OFFLINE] визуальные функции донатеров открыты всем игрокам: выдаем КАЖДЫЙ
			-- предмет из Store.items независимо от available и от _G.patreons (таблица пуста:
			-- патреон-уровень дает еще и геймплейные бусты, поэтому мы его никому не ставим).
			-- Насильно экипируем только type == "race" - как в оригинальном коде. Портреты
			-- (единственный активный тип в scripts/kv/store.kv, 61 штука) НЕ экипируем:
			-- игровой баланс не меняется, а рамку игрок выбирает сам в магазине - там все
			-- предметы ему принадлежат и экипируются бесплатно (Store:EquipItem проверяет
			-- playerOwns и сам пишет net-таблицу Patrons/portraits).
			Store:UnlockAllCosmeticsForPlayer(id)
		else
			-- оригинальная выдача по донат-тирам 1..3
			for item, itemData in pairs(Store.items) do
				if itemData.available ~= "buy" and itemData.available ~= "hidden" then
					if itemData.available <= boost_lvl then
						Store.playersData[id].itemsData.playerOwns[item] = true
						if itemData.type == "race" then
							Store.playersData[id].itemsData.playerEquips[item] = true
						end
					end
				end
			end
		end
		for item, _ in pairs(Store.playersData[id].itemsData.playerEquips) do
			if Store.playersData[id].itemsData.playerOwns[item] and Store.items[item] then
				if Store.items[item].type == "portrait" then
					portraits[tostring(id)] = Store.items[item].portraitPath
				end
				if Store.items[item].type == "race" then
					local race_table = races[tostring(id)]
					if race_table == nil then
						race_table = {}
						races[tostring(id)] = race_table
					end
					race_table[Store.items[item].race] = true
				end
			else
				Store.playersData[id].itemsData.playerEquips[item] = nil
			end
		end
		local discounts = {
			[0] = 0,
			[1] = 10,
			[2] = 15,
			[3] = 20,
			[4] = 25,
			[5] = 30,
			[6] = 30,
		}
		-- [SCD-OFFLINE] or 0: защита от nil, если уровень патреона лежит вне таблицы скидок
		-- (nil в discount сломал бы Store:UpdatePlayer и арифметику в Store:BuyItem)
		Store.playersData[id].discount = discounts[boost_lvl] or 0
		Store:UpdatePlayer( id )
		Store:UpdatePlayerOwns(id)
		Store:UpdatePlayerEquips(id)
	end
	CustomNetTables:SetTableValue("Patrons","portraits",portraits)
	CustomNetTables:SetTableValue("Patrons","races",races)
	CustomGameEventManager:Send_ServerToAllClients( "UpdateTopBar", {})
	Store.Loaded = true
end

function Store:UpdatePlayer( id )
	if PlayerResource:IsValidPlayerID(id) then
		local player = PlayerResource:GetPlayer( id )

		if player then
			CustomGameEventManager:Send_ServerToPlayer( player, "store_update_player", {
				level = 0,
				xp = 0,
				needXP = 0,
				booster = _G.patreons[tostring(PlayerResource:GetSteamAccountID(id))] or 0,
				boosterTimeLeft = 0,--fix
				coins = Store.playersData[id].coins,
				ecoins = Store.playersData[id].ecoins,
				discount = Store.playersData[id].discount
			} )
		end
	end
end

function Store:UpdatePlayerOwns(playerID)
	if PlayerResource:IsValidPlayerID(playerID) then
		local player = PlayerResource:GetPlayer( playerID )

		if player then
			CustomGameEventManager:Send_ServerToPlayer( player, "store_owns", Store.playersData[playerID].itemsData.playerOwns )
		end
	end
end

function Store:UpdatePlayerEquips(playerID)
	if PlayerResource:IsValidPlayerID(playerID) then
		local player = PlayerResource:GetPlayer( playerID )

		if player then
			CustomGameEventManager:Send_ServerToPlayer( player, "store_equips", Store.playersData[playerID].itemsData.playerEquips )
		end
	end
end

function Store:EquipItem(data)
	local playerID = data.PlayerID
	local itemName = data.itemName
	print("before if")
	print(Store.Loaded)
	print(playerID)
	print(itemName)
	print(Store.items[itemName])
	print(Store.playersData[playerID])
	if Store.Loaded == true and playerID ~= nil and itemName ~= nil and Store.items[itemName] ~= nil and Store.playersData[playerID] ~= nil then
		print("if passed")
		print(Store.playersData[playerID].itemsData.playerOwns[itemName])
		if Store.playersData[playerID].itemsData.playerOwns[itemName] then
			if Store.items[itemName].type == "pet" or Store.items[itemName].type == "portrait" then
				for item, _ in pairs(Store.playersData[playerID].itemsData.playerEquips) do
					if Store.items[item] ~= nil then
						if item ~= itemName and Store.items[item].type == Store.items[itemName].type then
							Store.playersData[playerID].itemsData.playerEquips[item] = nil
						end
					end
				end
			end
			if Store.items[itemName].type == "buildings" then
				for item, _ in pairs(Store.playersData[playerID].itemsData.playerEquips) do
					if Store.items[item] ~= nil then
						if item ~= itemName and Store.items[item].type == Store.items[itemName].type and Store.items[item].race == Store.items[itemName].race then
							Store.playersData[playerID].itemsData.playerEquips[item] = nil
						end
					end
				end
				if Store.items[itemName].race == _G.playersinfo[playerID].race then
					Store:SetBuildingsModels(playerID, Store.items[itemName])
				end
			end
			if Store.items[itemName].type == "building_attack_particle" then
				local racePart = nil
				for item, _ in pairs(Store.playersData[playerID].itemsData.playerEquips) do
					if Store.items[item] ~= nil and Store.items[item].type == Store.items[itemName].type then
						if item ~= itemName and Store.items[item].race == Store.items[itemName].race then
							Store.playersData[playerID].itemsData.playerEquips[item] = nil
						else
							if Store.items[item].race == _G.playersinfo[playerID].race then
								racePart = item
							end
						end
					end
				end
				if Store.items[itemName].race == _G.playersinfo[playerID].race then--fix == 0
					Store:SetBuildingsAttackParticle(playerID, Store.items[itemName])
				else
					if Store.items[itemName].race == 0 and racePart == nil then
						Store:SetBuildingsAttackParticle(playerID, Store.items[itemName])
					end
				end
			end
			if Store.items[itemName].type == "hero_set" then
				for item, _ in pairs(Store.playersData[playerID].itemsData.playerEquips) do
					if Store.items[item] ~= nil then
						if item ~= itemName and Store.items[item].type == Store.items[itemName].type and Store.items[item].hero == Store.items[itemName].hero then
							Store.playersData[playerID].itemsData.playerEquips[item] = nil
						end
					end
				end
				if _G.playersinfo[playerID].unitsinfo[Store.items[itemName].hero] then
					_G.playersinfo[playerID].unitsinfo[Store.items[itemName].hero].store_model = Store.items[itemName].model
					_G.playersinfo[playerID].unitsinfo[Store.items[itemName].hero].store_wearables = Store.items[itemName].wearables
					_G.playersinfo[playerID].unitsinfo[Store.items[itemName].hero].store_model_scale = Store.items[itemName].model_scale
				end
			end
			if Store.items[itemName].type == "unit_set" then
				-- for item, _ in pairs(Store.playersData[playerID].itemsData.playerEquips) do
				-- 	if Store.items[item] ~= nil then
				-- 		if item ~= itemName and Store.items[item].type == Store.items[itemName].type and Store.items[item].hero == Store.items[itemName].hero then
				-- 			Store.playersData[playerID].itemsData.playerEquips[item] = nil
				-- 		end
				-- 	end
				-- end
				for unit_name, unit_data in pairs(Store.items[itemName].units) do
					if _G.playersinfo[playerID].unitsinfo[unit_name] then
						_G.playersinfo[playerID].unitsinfo[unit_name].store_model = unit_data.model
						_G.playersinfo[playerID].unitsinfo[unit_name].store_wearables = unit_data.wearables
						_G.playersinfo[playerID].unitsinfo[unit_name].store_model_scale = unit_data.model_scale
					end
				end
			end
			Store.playersData[playerID].itemsData.playerEquips[itemName] = true
			Store:UpdatePlayerEquips(playerID)
			Store:Save(playerID)
			
			if Store.items[itemName].type == "pet" then
				data.item = Store.items[itemName]
				Pets:CreatePet( data )
			end
			if Store.items[itemName].type == "race" then
				local races = CustomNetTables:GetTableValue("Patrons","races")
				local race_table = races[tostring(playerID)]
				if race_table == nil then
					race_table = {}
					races[tostring(playerID)] = race_table
				end
				race_table[Store.items[itemName].race] = true
			end
			if Store.items[itemName].type == "portrait" then
				local portraits = CustomNetTables:GetTableValue("Patrons","portraits")
				if portraits == nil then
					portraits = {}
				end
				portraits[tostring(playerID)] = Store.items[itemName].portraitPath
				if Store.portraitsTimer then
					Store.portraitsTimerData = portraits
					Store.updateAfterPortraitsTimer = true
				else
					CustomNetTables:SetTableValue("Patrons","portraits",portraits)
					Store.updateAfterPortraitsTimer = nil
					Store.portraitsTimer = true
					Timers:CreateTimer(1, function()
						Store.portraitsTimer = false
						if Store.updateAfterPortraitsTimer then
							CustomNetTables:SetTableValue("Patrons","portraits",Store.portraitsTimerData)
							Store.portraitsTimerData = nil
							Store.updateAfterPortraitsTimer = nil
						end
					end)
				end
			end
		end
	end
end

function Store:OnPlayerLoaded(data)
	-- [SCD-FIX] раньше при недоступном магазине таймер крутился вечно; теперь максимум 90 попыток
	data = data or {}
	Store._playerLoadedTries = Store._playerLoadedTries or {}
	Store._playerLoadedTries[data.PlayerID] = (Store._playerLoadedTries[data.PlayerID] or 0) + 1
	-- [SCD-OFFLINE] игрок мог подключиться позже фазы CUSTOM_GAME_SETUP, когда локальный
	-- фоллбек магазина уже отработал: создаем ему данные и выдаем косметику сразу, иначе
	-- ретраи ниже ничего бы не дождались (Store.playersData[id] так и остался бы nil,
	-- и через 90 попыток магазин у этого игрока просто не открылся бы).
	if _G.SCD_OFFLINE and _G.SCD_UNLOCK_ALL_COSMETICS and Store.playersData[data.PlayerID] == nil then
		Store:UnlockAllCosmeticsForPlayer(data.PlayerID)
		Store:UpdatePlayer(data.PlayerID)
		Store:UpdatePlayerOwns(data.PlayerID)
		Store:UpdatePlayerEquips(data.PlayerID)
	end
	if Store.Loaded == true and Store.playersData[data.PlayerID] then
		Store._playerLoadedTries[data.PlayerID] = nil
		for item, _ in pairs(Store.playersData[data.PlayerID].itemsData.playerEquips) do
			if Store.items[item] and Store.items[item].type == "pet" then
				data.item = Store.items[item]
				Pets:CreatePet( data )
			end
		end
	elseif Store._playerLoadedTries[data.PlayerID] < 90 then
		Timers:CreateTimer(1, function()
			Store:OnPlayerLoaded(data)
		end)
	else
		print("[SCD-FIX] Store:OnPlayerLoaded give up for pid " .. tostring(data.PlayerID))
	end
end

function Store:OnRaceSelected(id)
	if Store.Loaded == true and Store.playersData[id] then
		for item, _ in pairs(Store.playersData[id].itemsData.playerEquips) do
			if Store.items[item].type == "buildings" and Store.items[item].race == _G.playersinfo[id].race then
				Store:SetBuildingsModels(id, Store.items[item])
				break
			end
		end
		local racePart = nil
		local allPart = nil
		for item, _ in pairs(Store.playersData[id].itemsData.playerEquips) do
			if Store.items[item].type == "building_attack_particle" then
				if Store.items[item].race == _G.playersinfo[id].race then
					racePart = item
					break
				else
					if Store.items[item].race == 0 then
						allPart = item
					end
				end
			end
		end
		if racePart then
			Store:SetBuildingsAttackParticle(id, Store.items[racePart])
		else
			if allPart then
				Store:SetBuildingsAttackParticle(id, Store.items[allPart])
			end
		end
		for item, _ in pairs(Store.playersData[id].itemsData.playerEquips) do
			if Store.items[item].type == "hero_set" and _G.playersinfo[id].unitsinfo[Store.items[item].hero] then
				_G.playersinfo[id].unitsinfo[Store.items[item].hero].store_model = Store.items[item].model
				_G.playersinfo[id].unitsinfo[Store.items[item].hero].store_wearables = Store.items[item].wearables
			end
			if Store.items[item].type == "unit_set" then
				for unit_name, unit_data in pairs(Store.items[item].units) do
					if _G.playersinfo[id].unitsinfo[unit_name] then
						_G.playersinfo[id].unitsinfo[unit_name].store_model = unit_data.model
						_G.playersinfo[id].unitsinfo[unit_name].store_wearables = unit_data.wearables
					end
				end
			end
		end
	else
		Timers:CreateTimer(1, function()
			Store:OnRaceSelected(id)
		end)
	end
end

function Store:SetBuildingsModels(id, item)
	if item then
		if _G.playersinfo[id].ancient ~= nil then
			_G.playersinfo[id].ancient:SetModel(item.castle_model)
			_G.playersinfo[id].ancient:SetOriginalModel(item.castle_model)
			_G.playersinfo[id].ancient:SetModelScale( item.castle_model_scale )
		end
		for k, v in pairs(_G.playersinfo[id].baracks) do
			v:SetModel(item.racks_model)
			v:SetOriginalModel(item.racks_model)
			v:SetModelScale( item.racks_model_scale )
		end
		for k, v in pairs(_G.playersinfo[id].towers) do
			v:SetModel(item.tower_model)
			v:SetOriginalModel(item.tower_model)
			v:SetModelScale( item.tower_model_scale )
		end
		if _G.playersinfo[id].spec ~= nil then
			_G.playersinfo[id].spec:SetModel(item.spec_model)
			_G.playersinfo[id].spec:SetOriginalModel(item.spec_model)
			_G.playersinfo[id].spec:SetModelScale( item.spec_model_scale )
		end
	else
		if _G.playersinfo[id].ancient ~= nil then
			_G.playersinfo[id].ancient:SetModel(_G.playersinfo[id].raceinfo.default_building_models.castle_model)
			_G.playersinfo[id].ancient:SetOriginalModel(_G.playersinfo[id].raceinfo.default_building_models.castle_model)
			_G.playersinfo[id].ancient:SetModelScale( _G.playersinfo[id].raceinfo.default_building_models.castle_model_scale )
		end
		for k, barack in pairs(_G.playersinfo[id].baracks) do
			barack:SetModel(_G.playersinfo[id].raceinfo.default_building_models.racks_model)
			barack:SetOriginalModel(_G.playersinfo[id].raceinfo.default_building_models.racks_model)
			barack:SetModelScale( _G.playersinfo[id].raceinfo.default_building_models.racks_model_scale )
		end
		for k, tower in pairs(_G.playersinfo[id].towers) do
			tower:SetModel(_G.playersinfo[id].raceinfo.default_building_models.tower_model)
			tower:SetOriginalModel(_G.playersinfo[id].raceinfo.default_building_models.tower_model)
			tower:SetModelScale( _G.playersinfo[id].raceinfo.default_building_models.tower_model_scale )
		end
		if _G.playersinfo[id].spec ~= nil then
			_G.playersinfo[id].spec:SetModel(_G.playersinfo[id].raceinfo.default_building_models.spec_model)
			_G.playersinfo[id].spec:SetOriginalModel(_G.playersinfo[id].raceinfo.default_building_models.spec_model)
			_G.playersinfo[id].spec:SetModelScale( _G.playersinfo[id].raceinfo.default_building_models.spec_model_scale )
		end
	end
end

function Store:SetBuildingsAttackParticle(id, item)
	if item then
		if _G.playersinfo[id].ancient ~= nil then
			_G.playersinfo[id].ancient:SetRangedProjectileName(item.attack_particle)
		end
		for k, v in pairs(_G.playersinfo[id].baracks) do
			v:SetRangedProjectileName(item.attack_particle)
		end
		for k, v in pairs(_G.playersinfo[id].towers) do
			v:SetRangedProjectileName(item.attack_particle)
		end
		if _G.playersinfo[id].spec ~= nil then
			_G.playersinfo[id].spec:SetRangedProjectileName(item.attack_particle)
		end
	else
		if _G.playersinfo[id].ancient ~= nil then
			_G.playersinfo[id].ancient:SetRangedProjectileName("particles/neutral_fx/gnoll_base_attack.vpcf")
		end
		for k, barack in pairs(_G.playersinfo[id].baracks) do
			barack:SetRangedProjectileName("particles/neutral_fx/gnoll_base_attack.vpcf")
		end
		for k, tower in pairs(_G.playersinfo[id].towers) do
			tower:SetRangedProjectileName("particles/neutral_fx/gnoll_base_attack.vpcf")
		end
		if _G.playersinfo[id].spec ~= nil then
			_G.playersinfo[id].spec:SetRangedProjectileName("particles/neutral_fx/gnoll_base_attack.vpcf")
		end
	end
end

function Store:UnequipItem(data)
	local playerID = data.PlayerID
	local itemName = data.itemName
	if Store.Loaded == true and playerID ~= nil and itemName ~= nil and Store.items[itemName] ~= nil and Store.playersData[playerID] ~= nil then
		if Store.items[itemName].type ~= "race" then
			Store.playersData[playerID].itemsData.playerEquips[itemName] = nil
			Store:UpdatePlayerEquips(playerID)
			Store:Save(playerID)
		end
		
		if Store.items[itemName].type == "buildings" and Store.items[itemName].race == _G.playersinfo[playerID].race then
			Store:SetBuildingsModels(playerID, nil)
		end
		if Store.items[itemName].type == "building_attack_particle" and (Store.items[itemName].race == 0 or Store.items[itemName].race == _G.playersinfo[playerID].race) then
			Store:SetBuildingsAttackParticle(playerID, nil)
		end
		if Store.items[itemName].type == "pet" then
			Pets:HidePet( playerID )
		end
		if Store.items[itemName].type == "portrait" then
			local portraits = CustomNetTables:GetTableValue("Patrons","portraits")
			if portraits == nil then
				portraits = {}
			end
			portraits[tostring(playerID)] = nil
			if Store.portraitsTimer then
				Store.portraitsTimerData = portraits
				Store.updateAfterPortraitsTimer = true
			else
				CustomNetTables:SetTableValue("Patrons","portraits",portraits)
				Store.updateAfterPortraitsTimer = nil
				Store.portraitsTimer = true
				Timers:CreateTimer(1, function()
					Store.portraitsTimer = false
					if Store.updateAfterPortraitsTimer then
						CustomNetTables:SetTableValue("Patrons","portraits",Store.portraitsTimerData)
						Store.portraitsTimerData = nil
						Store.updateAfterPortraitsTimer = nil
					end
				end)
			end
		end
		if Store.items[itemName].type == "hero_set" then
			if _G.playersinfo[playerID].unitsinfo[Store.items[itemName].hero] then
				_G.playersinfo[playerID].unitsinfo[Store.items[itemName].hero].store_model = nil
				_G.playersinfo[playerID].unitsinfo[Store.items[itemName].hero].store_wearable = nil
			end
		end
		if Store.items[itemName].type == "unit_set" then
			for unit_name, unit_data in pairs(Store.items[itemName].units) do
				if _G.playersinfo[playerID].unitsinfo[unit_name] then
					_G.playersinfo[playerID].unitsinfo[unit_name].store_model = nil
					_G.playersinfo[playerID].unitsinfo[unit_name].store_wearables = nil
				end
			end
		end
	end
end

function Store:BuyItem(data)
	local playerID = data.PlayerID
	local itemName = data.itemName
	local useEliteCoins = data.useEliteCoins
	if Store.Loaded == true and playerID ~= nil and itemName ~= nil and useEliteCoins ~= nil and Store.items[itemName] ~= nil and Store.playersData[playerID] ~= nil and Store.items[itemName].available == "buy" then
		if useEliteCoins == 1 then
			local price = math.floor(Store.items[itemName].eliteCoinsPrice * ((100 - Store.playersData[playerID].discount) / 100))
			if price > 0 and Store.playersData[playerID].ecoins >= price then
				Store.playersData[playerID].ecoins = Store.playersData[playerID].ecoins - price
				Store.playersData[playerID].itemsData.playerOwns[itemName] = true
				
				Store:UpdatePlayer( playerID )
				Store:UpdatePlayerOwns(playerID)
				Store:Save(playerID)
			end
		else
			local price = math.floor(Store.items[itemName].coinsPrice * ((100 - Store.playersData[playerID].discount) / 100))
			if price > 0 and Store.playersData[playerID].coins >= price then
				Store.playersData[playerID].coins = Store.playersData[playerID].coins - price
				Store.playersData[playerID].itemsData.playerOwns[itemName] = true
				
				Store:UpdatePlayer( playerID )
				Store:UpdatePlayerOwns(playerID)
				Store:Save(playerID)
			end
		end
	end
end

-- function Store:Save(playerID, tr)
-- 	if not Store.Loaded or not Store.playersStoreLoaded then
-- 		return
-- 	end

-- 	local saveData = {}
-- 	saveData.playerOwns = {}
-- 	saveData.playerEquips = {}

-- 	for item, _ in pairs(Store.playersData[playerID].itemsData.playerOwns) do
-- 		if Store.items[item] == nil or Store.items[item].available == "buy" or Store.items[item].available == "hidden" then
-- 			table.insert( saveData.playerOwns, item )
-- 		end
-- 	end

-- 	for item, _ in pairs(Store.playersData[playerID].itemsData.playerEquips) do
-- 		table.insert( saveData.playerEquips, item )
-- 	end

-- 	local saveStr = json.encode(saveData)
-- 	-- print(saveStr)
-- 	if tr == nil then
-- 		if Store.saveTimer[playerID] == nil then
-- 			Store.saveTimer[playerID] = {}
-- 			Store.saveTimer[playerID].timer = 60
-- 			Store.saveTimer[playerID].data = saveStr
-- 			Timers:CreateTimer(1, function()
-- 				if Store.saveTimer[playerID] then
-- 					Store.saveTimer[playerID].timer = Store.saveTimer[playerID].timer - 1
-- 					if Store.saveTimer[playerID].timer <= 0 then
-- 						tr = WebBD:CreateTransaction()
-- 						tr:Set("INSERT INTO `store` (`id`, `coins`, `ecoins`, `itemsData`) VALUES ("..PlayerResource:GetSteamAccountID(playerID)..", "..Store.playersData[playerID].coins..", "..Store.playersData[playerID].ecoins..", '"..Store.saveTimer[playerID].data.."') ON DUPLICATE KEY UPDATE coins="..Store.playersData[playerID].coins..", ecoins="..Store.playersData[playerID].ecoins..", itemsData='"..Store.saveTimer[playerID].data.."'")
-- 						tr:Commit()
-- 						Store.saveTimer[playerID] = nil
-- 					else
-- 						return 1
-- 					end
-- 				end
-- 			end)
-- 		else
-- 			Store.saveTimer[playerID].timer = 60
-- 			Store.saveTimer[playerID].data = saveStr
-- 		end
-- 	else
-- 		Store.saveTimer[playerID] = nil
-- 		tr:Set("INSERT INTO `store` (`id`, `coins`, `ecoins`, `itemsData`) VALUES ("..PlayerResource:GetSteamAccountID(playerID)..", "..Store.playersData[playerID].coins..", "..Store.playersData[playerID].ecoins..", '"..saveStr.."') ON DUPLICATE KEY UPDATE coins="..Store.playersData[playerID].coins..", ecoins="..Store.playersData[playerID].ecoins..", itemsData='"..saveStr.."'")
-- 	end
-- end

function Store:Save(playerID, tr)
	-- [SCD-OFFLINE] сохранение покупок/экипировки уходило на store.php. В автономной игре
	-- сохранять некуда, поэтому выходим сразу: заодно уходит спам "store save"/"store save 1"
	-- (печатались на КАЖДЫЙ equip/unequip/buy) и бесполезный 60-секундный таймер на игрока.
	-- Цена вопроса: выбранные рамки живут только до конца матча - сервера для них больше нет.
	if _G.SCD_OFFLINE then
		SCD_OfflineNote("store.php save skipped: items/equips live until the end of the match")
		return
	end
	print("store save")
	if not Store.Loaded or not Store.playersStoreLoaded then
		return
	end
	print("store save 1")

	local saveData = {}
	saveData.playerOwns = {}
	saveData.playerEquips = {}
	for item, _ in pairs(Store.playersData[playerID].itemsData.playerOwns) do
		if Store.items[item] == nil or Store.items[item].available == "buy" or Store.items[item].available == "hidden" then
			table.insert( saveData.playerOwns, item )
		end
	end
	for item, _ in pairs(Store.playersData[playerID].itemsData.playerEquips) do
		table.insert( saveData.playerEquips, item )
	end
	local saveStr = json.encode(saveData)

	if Store.saveTimer[playerID] == nil then
		Store.saveTimer[playerID] = { timer = 60, data = saveStr }
		Timers:CreateTimer(1, function()
			if Store.saveTimer[playerID] then
				Store.saveTimer[playerID].timer = Store.saveTimer[playerID].timer - 1
				if Store.saveTimer[playerID].timer <= 0 then
					Store.saveTimer[playerID] = nil
					-- [SCD-OFFLINE] точка запроса закрыта флагом (дублирует ранний выход в
					-- начале Store:Save): store.php в автономной игре не вызывается ниотсюда.
					if not _G.SCD_OFFLINE then
						local req = CreateHTTPRequestScriptVM( "GET", "https://dotascd.ru/store.php")
						req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKeyV3("2"))
						req:SetHTTPRequestGetOrPostParameter("id", tostring(PlayerResource:GetSteamAccountID(playerID)))
						req:SetHTTPRequestGetOrPostParameter("coins", tostring(Store.playersData[playerID].coins))
						req:SetHTTPRequestGetOrPostParameter("ecoins", tostring(Store.playersData[playerID].ecoins))
						req:SetHTTPRequestGetOrPostParameter("data", saveStr)
						req:Send(function(result) end)
						print("store save 2")
					end
				else
					return 1
				end
			end
		end)
	else
		Store.saveTimer[playerID].timer = 60
		Store.saveTimer[playerID].data = saveStr
	end
end

function Store:AddCoins(playerID, coins)
	-- [SCD-OFFLINE] начисление монет было чисто серверным (store.php), колбэк ответа пустой.
	-- Фоллбек не нужен: в автономной игре монет нет (Store.playersData[...].coins = 0),
	-- а все предметы и так выданы всем в Store:PlayersDataLoaded. Запрос не делается.
	if _G.SCD_OFFLINE then
		SCD_OfflineNote("store.php AddCoins skipped: server coins are not available offline")
		return
	end
	local req = CreateHTTPRequestScriptVM( "GET", "https://dotascd.ru/store.php")
	req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKeyV3("3"))
	req:SetHTTPRequestGetOrPostParameter("id", tostring(PlayerResource:GetSteamAccountID(playerID)))
	req:SetHTTPRequestGetOrPostParameter("coins", tostring(coins))
	req:Send(function(result)
		-- print(result.Body)
		-- if result.Body ~= "ok" then
			
		-- end
	end)
end

function Store:OnPlayerDefeat(id, place, winner)
	local plc = PlayerResource:GetPlayerCount()
	if not GameRules:IsCheatMode() and ((GameRules:GetDOTATime(false,false) > 600 and _G.turbo) or GameRules:GetDOTATime(false,false) > 1200) and plc == 4 then
		local boostbonus = {
			{
				self_bonus = 0.5,
				all_bonus = 0.1
			},
			{
				self_bonus = 0.75,
				all_bonus = 0.15
			},
			{
				self_bonus = 1,
				all_bonus = 0.2
			},
			{
				self_bonus = 2,
				all_bonus = 0.25
			},
			{
				self_bonus = 3,
				all_bonus = 0.3
			}
		}
		local boostsbonus = 1
		for boost_id, _ in pairs(_G.playersinfo) do
			local boost_lvl = _G.patreons[tostring(PlayerResource:GetSteamAccountID(boost_id))]
			if boost_lvl and boostbonus[boost_lvl] then
				boostsbonus = boostsbonus + boostbonus[boost_lvl].all_bonus
			end
		end
		local defeatedPlBonus = boostsbonus
		local defeatedboost_lvl = _G.patreons[tostring(PlayerResource:GetSteamAccountID(id))]
		if defeatedboost_lvl then
			defeatedPlBonus = defeatedPlBonus + boostbonus[defeatedboost_lvl].self_bonus
		end
		local winnerPlBonus = boostsbonus
		if winner then
			local winnerboost_lvl = _G.patreons[tostring(PlayerResource:GetSteamAccountID(winner))]
			if winnerboost_lvl then
				winnerPlBonus = winnerPlBonus + boostbonus[winnerboost_lvl].self_bonus
			end
		end

		local place_coins = nil
		local bonus = 0
		if not _G.duos then
			if not _G.turbo then
				if GameRules:GetDOTATime(false,false) > 2400 then
					if GameRules:GetDOTATime(false,false) > 3600 then--if 60 < time (min)
						place_coins = {
							400,
							320,
							260,
							210
						}
						bonus = math.min( GameRules:GetDOTATime(false,false) - 3600, 1800 ) / 60
						if place > 2 then
							bonus = math.floor(bonus/2)
						end
					else--if 40 < time < 60 (min)
						place_coins = {
							325,
							260,
							205,
							150
						}
					end
				else--if 20 < time < 40 (min)
					place_coins = {
						250,
						200,
						150,
						100
					}
				end

				local coins = place_coins[place] + bonus + RandomInt(-15, 15)
				Store:AddCoins(id, coins * defeatedPlBonus)

				if winner then
					local winner_coins = place_coins[1] + bonus + RandomInt(-15, 15)
					Store:AddCoins(winner, winner_coins * winnerPlBonus)
				end
			else
				if GameRules:GetDOTATime(false,false) > 1200 then
					if GameRules:GetDOTATime(false,false) > 1800 then--if 30 < time (min)
						place_coins = {
							200,
							160,
							130,
							105
						}
						bonus = math.min( GameRules:GetDOTATime(false,false) - 1800, 900 ) / 60
						if place > 2 then
							bonus = math.floor(bonus/2)
						end
					else--if 20 < time < 30 (min)
						place_coins = {
							165,
							130,
							105,
							75
						}
					end
				else--if 10 < time < 20 (min)
					place_coins = {
						125,
						200,
						75,
						50
					}
				end

				local coins = place_coins[place] + bonus + RandomInt(-15, 15)
				Store:AddCoins(id, coins * defeatedPlBonus)

				if winner then
					local winner_coins = place_coins[1] + bonus + RandomInt(-15, 15)
					Store:AddCoins(winner, winner_coins * winnerPlBonus)
				end
			end
		else
			if GameRules:GetDOTATime(false,false) > 2400 then
				if GameRules:GetDOTATime(false,false) > 3600 then--if 60 < time (min)
					place_coins = {
						350,
						250
					}
					bonus = math.min( GameRules:GetDOTATime(false,false) - 3600, 1800 ) / 60
				else--if 40 < time < 60 (min)
					place_coins = {
						275,
						175
					}
				end
			else--if 20 < time < 40 (min)
				place_coins = {
					200,
					100
				}
			end

			if winner then
				for loc_id, _ in pairs(_G.playersinfo) do
					local locPlBonus = boostsbonus
					local locboost_lvl = _G.patreons[tostring(PlayerResource:GetSteamAccountID(loc_id))]
					if locboost_lvl then
						locPlBonus = locPlBonus + boostbonus[locboost_lvl].self_bonus
					end
					if PlayerResource:GetTeam(winner) == PlayerResource:GetTeam(loc_id) then
						local coins = place_coins[1] + bonus + RandomInt(-15, 15)
						Store:AddCoins(loc_id, coins * locPlBonus)
					else
						local coins = place_coins[2] + math.floor(bonus/2) + RandomInt(-15, 15)
						Store:AddCoins(loc_id, coins * locPlBonus)
					end
				end
			end
		end
	end
end