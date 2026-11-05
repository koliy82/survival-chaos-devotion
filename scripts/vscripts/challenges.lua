Challenges = Challenges or {}
Challenges.player_data = {}
--[[ Event Names
	player_win {}
	spawn_hero {hero_name}
	spawn_creep {unit_name, caster, item}
	hero_get_level {hero_name, level}
	buy_mana {}
	capture_neutral {neutral}
	barrack_destroyed {barrack}
]]
Challenges.challenges_list = {
	{--win_on_race
		OnGenerate = function(self)
			--
			self.data.name = "win_on_race"
			self.data.icontype = "ability"
			self.data.reward = 250
			self.data.progress = 0
			self.data.goal = 1
			self.data.normal = true
			self.data.turbo = false
			self.data.duos = false
			--self.locked = false
			--
			self.data.race = RandomInt(1, _G.free_race_count)
			self.data.abilityicon = _G.racetable.races_names[tostring(self.data.race)] .. "_race_bonus"
		end,
		OnLoaded = function(self)

		end,
		ChallengeTriggerEvent = function(self, event_name, table)
			if event_name == "player_win" then
				if _G.playersinfo[self.owner_id].race == self.data.race then
					self:Complete()
					Challenges:UpdateChallengesForPlayer(self.owner_id)
				end
			end
		end
	},
	{--win_before
		OnGenerate = function(self)
			--
			self.data.name = "win_before"
			self.data.icontype = "image"
			self.data.image = "file://{images}/challenges/win_before.png"
			self.data.progress = 0
			self.data.goal = 1
			self.data.normal = true
			self.data.turbo = false
			self.data.duos = false
			--self.locked = false
			--
			self.data.number = 20 + RandomInt(1, 4) * 5
			self.data.reward = 550 - self.data.number * 8
		end,
		OnLoaded = function(self)

		end,
		ChallengeTriggerEvent = function(self, event_name, table)
			if event_name == "player_win" then
				if GameRules:GetDOTATime(false, false) < self.data.number * 60 then
					self:Complete()
					Challenges:UpdateChallengesForPlayer(self.owner_id)
				end
			end
		end
	},
	{--win_after
		OnGenerate = function(self)
			--
			self.data.name = "win_after"
			self.data.icontype = "image"
			self.data.image = "file://{images}/challenges/win_after.png"
			self.data.progress = 0
			self.data.goal = 1
			self.data.normal = true
			self.data.turbo = false
			self.data.duos = false
			--self.locked = false
			--
			self.data.number = 20 + RandomInt(1, 4) * 10
			self.data.reward = 100 + self.data.number * 4
		end,
		OnLoaded = function(self)

		end,
		ChallengeTriggerEvent = function(self, event_name, table)
			if event_name == "player_win" then
				if GameRules:GetDOTATime(false, false) > self.data.number * 60 then
					self:Complete()
					Challenges:UpdateChallengesForPlayer(self.owner_id)
				end
			end
		end
	},
	{--win_on_spec
		OnGenerate = function(self)
			--
			self.data.name = "win_on_spec"
			self.data.icontype = "ability"
			self.data.reward = 250
			self.data.progress = 0
			self.data.goal = 1
			self.data.normal = true
			self.data.turbo = false
			self.data.duos = false
			--self.locked = false
			--
			self.data.race = RandomInt(1, _G.free_race_count)
			local race = _G.racetable.races_names[tostring(self.data.race)]
			local all_specs = _G.racetable[race].race_data.specs
			local all_specs_count = 0
			for _, _ in pairs(all_specs) do
				all_specs_count = all_specs_count + 1
			end
			self.data.spec = all_specs[tostring(RandomInt(1, all_specs_count))]

			self.data.abilityicon = self.data.spec
		end,
		OnLoaded = function(self)
			
		end,
		ChallengeTriggerEvent = function(self, event_name, table)
			if event_name == "player_win" then
				if _G.playersinfo[self.owner_id].spec.specpass_name == self.data.spec.."_pass" or _G.playersinfo[self.owner_id].spec.specpass:GetAbilityName() == self.data.spec.."_pass" then
					self:Complete()
					Challenges:UpdateChallengesForPlayer(self.owner_id)
				end
			end
		end
	},
	{--spawn_hero
		OnGenerate = function(self)
			--
			self.data.name = "spawn_hero"
			self.data.icontype = "ability"
			self.data.progress = 0
			self.data.normal = true
			self.data.turbo = false
			self.data.duos = false
			--self.locked = false
			--
			local race = _G.racetable.races_names[tostring(RandomInt(1, _G.free_race_count))]
			local all_heroes = {
				"_tank",
				"_mage",
				"_asassin",
				"_pusher"
			}
			local hero_type_id = RandomInt(1, #all_heroes)
			local hero = all_heroes[hero_type_id]
			self.data.hero = "npc_dota_"..race.."_hero"..hero
			self.data.abilityicon = "spawn_hero_"..race..hero
			
			local count = RandomInt(1, 3)
			--
			self.data.reward = 200 + count * 25
			--
			if hero_type_id ~= 4 then
				count = count * 2
			end
			--
			self.data.goal = count
			--
		end,
		OnLoaded = function(self)
			if not self.data.completed then
				self.data.progress = 0
			end
		end,
		ChallengeTriggerEvent = function(self, event_name, table)
			if event_name == "spawn_hero" then
				if table.hero_name == self.data.hero then
					self.data.progress = self.data.progress + 1
					if self.data.progress >= self.data.goal then
						self:Complete()
					end
					Challenges:UpdateChallengesForPlayer(self.owner_id)
				end
			end
		end
	},
	{--hero_get_level
		OnGenerate = function(self)
			--
			self.data.name = "hero_get_level"
			self.data.icontype = "ability"
			self.data.progress = 0
			local count_mult = RandomInt(1, 3)
			self.data.reward = 225 + count_mult * 25
			self.data.goal = 5 + count_mult * 5
			self.data.normal = true
			self.data.turbo = false
			self.data.duos = false
			--self.locked = false
			--
			local race = _G.racetable.races_names[tostring(RandomInt(1, _G.free_race_count))]
			local all_heroes = {
				"_tank",
				"_mage",
				"_asassin",
				"_pusher"
			}
			local hero = all_heroes[RandomInt(1, #all_heroes)]
			self.data.hero = "npc_dota_"..race.."_hero"..hero
			
			self.data.abilityicon = "spawn_hero_"..race..hero
		end,
		OnLoaded = function(self)
			if not self.data.completed then
				self.data.progress = 0
			end
		end,
		ChallengeTriggerEvent = function(self, event_name, table)
			if event_name == "hero_get_level" then
				if table.hero_name == self.data.hero then
					if table.level >= self.data.goal then
						self:Complete()
					else
						self.data.progress = table.level
					end
					Challenges:UpdateChallengesForPlayer(self.owner_id)
				end
			end
		end
	},
	{--wins
		OnGenerate = function(self)
			--
			self.data.name = "wins"
			self.data.icontype = "image"
			self.data.image = "file://{images}/challenges/wins.png"
			self.data.progress = 0
			self.data.goal = RandomInt(1, 5)
			self.data.reward = 200 + self.data.goal * 25
			self.data.normal = true
			self.data.turbo = true
			self.data.duos = true
			--self.locked = false
			--
		end,
		OnLoaded = function(self)
			
		end,
		ChallengeTriggerEvent = function(self, event_name, table)
			if event_name == "player_win" then
				self.data.progress = self.data.progress + 1
				if self.data.progress >= self.data.goal then
					self:Complete()
				end
				Challenges:UpdateChallengesForPlayer(self.owner_id)
			end
		end
	},
	{--buy_mana
		OnGenerate = function(self)
			--
			self.data.name = "buy_mana"
			self.data.icontype = "ability"
			self.data.abilityicon = "ancient_buy_mana"
			self.data.goal = 1--RandomInt(1, 3)
			self.data.reward = 225 + self.data.goal * 25
			self.data.progress = 0
			self.data.normal = true
			self.data.turbo = false
			self.data.duos = false
			--self.locked = false
			--
		end,
		OnLoaded = function(self)
			
		end,
		ChallengeTriggerEvent = function(self, event_name, table)
			if event_name == "buy_mana" then
				self.data.progress = self.data.progress + 1
				if self.data.progress >= self.data.goal then
					self:Complete()
				end
				Challenges:UpdateChallengesForPlayer(self.owner_id)
			end
		end
	},
	{--capture_neutral
		OnGenerate = function(self)
			--
			self.data.name = "capture_neutral"
			self.data.icontype = "image"
			self.data.image = "file://{images}/challenges/capture_neutral.png"
			self.data.progress = 0
			self.data.goal = 15 + RandomInt(1, 5) * 5
			self.data.reward = 150 + self.data.goal * 5
			self.data.normal = true
			self.data.turbo = false
			self.data.duos = false
			--self.locked = false
			--
		end,
		OnLoaded = function(self)
			if not self.data.completed then
				self.data.progress = 0
			end
		end,
		ChallengeTriggerEvent = function(self, event_name, table)
			if event_name == "capture_neutral" then
				self.data.progress = self.data.progress + 1
				if self.data.progress >= self.data.goal then
					self:Complete()
				end
				Challenges:UpdateChallengesForPlayer(self.owner_id)
			end
		end
	},
	{--capture_neutral_level3
		OnGenerate = function(self)
			--
			self.data.name = "capture_neutral_level3"
			self.data.icontype = "image"
			self.data.image = "file://{images}/challenges/capture_neutral_level3.png"
			self.data.reward = 275
			self.data.progress = 0
			self.data.goal = 1
			self.data.normal = true
			self.data.turbo = false
			self.data.duos = false
			--self.locked = false
			--
		end,
		OnLoaded = function(self)
			if not self.data.completed then
				self.data.progress = 0
			end
		end,
		ChallengeTriggerEvent = function(self, event_name, table)
			if event_name == "capture_neutral" then
				if table.neutral.neutral_ability:GetLevel() == 3 then
					self:Complete()
					Challenges:UpdateChallengesForPlayer(self.owner_id)
				end
			end
		end
	},
	{--gold_for_spawn_creep
		OnGenerate = function(self)
			--
			self.data.name = "gold_for_spawn_creep"
			self.data.icontype = "image"
			self.data.image = "file://{images}/challenges/gold_for_spawn_creep.png"
			self.data.progress = 0
			local count_mult = RandomInt(1, 3)
			self.data.goal = (count_mult + 1) * 1000
			self.data.reward = 210 + count_mult * 30
			self.data.normal = true
			self.data.turbo = false
			self.data.duos = false
			--self.locked = false
			--
		end,
		OnLoaded = function(self)
			
		end,
		ChallengeTriggerEvent = function(self, event_name, table)
			if event_name == "spawn_creep" then
				self.data.progress = self.data.progress + table.item:GetGoldCost(table.item:GetLevel()-1)
				if self.data.progress >= self.data.goal then
					self:Complete()
				end
				Challenges:UpdateChallengesForPlayer(self.owner_id)
			end
		end
	}
}

function Challenges:TriggerEvent(playerid, event_name, table)
	if PlayerResource:GetPlayerCount() == 4 and not GameRules:IsCheatMode() and Challenges.player_data[playerid] and not Challenges.player_data[playerid].saved then
		for _, player_challenge in pairs(Challenges.player_data[playerid].challenges) do
			if not player_challenge.data.completed and not player_challenge.data.locked and ((player_challenge.data.normal and _G.normal) or (player_challenge.data.turbo and _G.turbo) or (player_challenge.data.duos and _G.duos)) then
				player_challenge:ChallengeTriggerEvent(event_name, table)
			end
		end
	end
end

function Challenges:GenerateChallenge(playerid, challengeid, data)
	local challenge = {}
	challenge.owner_id = playerid
	challenge.OnGenerate = Challenges.challenges_list[challengeid].OnGenerate
	if data then
		challenge.data = data
	else
		challenge.data = {}
		challenge.data.challengeid = challengeid
		challenge.data.refreshable = true
		challenge.data.locked = false
		challenge.data.completed = false
		challenge:OnGenerate()
	end
	challenge.OnLoaded = Challenges.challenges_list[challengeid].OnLoaded
	challenge.ChallengeTriggerEvent = Challenges.challenges_list[challengeid].ChallengeTriggerEvent
	challenge.Complete = function(self)
		self.data.refreshable = false
		self.data.completed = true
		self.data.progress = self.data.goal
		if self.data.reward > 0 then
			Store:AddCoins(self.owner_id, self.data.reward)
		end
		-- Challenges:UpdateChallengesForPlayer(self.owner_id)
		-- print(self.data.reward)
	end
	return challenge
end

function Challenges:GetChallenges(data)
	if data.PlayerID then
		Challenges:UpdateChallengesForPlayer(data.PlayerID)
	end
end

function Challenges:UpdateChallengesForPlayer(playerid)
	if Challenges.player_data[playerid] then
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(playerid), "challenges_set_quests", Challenges.player_data[playerid].challenges)
	end
end

-- [SCD-OFFLINE] challenges.php недоступен. Колбэк ответа заполнял Challenges.player_data;
-- без него панель челленджей просто молчала бы, а RefreshChallenges уронился бы на
-- nil-индексации (Challenges.player_data[data.PlayerID] == nil). Поэтому offline-ветка
-- СРАЗУ генерирует локальный набор челленджей - тот же, что оригинал делает при отсутствии
-- сохранения на сервере. Слушатели регистрируются в обоих ветках и ровно один раз.
function Challenges:LoadPlayers()
	if _G.SCD_OFFLINE then
		SCD_OfflineNote("challenges.php skipped: local challenges generated")
		Challenges:GenerateLocalChallenges()
	else
		Challenges:LoadPlayersFromServer()
	end

	CustomGameEventManager:RegisterListener("GetChallenges", Dynamic_Wrap(Challenges, 'GetChallenges'))
	CustomGameEventManager:RegisterListener("RefreshChallenges", Dynamic_Wrap(Challenges, 'RefreshChallenges'))
end

-- [SCD-OFFLINE] локальная генерация (без сервера): каждому игроку 8 случайных челленджей.
-- id 4..8 остаются заблокированными, как в оригинале при boost_lvl = 0: _G.patreons намеренно
-- пуст (патреон-уровень дает еще и геймплейные бусты, а открываем мы только визуал).
-- Прогресс живет до конца матча, в БД не уходит (см. Challenges:SavePlayer).
function Challenges:GenerateLocalChallenges()
	local plc = PlayerResource:GetPlayerCount()
	for i=0, plc-1 do
		Challenges.player_data[i] = {}
		Challenges.player_data[i].saved = false
		Challenges.player_data[i].loaded = false
		Challenges.player_data[i].challenges = {}
		for challengeid=1, 8 do
			local challenge = Challenges:GenerateChallenge(i, RandomInt(1, #Challenges.challenges_list), nil)
			challenge.data.id = challengeid
			if challengeid > 3 then
				local boost_lvl = _G.patreons[tostring(PlayerResource:GetSteamAccountID(i))]
				if boost_lvl and boost_lvl >= challengeid - 3 then
					challenge.data.locked = false
				else
					challenge.data.locked = true
				end
			end
			table.insert( Challenges.player_data[i].challenges, challenge)
		end
		Challenges:UpdateChallengesForPlayer(i)
	end
end

-- оригинальная загрузка с сервера; вызывается только при _G.SCD_OFFLINE == false
function Challenges:LoadPlayersFromServer()
	local req = CreateHTTPRequestScriptVM( "GET", "https://dotascd.ru/challenges.php")
	req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKeyV3("1"))
	local plc = PlayerResource:GetPlayerCount()
	req:SetHTTPRequestGetOrPostParameter("count", tostring(plc))
	for i=1, plc do
		req:SetHTTPRequestGetOrPostParameter("id"..i, tostring(PlayerResource:GetSteamAccountID(i-1)))
	end
	req:Send(function(result)
		if result.Body ~= "" then
			local loaded_data = json.decode(result.Body)
			for i=0, plc-1 do
				Challenges.player_data[i] = {}
				Challenges.player_data[i].saved = false
				Challenges.player_data[i].challenges = {}
				if loaded_data[tostring(PlayerResource:GetSteamAccountID(i))] then
					Challenges.player_data[i].loaded = true
					-- print(loaded_data[tostring(PlayerResource:GetSteamAccountID(i))].data)
					local challenges_data = json.decode(loaded_data[tostring(PlayerResource:GetSteamAccountID(i))].data)
					for challengeid, challenge_data in pairs(challenges_data) do
						local challenge = Challenges:GenerateChallenge(i, challenge_data.challengeid, challenge_data)
						challenge.data.id = challengeid
						if challengeid > 3 then
							local boost_lvl = _G.patreons[tostring(PlayerResource:GetSteamAccountID(i))]
							if boost_lvl and boost_lvl >= challengeid - 3 then
								challenge.data.locked = false
							else
								challenge.data.locked = true
							end
						end
						table.insert( Challenges.player_data[i].challenges, challenge)
					end
				else
					Challenges.player_data[i].loaded = false
					for challengeid=1, 8 do
						local challenge = Challenges:GenerateChallenge(i, RandomInt(1, #Challenges.challenges_list), nil)
						challenge.data.id = challengeid
						if challengeid > 3 then
							local boost_lvl = _G.patreons[tostring(PlayerResource:GetSteamAccountID(i))]
							if boost_lvl and boost_lvl >= challengeid - 3 then
								challenge.data.locked = false
							else
								challenge.data.locked = true
							end
						end
						table.insert( Challenges.player_data[i].challenges, challenge)
					end
				end
				Challenges:UpdateChallengesForPlayer(i)
			end
		end
	end)
	
	-- Challenges.player_data[0] = {}
	-- Challenges.player_data[0].challenges = {}
	-- Challenges.player_data[0].loaded = false
	-- for challengeid=1, #Challenges.challenges_list do
	-- 	local challenge = Challenges:GenerateChallenge(0, challengeid, nil)
	-- 	if challengeid > 3 then
	-- 		local boost_lvl = _G.patreons[tostring(PlayerResource:GetSteamAccountID(0))]
	-- 		if boost_lvl and boost_lvl >= challengeid - 3 then
	-- 			challenge.data.locked = false
	-- 		else
	-- 			challenge.data.locked = true
	-- 		end
	-- 	end
	-- 	table.insert( Challenges.player_data[0].challenges, challenge)
	-- end
	-- Challenges:UpdateChallengesForPlayer(0)
	
	-- [SCD-OFFLINE] регистрация слушателей перенесена в Challenges:LoadPlayers: там она
	-- выполняется и в автономной ветке, и ровно один раз (двойная регистрация привела бы
	-- к двойному срабатыванию GetChallenges/RefreshChallenges на одно событие клиента).
end

function Challenges:RefreshChallenges(data)
	if data.PlayerID then
		local challenge = Challenges.player_data[data.PlayerID].challenges[data.id]
		if challenge.data.refreshable and not challenge.data.locked then
			local new_challenge = Challenges:GenerateChallenge(data.PlayerID, RandomInt(1, #Challenges.challenges_list), nil)
			new_challenge.data.id = data.id
			new_challenge.data.refreshable = false
			new_challenge.data.locked = false
			Challenges.player_data[data.PlayerID].challenges[data.id] = new_challenge
			Challenges:UpdateChallengesForPlayer(data.PlayerID)
		end
	end
end

function Challenges:SavePlayer(playerid)
	if Challenges.player_data[playerid] and not Challenges.player_data[playerid].saved then
		Challenges.player_data[playerid].saved = true
		-- [SCD-OFFLINE] сохранение прогресса уходило на challenges.php. Колбэк ответа пустой
		-- (внутри только закомментированный print), поэтому фоллбек не нужен - запрос просто
		-- не делается. Флаг saved выставлен выше: повторных попыток сохранения не будет.
		if _G.SCD_OFFLINE then
			SCD_OfflineNote("challenges.php save skipped: progress is not persisted")
			return
		end
		local data = {}
		for _, challenge in pairs(Challenges.player_data[playerid].challenges) do
			table.insert( data, challenge.data )
		end
		local req = CreateHTTPRequestScriptVM( "GET", "https://dotascd.ru/challenges.php")
		req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKeyV3("2"))
		req:SetHTTPRequestGetOrPostParameter("id", tostring(PlayerResource:GetSteamAccountID(playerid)))
		req:SetHTTPRequestGetOrPostParameter("loaded", tostring(Challenges.player_data[playerid].loaded))
		req:SetHTTPRequestGetOrPostParameter("data", json.encode(data))
		req:Send(function(result)
			--result.Body
		end)
	end
end

function Challenges:OnPlayerAbandoned(playerid)
	Challenges:SavePlayer(playerid)
end

function Challenges:OnGameEnded()
	for id, _ in pairs(Challenges.player_data) do
		Challenges:SavePlayer(id)
	end
end