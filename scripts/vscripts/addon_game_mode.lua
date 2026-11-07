-- [SCD-OFFLINE] ======================= АВТОНОМНЫЙ РЕЖИМ =======================
-- Рейтинг-сервер dotascd.ru заброшен и недоступен, поэтому игра работает полностью
-- автономно. Флаги задаются ЗДЕСЬ - до require(...) и до Activate(), то есть раньше
-- любого HTTP-запроса. Точки сети не удалены, а закрыты флагом: правка обратима
-- (достаточно поставить _G.SCD_OFFLINE = false, чтобы вернуть оригинальное поведение).
--   _G.SCD_OFFLINE              - ни одного запроса наружу, везде локальные фоллбеки;
--   _G.SCD_RATING_ENABLED       - серверная сторона рейтинга/MMR (net-таблица "Rating")
--                                 не заполняется и сервером не читается;
--   _G.SCD_UNLOCK_ALL_COSMETICS - донатерская косметика выдается всем игрокам бесплатно.
_G.SCD_OFFLINE = true
_G.SCD_RATING_ENABLED = false
_G.SCD_UNLOCK_ALL_COSMETICS = true

-- [SCD-OFFLINE] диагностика offline-веток. Одно и то же сообщение печатается ОДИН раз
-- за матч: точки вызываются из колбэков/таймеров, поэтому обычный print дал бы спам.
_G.SCD_OfflineNotes = _G.SCD_OfflineNotes or {}
_G.SCD_OfflineNote = _G.SCD_OfflineNote or function(msg)
	msg = tostring(msg)
	if _G.SCD_OfflineNotes[msg] then
		return
	end
	_G.SCD_OfflineNotes[msg] = true
	print("[SCD-OFFLINE] " .. msg)
end
-- [SCD-OFFLINE] ==================================================================

if not IsInToolsMode() then
	-- debug.oldTraceback = debug.oldTraceback or debug.traceback
	-- debug.traceback = function()
	-- 	local result = debug.oldTraceback()
	-- 	print(result)
	-- 	local req = CreateHTTPRequestScriptVM( "POST", "https://dotascd.ru/luadebug.php")
	-- 	req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKeyV3("2"))
	-- 	req:SetHTTPRequestGetOrPostParameter("match_id", tostring(GameRules:Script_GetMatchID()))
	-- 	req:SetHTTPRequestGetOrPostParameter("debug", result)
	-- 	req:Send(function(req_result)
	-- 		print(req_result.Body)
	-- 	end)
	-- 	return result
	-- end
end

-- require( "crashfix" )

require( 'libraries/client_server_utils' )
require( 'timers' )
require( 'physics' )
require('damage_system')
require( "utils" )
require( 'pets')
require( 'playertables')
require( 'libraries/wearable')
require( "libraries/webbd" )

require( "store" )
--require( "challenges" )
--require( "chests" )
--require( "battlepasses" )

require( "commands" )

-- [SCD-FIX] настройка косметики крипов, выбираемая хостом лобби на этапе выбора расы
require( "scd_settings" )

_G.profiler = require("profiler")

_G.onstartgame = {}
_G.playersinfo = {}

--_G.frostivus = require( 'frostivus' )--for event

_G.race_count = 19
_G.free_race_count = _G.race_count - 0

PrecacheTracker = {
    models = {},
    particles = {},
    units = {},
    sounds = {},
    items = {}
}

_G.precachecount = 0
_G.precachecount_needed = 0
function PrecacheIfNeeded(resourceType, resourcePath, context)
	_G.precachecount = _G.precachecount + 1
    if PrecacheTracker[resourceType] and PrecacheTracker[resourceType][resourcePath] then
        return true
    end

	if resourceType == "particle" then
		PrecacheResource("particle", resourcePath, context)
	elseif resourceType == "model" then
		PrecacheModel(resourcePath, context)
	elseif resourceType == "soundfile" then
		PrecacheResource("soundfile", resourcePath, context)
	else PrecacheResource(resourceType, resourcePath, context)
	end
	if not PrecacheTracker[resourceType] then
		PrecacheTracker[resourceType] = {}
	end
	PrecacheTracker[resourceType][resourcePath] = true
	_G.precachecount_needed = _G.precachecount_needed + 1
end

function PrecacheAssync(unit)
    if PrecacheTracker["units"] and PrecacheTracker["units"][unit] then
        return
    end
	PrecacheUnitByNameAsync(unit, function(...) end)
	PrecacheTracker["units"][unit] = true
end

if SCGameMode == nil then
	SCGameMode = class({})
end

function Precache( context )
	local fast_load = false--IsInToolsMode()
	if not fast_load then
		--[[
			Precache things we know we'll use.  Possible file types include (but not limited to):
				PrecacheResource( "model", "*.vmdl", context )
				PrecacheResource( "soundfile", "*.vsndevts", context )
				PrecacheResource( "particle", "*.vpcf", context )
				PrecacheResource( "particle_folder", "particles/folder", context )
		]]

		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_treant.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_skeletonking.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lich.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_clinkz.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_weaver.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_omniknight.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_keeper_of_the_light.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_legion_commander.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_axe.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_disruptor.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_juggernaut.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_alchemist.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_undying.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_snapfire.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sniper.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_rattletrap.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_silencer.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_antimage.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_windrunner.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_luna.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lone_druid.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_mirana.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_morphling.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_slardar.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_medusa.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_slark.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tidehunter.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_viper.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_naga_siren.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_riki.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_terrorblade.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_abyssal_underlord.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_earth_spirit.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_stormspirit.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_razor.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_enigma.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ember_spirit.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_void_spirit.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_jakiro.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ursa.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_queenofpain.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_earthshaker.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_enchantress.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_monkey_king.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lycan.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_beastmaster.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_scd.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_elder_titan.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_spectre.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_primal_beast.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dawnbreaker.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sven.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tusk.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts", context )
		PrecacheIfNeeded( "soundfile", "soundevents/voscripts/game_sounds_vo_announcer.vsndevts", context )
		
		PrecacheIfNeeded( "particle", "particles/new/human_mage/kotl_illuminate.vpcf", context )
		PrecacheIfNeeded( "particle", "particles/items5_fx/repair_kit.vpcf", context )
		PrecacheIfNeeded( "particle", "particles/generic_gameplay/generic_lifesteal.vpcf", context )
		PrecacheIfNeeded( "particle", "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf", context )
		
		PrecacheIfNeeded( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_shadow_attack.vpcf", context )
		PrecacheIfNeeded( "particle", "particles/econ/items/mirana/mirana_2021_immortal/mirana_2021_immortal_moonlight_recipient.vpcf", context )
		PrecacheIfNeeded( "particle", "particles/units/heroes/hero_mirana/mirana_moonlight_owner.vpcf", context )
		PrecacheIfNeeded( "particle", "particles/units/heroes/hero_dark_willow/dark_willow_wisp_spell.vpcf", context )
		
		PrecacheAssync("npc_dota_items_necro_range_1", function(...) end)
		PrecacheAssync("npc_dota_items_necro_melee_1", function(...) end)
		PrecacheAssync("npc_dota_items_necro_range_2", function(...) end)
		PrecacheAssync("npc_dota_items_necro_melee_2", function(...) end)
		PrecacheAssync("npc_dota_items_necro_range_3", function(...) end)
		PrecacheAssync("npc_dota_items_necro_melee_3", function(...) end)
		PrecacheAssync("npc_model_test", function(...) end)
		PrecacheAssync("npc_dota_custom_neutral", function(...) end)
		PrecacheAssync("npc_dota_custom_spec", function(...) end)
		PrecacheAssync("npc_dota_custom_tower", function(...) end)
		PrecacheAssync("npc_dota_custom_barrack", function(...) end)
		PrecacheAssync("npc_dota_custom_ancient", function(...) end)
		PrecacheAssync("npc_dummy_unit", function(...) end)
		PrecacheAssync("npc_cosmetic_pet", function(...) end)
		PrecacheAssync("npc_dota_test_creep_hero", function(...) end)
		PrecacheAssync("npc_dota_test_creep", function(...) end)
		PrecacheAssync("npc_elementals_weather", function(...) end)
		local precacheList = LoadKeyValues('scripts/npc/npc_units_custom.txt')
		-- _G.precachecount_async = 0
		-- print("npc_units")
		-- for unit, info in pairs(precacheList) do
		-- 	print(unit)
		-- 	PrecacheAssync(unit, function(...) end)
		-- 	_G.precachecount_async = _G.precachecount_async + 1
		-- end
		
		_G.racetable = FormRaceTable(LoadKeyValues("scripts/kv/races.kv"))		
		-- print("kakogo addon")
		local racestable = FormRaceTable(LoadKeyValues("scripts/kv/races.kv"))
		for _, v in pairs(racestable.races_names) do
		-- for k, v in pairs(racetable) do
			
			-- print(racestable[v].race_data.default_building_models.castle_model)
			PrecacheIfNeeded( "model", racestable[v].race_data.default_building_models.castle_model, context )
			PrecacheIfNeeded( "model", racestable[v].race_data.default_building_models.tower_model, context )
			-- print(racestable[v].race_data.default_building_models.tower_model)
			PrecacheIfNeeded( "model", racestable[v].race_data.default_building_models.racks_model, context )
			-- print(racestable[v].race_data.default_building_models.racks_model)
			PrecacheIfNeeded( "model", racestable[v].race_data.default_building_models.spec_model, context )
			-- print(racestable[v].race_data.default_building_models.spec_model)			

			-- for _, i in pairs(racestable[v].units) do
			-- 	print(i.def_wearables)
			-- 	-- PrecacheResource( "model", i.def_wearables, context )
			-- 	for _, j in pairs(i.def_wearables) do
			-- 		print(j)
			-- 		PrecacheResource( "model", j, context )
			-- 	end
			-- end
		end

		PrecacheIfNeeded( "model", "models/neutral_building_1.vmdl", context )
		PrecacheIfNeeded( "model", "models/neutral_building_2.vmdl", context )
		PrecacheIfNeeded( "model", "models/neutral_building_3.vmdl", context )
		PrecacheIfNeeded( "model", "models/neutral_building_4.vmdl", context )
		PrecacheIfNeeded( "model", "models/neutral_building_5.vmdl", context )
		PrecacheIfNeeded( "model", "models/neutral_building_6.vmdl", context )
		PrecacheIfNeeded( "model", "models/neutral_building_7.vmdl", context )
		PrecacheIfNeeded( "model", "models/neutral_building_8.vmdl", context )
		PrecacheIfNeeded( "model", "models/neutral_building_9.vmdl", context )
		PrecacheIfNeeded( "model", "models/neutral_building_10.vmdl", context )
		PrecacheIfNeeded( "model", "models/neutral_building_11.vmdl", context )
		PrecacheIfNeeded( "model", "models/neutral_building_12.vmdl", context )
		PrecacheIfNeeded( "model", "models/neutral_building_13.vmdl", context )
		PrecacheIfNeeded( "model", "models/neutral_building_14.vmdl", context )
		PrecacheIfNeeded( "model", "models/neutral_building_15.vmdl", context )
		PrecacheIfNeeded( "model", "models/neutral_building_16.vmdl", context )

		PrecacheIfNeeded( "model", "models/items/lycan/ultimate/_ascension_of_the_hallowed_beast_form/_ascension_of_the_hallowed_beast_form.vmdl", context )
		PrecacheIfNeeded( "model", "models/heroes/terrorblade/demon.vmdl", context )
		PrecacheIfNeeded( "model", "models/props_frostivus/frostivus_snowman.vmdl", context )
		PrecacheIfNeeded( "model", "models/heroes/nerubian_assassin/mound.vmdl", context )
		PrecacheIfNeeded( "model", "models/items/lycan/ultimate/blood_moon_hunter_shapeshift_form/blood_moon_hunter_shapeshift_form.vmdl", context )
		
		
		
		-- PrecacheResource( "model", , context )

		
		local store_items = LoadKeyValues("scripts/kv/store.kv").items
		for _, item_data in pairs(store_items) do
			if item_data and item_data.type then
				if item_data.type == "buildings" then
					if item_data.castle_model then
						PrecacheIfNeeded("model", item_data.castle_model, context )
					end
					if item_data.tower_model then
						PrecacheIfNeeded("model", item_data.tower_model, context )
					end
					if item_data.racks_model then
						PrecacheIfNeeded("model", item_data.racks_model, context )
					end
					if item_data.spec_model then
						PrecacheIfNeeded("model", item_data.spec_model, context )
					end
				end
				-- -- if item_data.type == "pet" then
				-- -- 	PrecacheResource("model", item_data.pet_model, context )
				-- -- 	PrecacheResource("particle", item_data.pet_particle, context)
				-- -- end
				-- if item_data.type == "building_attack_particle" then
				-- 	PrecacheResource("particle", item_data.attack_particle, context)
				-- end
				-- if item_data.type == "unit_set" then
				-- 	PrecacheResource("model", item_data.model, context)
				-- end
				-- if item_data.type == "hero_set" then
				-- 	PrecacheResource("model", item_data.model, context)
				-- end
			end
		end
		
		-- local precacheList = LoadKeyValues('scripts/npc/npc_items_custom.txt')
		-- for item, info in pairs(precacheList) do
		-- 	PrecacheItemByNameSync(item, context)
		-- end


		-- Load the npc_abilities_custom.txt file
		local abilities = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")

		-- Loop through all abilities
		for ability_name, ability_data in pairs(abilities) do
			-- print(ability_name)
			-- Check if the ability has a "precache" block
			if ability_data and ability_data.precache then
				-- Precache particles
				if ability_data.precache.particle then
					for k,v in pairs(ability_data.precache.particle) do
						-- print(v)
						PrecacheIfNeeded("particle", v, context)
					end
				end

				-- if ability_data.precache.particle then
				-- 	print(ability_data.precache.particle)
				-- 	PrecacheIfNeeded("particle", ability_data.precache.particle, context)
				-- end
				
				-- Precache soundfiles
				if ability_data.precache.soundfile  then
					for k,v in pairs(ability_data.precache.soundfile) do
						-- print(v)
						PrecacheIfNeeded("soundfile", v, context)
					end
				end
				-- if ability_data.precache.soundfile then
				-- 	print(ability_data.precache.soundfile)
				-- 	PrecacheIfNeeded("soundfile", ability_data.precache.soundfile, context)
				-- end
				
				-- Precache models (if needed)
				if ability_data.precache.model  then
					for k,v in pairs(ability_data.precache.model) do
						-- print(v)
						PrecacheIfNeeded("model", v, context)
					end
				end
				-- if ability_data.precache.model then
				-- 	print(ability_data.precache.model)
				-- 	PrecacheIfNeeded("model", ability_data.precache.model, context)
				-- end
			end
		end

	end

	print("Precache total")
	print(_G.precachecount)
	print("Precache needed")
	print(_G.precachecount_needed)
	-- print("Precache async")
	-- print(_G.precachecount_async)

	GCCollect()
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = SCGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function SCGameMode:InitGameMode()
	print( "Addon is loaded." )

	local rating_in_normal = true

	_G.duos = GetMapName() == "duos"
	_G.turbo = GetMapName() == "turbo"
	_G.normal = _G.duos == false and _G.turbo == false
	-- [SCD-OFFLINE] серверная сторона рейтинга отключена вместе с сервером. _G.rating
	-- остается определенным (на него ссылается SCGameMode:Stats), но всегда false.
	if _G.SCD_RATING_ENABLED then
		if rating_in_normal then
			_G.rating = true
		else
			_G.rating = GetMapName() ~= "normal"
		end
	else
		_G.rating = false
	end
	_G.polygon = GetMapName() == "polygon"
	
	Store:Init()
	--Chests:Init()
	--BattlePasses:Init()

	-- local MAX_LEVEL = 50
	-- local XP_PER_LEVEL_TABLE = {}
	-- XP_PER_LEVEL_TABLE[0] = 0
	-- for i=1,MAX_LEVEL do
	-- 	XP_PER_LEVEL_TABLE[i] = i * 100 + XP_PER_LEVEL_TABLE[i-1]
	-- end

	-- Setup rules
	GameRules:SetShowcaseTime( 0.0 )
    GameRules:GetGameModeEntity():SetAnnouncerDisabled( false )
 	-- GameRules:GetGameModeEntity():DisableHudFlip( true )
	GameRules:SetStrategyTime( 0.0 )
	GameRules:SetHeroRespawnEnabled( false )
	--GameRules:SetUseUniversalShopMode( true )
	GameRules:SetSameHeroSelectionEnabled( true )
	--GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
	GameRules:SetPreGameTime( 60)
	-- GameRules:SetPostGameTime( 30 )
	--GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
	-- GameRules:SetUseCustomHeroXPValues( true )
	--GameRules:SetGoldPerTick(0)
	--GameRules:SetGoldTickTime(9999999)
	--GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
	--GameRules:SetUseBaseGoldBountyOnHeroes(USE_STANDARD_HERO_GOLD_BOUNTY)
	-- GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
	-- GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
	-- GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )
	if _G.duos then
		_G.duos_spawn = {}
		_G.duos_spawn[DOTA_TEAM_GOODGUYS] = 0
		_G.duos_spawn[DOTA_TEAM_BADGUYS] = 0
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 2 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 2 )
	else
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 1 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 1 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_1, 1 )
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_CUSTOM_2, 1 )
	end
	GameRules:EnableCustomGameSetupAutoLaunch(true)
    GameRules:SetCustomGameSetupAutoLaunchDelay(0)
    
	local mode = GameRules:GetGameModeEntity()
	mode:SetRecommendedItemsDisabled( true )
	--mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
	--mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
	mode:SetBuybackEnabled( false )
	--mode:SetTopBarTeamValuesOverride ( USE_CUSTOM_TOP_BAR_VALUES )
	mode:SetTopBarTeamValuesVisible( false )
	-- mode:SetUseCustomHeroLevels( true )
	-- mode:SetCustomHeroMaxLevel( MAX_LEVEL )
	-- mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )
	--mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
	--mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )
	mode:SetFogOfWarDisabled(_G.polygon)
	mode:SetGoldSoundDisabled( true )
	--mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )
    --mode:SetLoseGoldOnDeath( false )
	--mode:SetSelectionGoldPenaltyEnabled( false )
    mode:SetHudCombatEventsDisabled(true)
	mode:SetCustomGameForceHero("npc_dota_hero_wisp")
	mode:SetCameraDistanceOverride(1500)
    
    mode:SetHUDVisible(DOTA_HUD_VISIBILITY_TOP_HEROES,true)
    --mode:SetHUDVisible(DOTA_HUD_VISIBILITY_ACTION_MINIMAP,false)
	mode:SetHUDVisible(DOTA_HUD_VISIBILITY_INVENTORY_COURIER, false)
	mode:SetHUDVisible(DOTA_HUD_VISIBILITY_KILLCAM, false)
	
	SetTeamCustomHealthbarColor( DOTA_TEAM_GOODGUYS, 255, 108, 0   )
	SetTeamCustomHealthbarColor( DOTA_TEAM_BADGUYS,  197, 77,  168 )
	SetTeamCustomHealthbarColor( DOTA_TEAM_CUSTOM_1, 243, 201, 9   )
	SetTeamCustomHealthbarColor( DOTA_TEAM_CUSTOM_2, 61,  210, 150 )
	
    --mode:SetItemAddedToInventoryFilter( Dynamic_Wrap( GameMode, "ItemAddedToInventoryFilter" ), self )
	mode:SetExecuteOrderFilter( Dynamic_Wrap( SCGameMode, "ExecuteOrderFilter" ), self )
	mode:SetDamageFilter(Dynamic_Wrap( DamageSystem, "DamageFilter" ), self)
	mode:SetModifyGoldFilter(Dynamic_Wrap( SCGameMode, "ModifyGoldFilter" ), self)

	-- Listeners - Event Hooks
	-- All of these events can potentially be fired by the game, though only the uncommented ones have had
	-- Functions supplied for them.
	-- ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(SCGameMode, 'OnPlayerLevelUp'), self)
	-- ListenToGameEvent('dota_ability_channel_finished', Dynamic_Wrap(SCGameMode, 'OnAbilityChannelFinished'), self)
	-- ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(SCGameMode, 'OnPlayerLearnedAbility'), self)
	-- ListenToGameEvent('player_connect_full', Dynamic_Wrap(SCGameMode, 'OnConnectFull'), self)
	-- ListenToGameEvent('player_disconnect', Dynamic_Wrap(SCGameMode, 'OnDisconnect'), self)
	-- ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(SCGameMode, 'OnItemPurchased'), self)
	-- ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(SCGameMode, 'OnItemPickedUp'), self)
	-- ListenToGameEvent('last_hit', Dynamic_Wrap(SCGameMode, 'OnLastHit'), self)
	-- ListenToGameEvent('player_changename', Dynamic_Wrap(SCGameMode, 'OnPlayerChangedName'), self)
	-- ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(SCGameMode, 'OnRuneActivated'), self)
	-- ListenToGameEvent('dota_player_take_tower_damage', Dynamic_Wrap(SCGameMode, 'OnPlayerTakeTowerDamage'), self)
	-- ListenToGameEvent('tree_cut', Dynamic_Wrap(SCGameMode, 'OnTreeCut'), self)
	-- ListenToGameEvent('entity_hurt', Dynamic_Wrap(SCGameMode, 'OnEntityHurt'), self)
	-- ListenToGameEvent('player_connect', Dynamic_Wrap(SCGameMode, 'PlayerConnect'), self)
	-- ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(SCGameMode, 'OnPlayerPickHero'), self)
	-- ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(SCGameMode, 'OnTeamKillCredit'), self)
	-- ListenToGameEvent("player_reconnected", Dynamic_Wrap(SCGameMode, 'OnPlayerReconnect'), self)
	-- ListenToGameEvent('player_stats_updated', Dynamic_Wrap(SCGameMode, 'OnPSUpdated'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(SCGameMode, 'OnEntityKilled'), self)
	ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(SCGameMode, 'OnNonPlayerUsedAbility'), self)
	-- ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(SCGameMode, 'OnAbilityUsed'), self)
	ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(SCGameMode, 'OnGameRulesStateChange'), self)
	ListenToGameEvent('npc_spawned', Dynamic_Wrap(SCGameMode, 'OnNPCSpawned'), self)
	
	CustomGameEventManager:RegisterListener("SelectRace", Dynamic_Wrap(SCGameMode, 'SelectRace'))
	CustomGameEventManager:RegisterListener("SelectAbil", Dynamic_Wrap(SCGameMode, 'SelectAbil'))
	CustomGameEventManager:RegisterListener("SetCameraPos", Dynamic_Wrap(Pets, 'SetCameraPos'))
	CustomGameEventManager:RegisterListener("RatingSettings", Dynamic_Wrap(SCGameMode, 'RatingSettings'))
	CustomGameEventManager:RegisterListener("SetSelectedEntity", Dynamic_Wrap(SCGameMode, 'SetSelectedEntity'))
	--CustomGameEventManager:RegisterListener("Surrend", Dynamic_Wrap(SCGameMode, 'PlayerSurrend'))
    ListenToGameEvent('player_chat',Dynamic_Wrap(SCGameMode,'OnPlayerChat'),self)
	
	-- CustomGameEventManager:RegisterListener( "building_selection_select", function( _, data )
	-- 	print( "Building Selected", data.PlayerID, data.name )
	-- 	local id = data.PlayerID
	-- 	if id then
	-- 		local abil = _G.playersinfo[id].spec:FindAbilityByName(data.name)
	-- 		if abil then
	-- 			_G.playersinfo[id].spec:CastAbilityNoTarget(abil, _G.playersinfo[id].spec:entindex())
	-- 		end
	-- 	end
	-- end )

	Commands:Init()

	_G.selected_entity = {}

	_G.patreons = {}
	_G.playerstats = {}
	_G.additional_building_triggers = {}
	for i=1,8 do
		table.insert(_G.additional_building_triggers, Entities:FindByName( nil, "building_trigger_"..i))
	end
	
	_G.ratingstable = {}
	_G.ratingstable["settings"] = {}
	_G.ratingstable["ratings"] = {}
	-- [SCD-OFFLINE] net-таблица "Rating" больше не заполняется (MMR убран из UI).
	-- Пустая структура _G.ratingstable сохранена: на нее есть обращения в коде ниже,
	-- и они не должны получить nil-индексацию.
	if _G.SCD_RATING_ENABLED then
		CustomNetTables:SetTableValue("Rating","stats",{enable = _G.rating})
	end

	_G.bonus_ids = {
		[0] = {3,5,7,8,9,12,14},
		[1] = {1,2,4,6,10,16}
	}
	_G.additional_buildings = {}
	for i=1,8 do
		local building_point = Entities:FindByName( nil, "building_"..i):GetAbsOrigin()
		-- print(building_point)
		local building = CreateUnitByName("npc_dota_custom_neutral", building_point, false, nil, nil, DOTA_TEAM_NEUTRALS)
		building.building_id = i
		_G.additional_buildings[i] = building
	end

	_G.statsinfo = {}
	
	Pets:Init()
	mode:SetThink( "OnThink", self, 0.2 )
	-- [SCD-FIX] LoadKeyValues обёрнуты: падение любого из них раньше обрывало InitGameMode,
	-- из-за чего таблица kvs (цены в тултипах) не создавалась
	local function LoadKVSafe(path)
		local ok, res = pcall(LoadKeyValues, path)
		if not ok or res == nil then
			print("[SCD-DIAG] LoadKeyValues FAILED for " .. path .. ": " .. tostring(res))
			return {}
		end
		return res
	end
	self.ItemKVs = LoadKVSafe("scripts/npc/npc_items_custom.txt")
  	self.AbilityKVs = SCGameMode:DeleteTrashFromTable(LoadKVSafe("scripts/npc/npc_abilities_custom.txt"))
	self.UnitsKVs = SCGameMode:DeleteTrashFromTable(LoadKVSafe("scripts/npc/npc_units_custom.txt"))
	print("[SCD-DIAG] KV loaded: abilities=" .. (self.AbilityKVs and SCGameMode:TableCount(self.AbilityKVs) or "nil") ..
		" units=" .. (self.UnitsKVs and SCGameMode:TableCount(self.UnitsKVs) or "nil") ..
		" items=" .. (self.ItemKVs and SCGameMode:TableCount(self.ItemKVs) or "nil"))
end

-- [SCD-FIX] утилита для диагностики размера таблиц
function SCGameMode:TableCount(t)
	local n = 0
	for _ in pairs(t) do n = n + 1 end
	return n
end

function SCGameMode:DeleteTrashFromTable(table)
	for k, v in pairs(table) do
		if k == "Creature" or
			k == "precache" or
			k == "OnSpellStart" or
			k == "Modifiers" or
			k == "OnProjectileHitUnit" or
			k == "OnOwnerDied" or
			k == "OnChannelFinish" or
			k == "OnChannelInterrupted" or
			k == "OnChannelSucceeded" or
			k == "OnProjectileFinish"
		then
			table[k] = nil
		else
			if type(v) == "table" then
				table[k] = SCGameMode:DeleteTrashFromTable(v)
			end
		end
	end
	return table
end

function split(inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            t[i] = str
            i = i + 1
    end
    return t
end

function StringStartsWith(fullstring, substring)
    local strlen = string.len(substring)
    local first_characters = string.sub(fullstring, 1 , strlen)
    return (first_characters == substring)
end

admins = {[168469368]=true,[151748010]=true,[130646433]=true,[113726782]=true, [147554886] = true}
function SCGameMode:OnPlayerChat(keys)
    local teamonly = keys.teamonly
    local userID = keys.userid
    local playerID = keys.playerid
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)

    local text = keys.text
    local steam_id = PlayerResource:GetSteamAccountID(playerID)
    if PlayerResource:IsValidPlayer(playerID) then
        if not steam_id then return end
        if StringStartsWith(text, "-") then
            local input = split(string.sub(text, 2, string.len(text)))
            local command = input[1]
        	if admins[steam_id] or GameRules:IsCheatMode() then
                if command == "allvis" then
                    AddFOWViewer(hero:GetTeam(),Vector(0,5000,0),tonumber(input[3]) or 10000,tonumber(input[2]) or 5,false)
                    AddFOWViewer(hero:GetTeam(),Vector(0,-5000,0),tonumber(input[3]) or 10000,tonumber(input[2]) or 5,false)
                    AddFOWViewer(hero:GetTeam(),Vector(5000,0,0),tonumber(input[3]) or 10000,tonumber(input[2]) or 5,false)
                    AddFOWViewer(hero:GetTeam(),Vector(5000,-5000,0),tonumber(input[3]) or 10000,tonumber(input[2]) or 5,false)
                    AddFOWViewer(hero:GetTeam(),Vector(5000,5000,0),tonumber(input[3]) or 10000,tonumber(input[2]) or 5,false)
                    AddFOWViewer(hero:GetTeam(),Vector(-5000,-5000,0),tonumber(input[3]) or 10000,tonumber(input[2]) or 5,false)
                    AddFOWViewer(hero:GetTeam(),Vector(-5000,5000,0),tonumber(input[3]) or 10000,tonumber(input[2]) or 5,false)
                    AddFOWViewer(hero:GetTeam(),Vector(-5000,0,0),tonumber(input[3]) or 10000,tonumber(input[2]) or 5,false)
                    AddFOWViewer(hero:GetTeam(),Vector(0,0,0),tonumber(input[3]) or 10000,tonumber(input[2]) or 5,false)
                end
                if command == 'settimescale' then
                    Convars:SetFloat("host_timescale", tonumber(input[2]))
                end
                if command == "ggold" then
                	hero:ModifyGold(tonumber(input[2]) or 10000, false, DOTA_ModifyXP_Unspecified)
                end
			end
			if admins[steam_id] or IsInToolsMode() then
				if command == "teststore" then
					-- Store:TestStore(tonumber(input[2]))
					print("test store command")
					print(playerID)
					print(steam_id)
					Store:TestStore(playerID)
                end
				if command == "gpt" then
					local gameEvent1 = {}
					gameEvent1["teamnumber"] = hero:GetTeam()
					gameEvent1["message"] = "#combat_gpt"
					FireGameEvent( "dota_combat_event_message", gameEvent1 )
					for id, data in pairs(_G.playersinfo) do
						local gameEventn = {}
						gameEventn["player_id"] = id
						gameEventn["teamnumber"] = hero:GetTeam()
						gameEventn["locstring_value"] = tostring(data.gpt)
						gameEventn["message"] = "#combat_gpt_value"
						FireGameEvent( "dota_combat_event_message", gameEventn )
					end
					-- local gameEvent = {}
					-- gameEvent["player_id"] = caster:GetPlayerOwnerID()
					-- gameEvent["teamnumber"] = -1
					-- gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_" .. ability:GetAbilityName()
					-- gameEvent["message"] = "#Combat_Message_use_ultimate"
					-- FireGameEvent( "dota_combat_event_message", gameEvent )
                end
				if command == "cg" then
					local gameEvent1 = {}
					gameEvent1["teamnumber"] = hero:GetTeam()
					gameEvent1["message"] = "#combat_cg"
					FireGameEvent( "dota_combat_event_message", gameEvent1 )
					for id, data in pairs(_G.playersinfo) do
						local gameEventn = {}
						gameEventn["player_id"] = id
						gameEventn["teamnumber"] = hero:GetTeam()
						gameEventn["locstring_value"] = tostring(PlayerResource:GetGold(id))
						gameEventn["message"] = "#combat_cg_value"
						FireGameEvent( "dota_combat_event_message", gameEventn )
					end
                end
				if command == "sb" then
					local gameEvent1 = {}
					gameEvent1["teamnumber"] = hero:GetTeam()
					gameEvent1["message"] = "#combat_sb"
					FireGameEvent( "dota_combat_event_message", gameEvent1 )
					for id, data in pairs(_G.playerstats) do
						local gameEventn = {}
						gameEventn["player_id"] = id
						gameEventn["teamnumber"] = hero:GetTeam()
						if _G.playersinfo[id].spec.specpass then
							gameEventn["locstring_value"] = _G.playersinfo[id].spec.specpass_name or _G.playersinfo[id].spec.specpass:GetAbilityName()
						else
							gameEventn["locstring_value"] = "none"
						end
						gameEventn["message"] = "#combat_sb_value"
						FireGameEvent( "dota_combat_event_message", gameEventn )
					end
				end
            end			
			-- if command == "teststore" then
			-- 	Store:TestStore(tonumber(input[2]))
			-- 	print("test store command")
			-- 	print(playerID)
			-- 	print(steam_id)
			-- 	Store:TestStore(playerID)
			-- end
			if command == "all" then
				local gameEvent1 = {}
				gameEvent1["teamnumber"] = hero:GetTeam()
				gameEvent1["message"] = "#combat_all"
				FireGameEvent( "dota_combat_event_message", gameEvent1 )
				for id, data in pairs(_G.playerstats) do
					local gameEventn = {}
					gameEventn["player_id"] = id
					gameEventn["teamnumber"] = hero:GetTeam()
					gameEventn["locstring_value"] = tostring(data.goldspend + PlayerResource:GetGold(id)) .. " | " .. tostring(data.goldspend + PlayerResource:GetGold(id) - data.goldspend_to_summon_creeps - data.goldspend_to_summon_heroes) .. " | " .. tostring(data.tower_upgrades + data.castle_upgrades + data.spec_upgrades) .. " | " .. tostring(PlayerResource:GetLastHits(id) .. " | " .. tostring(data.goldspend_to_summon_creeps + data.goldspend_to_summon_heroes))
					gameEventn["message"] = "#combat_all_value"
					FireGameEvent( "dota_combat_event_message", gameEventn )
				end
			end
			if command == "tg" then
				local gameEvent1 = {}
				gameEvent1["teamnumber"] = hero:GetTeam()
				gameEvent1["message"] = "#combat_tg"
				FireGameEvent( "dota_combat_event_message", gameEvent1 )
				for id, data in pairs(_G.playerstats) do
					local gameEventn = {}
					gameEventn["player_id"] = id
					gameEventn["teamnumber"] = hero:GetTeam()
					gameEventn["locstring_value"] = tostring(data.goldspend + PlayerResource:GetGold(id))
					gameEventn["message"] = "#combat_tg_value"
					FireGameEvent( "dota_combat_event_message", gameEventn )
				end
			end
			if command == "re" then
				local gameEvent1 = {}
				gameEvent1["teamnumber"] = hero:GetTeam()
				gameEvent1["message"] = "#combat_re"
				FireGameEvent( "dota_combat_event_message", gameEvent1 )
				for id, data in pairs(_G.playerstats) do
					local gameEventn = {}
					gameEventn["player_id"] = id
					gameEventn["teamnumber"] = hero:GetTeam()
					gameEventn["locstring_value"] = tostring(data.tower_upgrades + data.castle_upgrades + data.spec_upgrades)
					gameEventn["message"] = "#combat_re_value"
					FireGameEvent( "dota_combat_event_message", gameEventn )
				end
			end
			if command == "ng" then
				local gameEvent1 = {}
				gameEvent1["teamnumber"] = hero:GetTeam()
				gameEvent1["message"] = "#combat_ng"
				FireGameEvent( "dota_combat_event_message", gameEvent1 )
				for id, data in pairs(_G.playerstats) do
					local gameEventn = {}
					gameEventn["player_id"] = id
					gameEventn["teamnumber"] = hero:GetTeam()
					gameEventn["locstring_value"] = tostring(data.goldspend + PlayerResource:GetGold(id) - data.goldspend_to_summon_creeps - data.goldspend_to_summon_heroes)
					gameEventn["message"] = "#combat_ng_value"
					FireGameEvent( "dota_combat_event_message", gameEventn )
				end
			end
			if command == "cs" then
				local gameEvent1 = {}
				gameEvent1["teamnumber"] = hero:GetTeam()
				gameEvent1["message"] = "#combat_cs"
				FireGameEvent( "dota_combat_event_message", gameEvent1 )
				for id, data in pairs(_G.playerstats) do
					local gameEventn = {}
					gameEventn["player_id"] = id
					gameEventn["teamnumber"] = hero:GetTeam()
					gameEventn["locstring_value"] = tostring(PlayerResource:GetLastHits(id))
					gameEventn["message"] = "#combat_cs_value"
					FireGameEvent( "dota_combat_event_message", gameEventn )
				end
			end
		end
    end
end

function SCGameMode:Stats(winner)
	-- [SCD-OFFLINE] отчет о матче уходил только на data.php (параметр rating - туда же).
	-- Колбэк ничего не инициализирует, лишь печатает тело ответа, поэтому фоллбек не нужен:
	-- запрос просто не делается. Вызов SCGameMode:Stats(winner) в _G:Defeat остается.
	if _G.SCD_OFFLINE then
		SCD_OfflineNote("Stats: data.php match report skipped")
		return
	end
    local plc = PlayerResource:GetPlayerCount()
	if not GameRules:IsCheatMode() and GameRules:GetDOTATime(false,false) > 300 and plc == 4 then
        local req = CreateHTTPRequestScriptVM( "GET", "https://dotascd.ru/data.php")
        req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKeyV3("2"))
        req:SetHTTPRequestGetOrPostParameter("time", tostring(math.floor(GameRules:GetDOTATime(false,false))))
        req:SetHTTPRequestGetOrPostParameter("turbo", tostring(_G.turbo))
		req:SetHTTPRequestGetOrPostParameter("duos", tostring(_G.duos))
		req:SetHTTPRequestGetOrPostParameter("rating", tostring(_G.rating))
		local team_to_neutrals = {}
		team_to_neutrals[DOTA_TEAM_BADGUYS] = {8,1}
		team_to_neutrals[DOTA_TEAM_CUSTOM_1] = {2,3}
		team_to_neutrals[DOTA_TEAM_CUSTOM_2] = {4,5}
		team_to_neutrals[DOTA_TEAM_GOODGUYS] = {6,7}
		for i=1,plc do
			local id = _G.statsinfo[5-i]
            req:SetHTTPRequestGetOrPostParameter("race" .. i, tostring(_G.playersinfo[id].race))
			req:SetHTTPRequestGetOrPostParameter("id" .. i, tostring(PlayerResource:GetSteamAccountID(id)))
			req:SetHTTPRequestGetOrPostParameter("spec" .. i, _G.playersinfo[id].spec.specpass_name or _G.playersinfo[id].spec.specpass:GetAbilityName())
			req:SetHTTPRequestGetOrPostParameter("aura" .. i, _G.playersinfo[id].aura)
			req:SetHTTPRequestGetOrPostParameter("neutral" .. i .. "_1", tostring(_G.additional_buildings[team_to_neutrals[PlayerResource:GetTeam(id)][1]].neutral_bonus_id))
			req:SetHTTPRequestGetOrPostParameter("neutral" .. i .. "_2", tostring(_G.additional_buildings[team_to_neutrals[PlayerResource:GetTeam(id)][2]].neutral_bonus_id))
        end
		req:SetHTTPRequestGetOrPostParameter("ver", "3.19")
        req:Send(function(result)
            print(result.Body)
		end)
    end
end

function SCGameMode:ExecuteOrderFilter(filterTable)
	-- print("ExecuteOrderFilter")
	-- DeepPrintTable(filterTable)
	-- local orderType = filterTable.order_type
	-- local playerId = filterTable.issuer_player_id_const
	-- local target = filterTable.entindex_target ~= 0 and EntIndexToHScript(filterTable.entindex_target) or nil
	-- -- `entindex_ability` is item id in some orders without entity

	if _G.polygon then
		return true
	end
	
	local unit
	-- TODO: Are there orders without a unit?
	if filterTable.units and filterTable.units["0"] then
		unit = EntIndexToHScript(filterTable.units["0"])
	end

	if GameRules:State_Get() ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		if not (unit and unit:GetUnitName() == "npc_dota_custom_spec") then
			return false
		else
			if unit.specpass then
				return false
			end
		end
	end
	
	return true
end

function SCGameMode:RatingSettings(data)
	-- [SCD-OFFLINE] регистрация слушателя сохранена: settings-панель клиента по-прежнему
	-- шлет RatingSettings, сервер принимает событие и молча его игнорирует (рейтинг убран).
	-- Без этого return чекбокс клиента вызывал бы UpdateRatingNetTable, а тот читает
	-- net-таблицу "Rating", которая теперь не заполняется -> nil-индексация в обработчике.
	if not _G.SCD_RATING_ENABLED then
		return
	end
	if data.PlayerID and data.checked then
		_G.ratingstable["settings"][data.PlayerID] = data.checked
		SCGameMode:UpdateRatingNetTable()
	end
end

function SCGameMode:UpdateRatingNetTable()
	-- [SCD-OFFLINE] net-таблица "Rating" больше не заполняется и сервером не читается.
	-- Функция оставлена заглушкой: ее вызывают RatingSettings, фаза HERO_SELECTION и
	-- колбэк getrating. Оригинальное тело сохранено ниже под флагом (правка обратима).
	if not _G.SCD_RATING_ENABLED then
		return
	end
	-- DeepPrintTable(_G.ratingstable)
	local table = CustomNetTables:GetTableValue("Rating","stats")
	table["ratings"] = {}
	for i=0,PlayerResource:GetPlayerCount()-1 do
		if _G.ratingstable["settings"][i] ~= 1 and _G.rating then
			table["ratings"][i] = _G.ratingstable["ratings"][tostring(PlayerResource:GetSteamAccountID(i))] or {normal=1000,turbo=1000,duos=1000}
		end
	end
	CustomNetTables:SetTableValue("Rating","stats",table)
end

function SCGameMode:OnNonPlayerUsedAbility(keys)
	-- print("OnNonPlayerUsedAbility")
	-- DeepPrintTable(keys)
	local npc = EntIndexToHScript(keys.caster_entindex)
	
	local abil = npc:FindAbilityByName(keys.abilityname)
	-- print(abil)
	if not abil then
		for i=0,15 do
			local item = npc:GetItemInSlot(i)
			-- print(item)
			if item and item:GetAbilityName() == keys.abilityname then
				abil = item
			end
		end
	end
	if abil then
		local id = npc:GetPlayerOwnerID()
		_G.playerstats[id].goldspend = _G.playerstats[id].goldspend + abil:GetGoldCost(abil:GetLevel()-1)
		if abil.creep_spawn_item then
			_G.playerstats[id].goldspend_to_summon_creeps = _G.playerstats[id].goldspend_to_summon_creeps + abil:GetGoldCost(abil:GetLevel()-1)
		end
		if string.find(keys.abilityname, "spawn_hero_") ~= nil then
			_G.playerstats[id].goldspend_to_summon_heroes = _G.playerstats[id].goldspend_to_summon_heroes + abil:GetGoldCost(abil:GetLevel()-1)
		end

		if _G.frostivus and abil.creep_spawn_item then
			_G.frostivus:OnPlayerSpawnCreep({id = id, item = abil})
		end
	end
end

function SCGameMode:SelectAbil(data)
	if data and data.PlayerID then
		if data.mode == "aura" then
			SCGameMode:SelectAura(data)
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(data.PlayerID), "CloseSelectAbil", {})
		elseif data.mode == "ult" then
			SCGameMode:SelectUltAbil(data)
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(data.PlayerID), "CloseSelectAbil", {})
		elseif data.mode == "diretide" then
			_G.diretide:PayCandy(data)
		end
	end
end

function SCGameMode:SelectAura(data)
	local id = data.PlayerID
	if not id then return end
	if _G.playersinfo[id].ancient and _G.playersinfo[id].ancient:GetLevel() > 1 then
		if _G.playersinfo[id].ancient:FindAbilityByName("ancient_select_aura") then
			_G.playersinfo[id].ancient:RemoveAbility("ancient_select_aura")
			_G.playersinfo[id].ancient:AddAbility(_G.playersinfo[id].raceinfo["auras"][tostring(data.abilid)]):SetLevel(1)
			_G.playersinfo[id].aura = _G.playersinfo[id].raceinfo["auras"][tostring(data.abilid)]
		end
	end
end

function SCGameMode:SelectUltAbil(data)
	local id = data.PlayerID
	if _G.playersinfo[id].ancient and _G.playersinfo[id].ancient:GetLevel() > 2 then
		if _G.playersinfo[id].ancient:FindAbilityByName("ancient_select_ultimate_ability") then
			local ults = {"ancient_ultimate_spell_shield","ancient_ultimate_mana_shield","ancient_ultimate_mana_burn","ancient_ultimate_mana_drain","ancient_ultimate_repair","ancient_ultimate_damage_build","ancient_ultimate_damage_player","ancient_ultimate_damage_enemies","ancient_ultimate_damage_all"}
			local needs = {--melee,range,armor,builds,mage
				{2,2,2,2,1},
				{3,3,3,4,1},
				{6,6,6,2,1},
				{6,6,6,4,1},
				{6,6,6,4,2},
				{8,8,8,4,2},
				{7,7,7,4,2},
				{8,8,8,4,2},
				{9,9,9,6,2}
			}
			if _G.playersinfo[id].item_melee_upgrade >= needs[data.abilid][1] and  _G.playersinfo[id].item_range_upgrade >= needs[data.abilid][2] and  _G.playersinfo[id].item_armor_upgrade >= needs[data.abilid][3] and  _G.playersinfo[id].item_buildings_upgrade >= needs[data.abilid][4] and  _G.playersinfo[id].item_mage_upgrade >= needs[data.abilid][5] then
				_G.playersinfo[id].ancient:RemoveAbility("ancient_select_ultimate_ability")
				_G.playersinfo[id].ancient:AddAbility(ults[data.abilid]):SetLevel(1)
			end
		end
	end
end

LinkLuaModifier( "modifier_custom_turbo_unit", "modifiers/modifier_custom_turbo_unit.lua", LUA_MODIFIER_MOTION_NONE )
function SCGameMode:OnNPCSpawned(keys)
	-- print("NPC Spawned")
	-- DeepPrintTable(keys)
	local npc = EntIndexToHScript(keys.entindex)
    
	if npc.bFirstSpawned == nil then
		npc.bFirstSpawned = true
		-- if _G.turbo then
		-- 	npc:AddNewModifier(npc, nil, "modifier_custom_turbo_unit", {})
		-- end
		if npc:IsRealHero() then
			--npc:RemoveItem(npc:GetItemInSlot(15))
			local id = npc:GetPlayerID()
			local team = npc:GetTeam()

			-- [SCD-FIX] защита от команды вне игрового набора. Актуально для dev-команды
			-- scd_add_bot: движку никто не гарантирует назначить боту одну из четырёх
			-- игровых команд. Ниже идут _G.duos_spawn[team] + 1, colors[team][1] и
			-- Entities:FindByName(nil, "base_1_"..base_pos) - все три падают на nil,
			-- и обработчик npc_spawned умер бы с ошибкой Lua (база не создалась бы всё равно).
			local allowed_teams = {}
			allowed_teams[DOTA_TEAM_GOODGUYS] = true
			allowed_teams[DOTA_TEAM_BADGUYS] = true
			if not _G.duos then
				allowed_teams[DOTA_TEAM_CUSTOM_1] = true
				allowed_teams[DOTA_TEAM_CUSTOM_2] = true
			end
			if allowed_teams[team] ~= true then
				print("[SCD-DIAG] OnNPCSpawned: unexpected team " .. tostring(team) .. " for player "
					.. tostring(id) .. " - base is not created")
				return
			end

			local base_pos = 0
			if _G.duos then
				_G.duos_spawn[team] = _G.duos_spawn[team] + 1
				local duos_spawn = {}
				duos_spawn[DOTA_TEAM_GOODGUYS] = {1,3}
				duos_spawn[DOTA_TEAM_BADGUYS] = {2,4}
				base_pos = duos_spawn[team][_G.duos_spawn[team]]
			else
				local team_to_num = {}
				team_to_num[DOTA_TEAM_GOODGUYS] = 1
				team_to_num[DOTA_TEAM_BADGUYS] = 2
				team_to_num[DOTA_TEAM_CUSTOM_1] = 3
				team_to_num[DOTA_TEAM_CUSTOM_2] = 4
				base_pos = team_to_num[team]
			end

			-- [SCD-FIX] в duos base_pos берётся как duos_spawn[team][номер_спавна]: при
			-- третьем герое на той же команде индекс выходит за {1,3}/{2,4} и base_pos = nil,
			-- а следом падает конкатенация "base_1_"..base_pos.
			if type(base_pos) ~= "number" or base_pos < 1 or base_pos > 4 then
				print("[SCD-DIAG] OnNPCSpawned: cannot resolve base_pos for player " .. tostring(id)
					.. " (team " .. tostring(team) .. ", base_pos=" .. tostring(base_pos)
					.. ") - base is not created")
				return
			end

			local colors = {}
			colors[DOTA_TEAM_GOODGUYS] = {255, 108, 0  }
			colors[DOTA_TEAM_BADGUYS] = {197, 77,  168}
			colors[DOTA_TEAM_CUSTOM_1] = {243, 201, 9  }
			colors[DOTA_TEAM_CUSTOM_2] = {61,  210, 150}
			PlayerResource:SetCustomPlayerColor( id, colors[team][1], colors[team][2], colors[team][3] )
			if PlayerResource:GetSteamAccountID(id) == 130646433 then
				SetTeamCustomHealthbarColor( team, 0,191,255 )
			end
			if PlayerResource:GetSteamAccountID(id) == 963845517 then
				SetTeamCustomHealthbarColor( team, 255,255,255 )
			end
			local point = Entities:FindByName( nil, "base_1_"..base_pos):GetAbsOrigin()
			local spec_point = Entities:FindByName( nil, "spec_building_"..base_pos):GetAbsOrigin()
			_G.playerstats[id] = {}
			_G.playerstats[id].goldspend = 0
			_G.playerstats[id].goldspend_to_summon_creeps = 0
			_G.playerstats[id].goldspend_to_summon_heroes = 0
			_G.playerstats[id].tower_upgrades = 0
			_G.playerstats[id].castle_upgrades = 0
			_G.playerstats[id].spec_upgrades = 0

			_G.playersinfo[id] = {}
			_G.playersinfo[id].alive = true
			_G.playersinfo[id].base_pos = base_pos
			_G.playersinfo[id].aura = ""
			_G.playersinfo[id].ancient = CreateUnitByName("npc_dota_custom_ancient", point, false, npc, npc, team)
			_G.playersinfo[id].ancient:SetControllableByPlayer(id, false)
			_G.playersinfo[id].ancient.gpt = 25
			_G.playersinfo[id].spec = CreateUnitByName("npc_dota_custom_spec", spec_point, false, npc, npc, team)
			_G.playersinfo[id].spec:SetControllableByPlayer(id, false)
			PlayerResource:SetCameraTarget(id, _G.playersinfo[id].ancient)
			_G.playersinfo[id].all_baracks = {}
			_G.playersinfo[id].baracks = {}
			for i=1,3 do
				local barrack_point = Entities:FindByName( nil, "barack_"..i.."_"..base_pos):GetAbsOrigin()
				local barrack = CreateUnitByName("npc_dota_custom_barrack", barrack_point, false, npc, npc, team)
				barrack:SetControllableByPlayer(id, false)
				local angles = {-90,0,180}
				barrack:SetAngles(0,angles[i]+90*(base_pos-1),0)
				if _G.duos then
					if base_pos == 3 then
						barrack:SetAngles(0,angles[i],0)
					end
					if base_pos == 2 then
						barrack:SetAngles(0,angles[i]+180,0)
					end
					if base_pos == 4 then
						barrack:SetAngles(0,angles[i]+180,0)
					end
				end
				barrack.gpt = 5
				if i == 1 then
					barrack.mid_barrack = true
					barrack.mid_barrack_gold_bounty_mult = 1
					barrack.mid_barrack_exp_bounty_mult = 1
				end
				_G.playersinfo[id].all_baracks[i] = barrack
				_G.playersinfo[id].baracks[i] = barrack
			end
			_G.playersinfo[id].towers = {}
			for i=1,4 do
				local tower_point = Entities:FindByName( nil, "tower_"..i.."_"..base_pos):GetAbsOrigin()
				local tower = CreateUnitByName("npc_dota_custom_tower", tower_point, false, npc, npc, team)
				tower:SetControllableByPlayer(id, false)
				tower.gpt = 5
				_G.playersinfo[id].towers[i] = tower
				--local angles = {90,180,0}
				--barrack:SetAngles(0,angles[i]+90*id,0)
			end
			-- PlayerResource:SetCameraTarget(id, unit)
			-- Timers:CreateTimer(0.1, function()
			npc:ForceKill(false)
			-- 	PlayerResource:SetCameraTarget(id, nil)
			-- end)
			--UTIL_Remove(npc)
			-- PlayerResource:SetOverrideSelectionEntity(id, nil)
			if _G.turbo then
				npc:SetGold(4000, false)
			else
				npc:SetGold(2000, false)
			end

			local data = {}
			data.PlayerID = id
			data.hero = npc
			Store:OnPlayerLoaded(data)
		end
	end
end

function SCGameMode:OnGameRulesStateChange(keys)
	print("GameRules State Changed")
	DeepPrintTable(keys)

	local newState = GameRules:State_Get()
	if newState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		self:OnAllPlayersLoaded()
		-- local link = "http://pay.survival-chaos.com/api/tiers?"
		-- for i=1,PlayerResource:GetPlayerCount() do
		-- 	link = link .. "player=" .. tostring(PlayerResource:GetSteamAccountID(i-1)) .. "&"
		-- end
		-- link = link .. "key=" .. GetDedicatedServerKeyV3("2")
		-- local patreonreq = CreateHTTPRequestScriptVM( "GET", link)
        -- patreonreq:Send(function(result)
        --    -- print(result.Body)
        --    for token in string.gmatch(result.Body, "([^|]*)|") do
        --        --print(token)
        --        local id = ""
        --        local lvl = ""
        --        id, lvl = token:match("([^,]+),([^,]+)")
        --        -- print(id)
        --        -- print(lvl)
        --        _G.patreons[id] = tonumber(lvl)
		-- 	end
		-- 	CustomNetTables:SetTableValue("Patrons","1",_G.patreons)
		-- 	--Store:PlayersBoostLoaded()
		-- 	--Challenges:LoadPlayers()
		-- 	-- DeepPrintTable(_G.patreons)
		-- end)

		-- for id, _ in pairs(_G.playersinfo) do
		-- 	_G.patreons[id] = 1
		-- end
		-- CustomNetTables:SetTableValue("Patrons","1",_G.patreons)

		-- [SCD-OFFLINE] store.php недоступен. Колбэк этого запроса инициализирует магазин,
		-- поэтому offline-ветка обязана сразу вызвать фоллбек: иначе Store.Loaded останется
		-- false, Store:OnPlayerLoaded открутит 90 ретраев по 1 с, а магазин не откроется.
		if _G.SCD_OFFLINE then
			SCD_OfflineNote("store.php skipped: local store fallback")
			Store:PlayersStoreFallback("offline")
		else
			local storereq = CreateHTTPRequestScriptVM( "GET", "https://dotascd.ru/store.php")
			storereq:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKeyV3("1"))
			local plc = PlayerResource:GetPlayerCount()
			storereq:SetHTTPRequestGetOrPostParameter("count", tostring(plc))
			for i=1, plc do
				storereq:SetHTTPRequestGetOrPostParameter("id"..i, tostring(PlayerResource:GetSteamAccountID(i-1)))
			end
			storereq:Send(function(result)
				-- [SCD-FIX] ответ сети не роняет лобди
				local ok, err = pcall(function()
					if result and type(result.Body) == "string" and result.Body ~= "" then
						Store:PlayersStoreLoaded(result.Body)
					else
						print("[SCD-DIAG] store.php empty body or network fail, StatusCode=" .. tostring(result and result.StatusCode))
						Store:PlayersStoreFallback("network")
					end
				end)
				if not ok then
					print("[SCD-DIAG] store response handler failed: " .. tostring(err))
					Store:PlayersStoreFallback("handler error")
				end
			end)
		end
		-- BattlePasses:LoadPlayers()
		-- Chests:LoadPlayers()
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
		
		if _G.polygon then
			local test_hero = CreateUnitByName("npc_dota_test_creep_hero", Vector(0,-800,0), true, nil, nil, DOTA_TEAM_BADGUYS)
			test_hero:SetControllableByPlayer(0, true)
			test_hero:Stop()
			local test_hero2 = CreateUnitByName("npc_dota_test_creep_hero", Vector(0,-800,0), true, nil, nil, DOTA_TEAM_CUSTOM_1)
			test_hero2:SetControllableByPlayer(0, true)
			test_hero2:Stop()
			local test_creep = CreateUnitByName("npc_dota_test_creep", Vector(0,-800,0), true, nil, nil, DOTA_TEAM_BADGUYS)
			test_creep:SetControllableByPlayer(0, true)
			test_creep:Stop()
			local test_creep2 = CreateUnitByName("npc_dota_test_creep", Vector(0,-800,0), true, nil, nil, DOTA_TEAM_CUSTOM_2)
			test_creep2:SetControllableByPlayer(0, true)
			test_creep2:Stop()
		end

		-- local obj = {pid=-1, cvar="dota_player_units_auto_attack_mode", value="2"}
		-- FireGameEvent("control_override_cvar", obj)
		-- obj = {pid=-1, cvar="dota_summoned_units_auto_attack_mode_2", value="-1"}
		-- FireGameEvent("control_override_cvar", obj)

		SCGameMode:UpdateRatingNetTable()
		-- [SCD-OFFLINE] блок ниже - целиком серверная сторона рейтинга: getrating/getratingtop
		-- на data.php плюс net-таблица "Rating". В автономной игре он не выполняется:
		--   * GetDedicatedServerKeyV3 не вызывается (ключ уходил только параметром "v");
		--   * GetTableValue("Rating","stats") вернул бы nil (таблица больше не заполняется),
		--     и table["enable"] уронило бы обработчик смены состояния игры;
		--   * фоллбек не нужен: колбэки лишь складывали данные рейтинга в _G.ratingstable.
		if _G.SCD_OFFLINE then
			SCD_OfflineNote("getrating/getratingtop skipped, Rating net table is not filled")
		elseif _G.SCD_RATING_ENABLED and (not GameRules:IsCheatMode() or IsInToolsMode()) then
			if PlayerResource:GetPlayerCount() == 4 then
				local table = CustomNetTables:GetTableValue("Rating","stats")
				table["enable"] = _G.rating
				CustomNetTables:SetTableValue("Rating","stats",table)
			end
			local req = CreateHTTPRequestScriptVM( "GET", "https://dotascd.ru/data.php")
			req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKeyV3("3"))
			req:SetHTTPRequestGetOrPostParameter("mode", "getrating")
			for i=1,PlayerResource:GetPlayerCount() do
				req:SetHTTPRequestGetOrPostParameter("id" .. i, tostring(PlayerResource:GetSteamAccountID(i-1)))
			end
			req:Send(function(result)
				-- print(result.Body)
				if result and type(result.Body) == "string" and result.Body ~= "" then
					local ok, loctable = pcall(json.decode, result.Body)
					if ok and loctable ~= nil then
						_G.ratingstable["ratings"] = loctable
						SCGameMode:UpdateRatingNetTable()
					else
						print("[SCD-DIAG] getrating: bad json")
					end
				end
			end)
			
			local req = CreateHTTPRequestScriptVM( "GET", "https://dotascd.ru/data.php")
			req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKeyV3("3"))
			req:SetHTTPRequestGetOrPostParameter("mode", "getratingtop")
			req:Send(function(result)
				-- print(result.Body)
				if result and type(result.Body) == "string" and result.Body ~= "" then
					local ok, loctable = pcall(json.decode, result.Body)
					if ok and loctable ~= nil then
						CustomNetTables:SetTableValue("Rating","top",loctable)
					else
						print("[SCD-DIAG] getratingtop: bad json")
					end
				end
			end)
		end
	elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		GameRules:SetTimeOfDay(0.25)
		CustomGameEventManager:Send_ServerToAllClients( "HideSelectRace", {})
		Timers:CreateTimer(10, function() return SCGameMode:OnTimerThink() end)
		Timers:CreateTimer(300, function() return SCGameMode:OnTimerThink_AllChat() end)
		for k, _ in pairs(_G.playersinfo) do
			if _G.playersinfo[k].race == nil then
				local data = {}
				data.PlayerID = k
				data.race = RandomInt(1, _G.free_race_count)
				SCGameMode:SelectRace(data)
			end
			_G.playersinfo[k].gpt = 60
		end

		Timers:CreateTimer(90, function()
			for k, _ in pairs(_G.playersinfo) do
				local spec = _G.playersinfo[k].spec
				if not spec.specpass then
					local abillist = {}
					for i=0, spec:GetAbilityCount()-1 do
						local abil = spec:GetAbilityByIndex(i)
						if abil and not abil:IsPassive() then
							table.insert(abillist,abil)
						end
					end
					if #abillist > 0 then
						local cast_abil = abillist[RandomInt(1, #abillist)]
						if math.fmod(cast_abil:GetBehavior(), 8) == 0 then
							spec:CastAbilityOnTarget(_G.playersinfo[k].baracks[RandomInt(1,#_G.playersinfo[k].baracks)], cast_abil, k)
						else
							cast_abil:CastAbility()
						end
					end
				end
			end
		end)

		--Timers:CreateTimer(1800, function()
		--	CustomGameEventManager:Send_ServerToAllClients( "AllowSurrend", {})
		--end)
		for _, v in pairs(_G.onstartgame) do
			v:StartGame()
		end
	end
end

function SCGameMode:OnAllPlayersLoaded()
	-- [SCD-FIX] защита: падение создания kvs-таблицы больше не роняет фазу подключения
	local ok, err = pcall(function()
		PlayerTables:CreateTable("kvs", 
			{
				items = self.ItemKVs,
				units = self.UnitsKVs,
				races = _G.racetable,
				abilities = self.AbilityKVs
			}
		, true)
	end)
	if not ok then
		print("[SCD-DIAG] OnAllPlayersLoaded: CreateTable kvs FAILED: " .. tostring(err))
	end
end

function SCGameMode:OnTimerThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		for id, _ in pairs(_G.playersinfo) do
			local addgold = _G.playersinfo[id].gpt
			if _G.turbo then
				addgold = addgold * 2
			end
			PlayerResource:ModifyGold(id, addgold, false, 0)
		end
	end
	GCCollect()

	return 10
end

function SCGameMode:OnTimerThink_AllChat()
	local gameEvent10 = {}
	gameEvent10["teamnumber"] = -1
	gameEvent10["message"] = "#combat_all"
	FireGameEvent( "dota_combat_event_message", gameEvent10 )
	for id, data in pairs(_G.playerstats) do
		local gameEventn = {}
		gameEventn["player_id"] = id
		gameEventn["teamnumber"] = -1
		gameEventn["locstring_value"] = tostring(data.goldspend + PlayerResource:GetGold(id)) .. " | " .. tostring(data.goldspend + PlayerResource:GetGold(id) - data.goldspend_to_summon_creeps - data.goldspend_to_summon_heroes) .. " | " .. tostring(data.tower_upgrades + data.castle_upgrades + data.spec_upgrades) .. " | " .. tostring(PlayerResource:GetLastHits(id) .. " | " .. tostring(data.goldspend_to_summon_creeps + data.goldspend_to_summon_heroes))
		gameEventn["message"] = "#combat_all_value"
		FireGameEvent( "dota_combat_event_message", gameEventn )
	end
	GCCollect()

	return 300
end

local players_connection_state = {}
function SCGameMode:OnThink()
	-- if GameRules:State_Get() < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		CustomGameEventManager:Send_ServerToAllClients( "TimeUpdate", {time = math.abs(math.floor(GameRules:GetDOTATime(false, true))), pause = GameRules:IsGamePaused(), time_of_day = GameRules:GetTimeOfDay()})
	-- end
	
	PlayerTables:OnThink()

	-- [SCD-OFFLINE] замена MMR в топ-баре: раса / % HP главного здания / бараки / Поражение
	SCGameMode:UpdateTopBarNetTable()

	-- [SCD-FIX] публикация активных модификаторов стоимости апгрейдов (см. UpdateCostModsNetTable)
	SCGameMode:UpdateCostModsNetTable()

	-- [SCD-FIX] хост лобби и настройка косметики крипов: публикует SCD_Settings и слушает
	-- событие SCDSetCosmetics от галочки в пик-экране (scripts/vscripts/scd_settings.lua)
	if _G.SCD_Settings then _G.SCD_Settings:Think() end

	for i=0,PlayerResource:GetPlayerCount()-1 do
		local state = PlayerResource:GetConnectionState(tonumber(i))
		if state == 4 and players_connection_state[i] ~= 4 then
			--Challenges:OnPlayerAbandoned(i)
		end
		players_connection_state[i] = state
	end

	return 0.2
end

-- [SCD-OFFLINE] ============ net-таблица SCD_TopBar (контракт: _dsh/CONTRACT.md, раздел 1)
-- Сервер пишет, клиент читает. Ключ - tostring(playerID) для id 0..7, значения целые:
--   race           id расы 1..19, 0 - раса еще не выбрана;
--   hp             % HP главного здания 0..100, 0 - если оно снесено (ancient обнуляется
--                  в SCGameMode:OnEntityKilled);
--   barracks       сколько бараков живо;
--   barracks_total сколько бараков всего (изначальные 3 из all_baracks);
--   defeated       1 - игрок выбыл (_G:Defeat выставил alive = false), иначе 0;
--   networth       общая ценность игрока: потраченное золото (_G.playerstats[id].goldspend)
--                  плюс текущий остаток (PlayerResource:GetGold), округленное вниз до шага
--                  scd_topbar_networth_step. Формула та же, что в Ends_Stats.gold на экране
--                  окончания матча, поэтому цифры в топ-баре и в финальной статистике
--                  у одного игрока сходятся.
-- OnThink тикает 5 раз в секунду, поэтому пишем ТОЛЬКО при реальном изменении строки:
-- прошлое состояние кешируется по каждому id.
local scd_topbar_cache = {}

-- [SCD-OFFLINE] шаг округления networth. Золото капает почти непрерывно (gpt-тики каждые
-- 10 с плюс награды за крипов и героев), а функция вызывается 5 раз в секунду: без
-- округления net-таблица обновлялась бы каждый тик на каждого игрока и дергала бы
-- перерисовку UI. В таблицу пишется ровно то же округленное число, которое сравнивается
-- с кэшем, иначе кэш и таблица разойдутся и публикация станет бесконечной.
-- Шаг 100 выбран как компромисс: при пассивном доходе (gpt = 60, то есть 6 золота
-- в секунду) строка в топ-баре меняется примерно раз в 17 с - заметно глазу и не выглядит
-- залипшей, а в бою публикация идет только когда ценность реально выросла на сотню.
-- Шаг 50 дал бы вдвое больше публикаций при неразличимой для топ-бара точности, шаг 250 -
-- обновление раз в ~40 с, что уже похоже на зависшее значение.
-- Значение НЕ монотонно: при возврате золота (utils.lua:ReturnGold вычитает из goldspend)
-- оно уменьшается, и топ-бар это честно показывает. Округление вниз корректно и в этом
-- случае: на мелких колебаниях у границы шага оно дает одно и то же число, а реальный
-- рефанд меняет его на шаг - публикация происходит только когда изменение заметно.
-- Трата золота сумму сохраняет (GetGold падает, goldspend растет на ту же величину),
-- поэтому на покупках net worth не дергается.
local scd_topbar_networth_step = 100

function SCGameMode:UpdateTopBarNetTable()
	for id = 0, 7 do
		-- публикуем строки только для настоящих игроков: пустой слот лобби дал бы
		-- фантомную строку "0% HP (0/0)" в топ-баре
		if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetTeam(id) ~= DOTA_TEAM_NOTEAM then
			-- _G.playersinfo[id] создается не сразу (SCGameMode:OnNPCSpawned) и не для всех id
			local info = _G.playersinfo[id]
			local race = 0
			local hp = 0
			local barracks = 0
			local barracks_total = 0
			local defeated = 0
			local networth = 0

			if info then
				race = math.floor(tonumber(info.race) or 0)

				local ancient = info.ancient
				if ancient and not ancient:IsNull() then
					local maxhp = ancient:GetMaxHealth()
					if maxhp and maxhp > 0 then
						hp = math.floor(ancient:GetHealth() / maxhp * 100 + 0.5)
						if hp < 0 then
							hp = 0
						elseif hp > 100 then
							hp = 100
						end
					end
				end

				if info.all_baracks then
					for _ in pairs(info.all_baracks) do
						barracks_total = barracks_total + 1
					end
				end
				if info.baracks then
					for _, barrack in pairs(info.baracks) do
						if barrack and not barrack:IsNull() and barrack:IsAlive() then
							barracks = barracks + 1
						end
					end
				end

				if info.alive == false then
					defeated = 1
				end
			end

			-- [SCD-OFFLINE] net worth = потраченное золото + текущий остаток. Это проектная
			-- формула "общей ценности игрока": ровно так считают Ends_Stats.gold (колонка gold
			-- на экране окончания матча) и all-chat статистика, и в нее входят стартовые
			-- 2000/4000 золота от SetGold в OnNPCSpawned. Движковый GetTotalEarnedGold стартовый
			-- капитал не учитывает и дал бы цифру меньше - то есть два разных числа для одного
			-- игрока на двух экранах, поэтому источник выбран проектный.
			-- _G.playerstats[id] создается рядом с _G.playersinfo (OnNPCSpawned) и не сразу,
			-- поэтому guard обязателен. Округлено до шага: и в кэше, и в таблице одно и то же.
			local stats = nil
			if _G.playerstats ~= nil then
				stats = _G.playerstats[id]
			end
			if stats ~= nil and type(stats.goldspend) == "number" then
				local current = PlayerResource:GetGold(id)
				local total = stats.goldspend
				if type(current) == "number" then
					total = total + current
				end
				networth = math.floor(math.floor(total + 0.5) / scd_topbar_networth_step) * scd_topbar_networth_step
			end

			local cache = scd_topbar_cache[id]
			if cache == nil
				or cache.race ~= race
				or cache.hp ~= hp
				or cache.barracks ~= barracks
				or cache.barracks_total ~= barracks_total
				or cache.defeated ~= defeated
				or cache.networth ~= networth then
				local row = {
					race = race,
					hp = hp,
					barracks = barracks,
					barracks_total = barracks_total,
					defeated = defeated,
					networth = networth
				}
				scd_topbar_cache[id] = row
				CustomNetTables:SetTableValue("SCD_TopBar", tostring(id), row)
			end
		end
	end
end

-- [SCD-FIX] Эффективная цена апгрейдов: какие модификаторы стоимости активны на замке.
--
-- ЗАЧЕМ. Сервер списывает за апгрейд НЕ всегда gold_cost.default: в
-- items/items_upgrades.lua:13-16 он перебирает ключи блока gold_cost и, если у замка
-- есть соответствующий модификатор, подменяет список на мод-вариант:
--     for mod, mod_gold_cost in pairs(gradekv.gold_cost) do
--         if mod ~= "default" and caster:HasModifier(mod) then gold_cost = mod_gold_cost end
--     end
-- Панорама показывает цену из races.kv, но проверить модификаторы из клиентского JS нечем
-- (Entities.HasModifier в JS API нет). Поэтому показанная цена расходилась бы со списанной
-- у трёх спеков. Решение: сервер публикует имена активных модификаторов, а клиент выбирает
-- по ним вариант из того же gold_cost.
--
-- Полный список ключей собран по всему races.kv (95 блоков gold_cost, 4 уникальных ключа):
-- default + ровно три мод-варианта. Проверка сделана скриптом, а не по памяти: у пауков имя
-- modifiers_spiders_spec_air_swap_PASS_grade_gold (с pass), а не ..._air_swap_grade_gold.
local SCD_COST_MODS = {
	"modifiers_cultists_spec_arme_swap_pass_grade_gold",
	"modifiers_orcs_spec_siege_swap_grade_gold",
	"modifiers_spiders_spec_air_swap_pass_grade_gold",
}
_G.SCD_COST_MODS = SCD_COST_MODS

local scd_costmods_cache = {}

function SCGameMode:UpdateCostModsNetTable()
	for id = 0, 7 do
		if PlayerResource:IsValidPlayerID(id) and PlayerResource:GetTeam(id) ~= DOTA_TEAM_NOTEAM then
			local info = _G.playersinfo[id]
			-- Модификаторы проверяются на замке: апгрейды-предметы лежат именно там
			-- (addon_game_mode.lua:1622-1626 AddItemByName на ancient), а в GetGoldCost
			-- caster = self:GetCaster() у предмета - то есть тот же ancient.
			local ancient = info and info.ancient
			local names = {}
			if ancient and not ancient:IsNull() and ancient.HasModifier then
				for _, mod in ipairs(SCD_COST_MODS) do
					-- pcall: модификатор может не существовать в текущей расе, а HasModifier
					-- на чужом юните или в момент его удаления способна бросить ошибку.
					local ok, has = pcall(function()
						return ancient:HasModifier(mod)
					end)
					if ok and has then
						names[#names + 1] = mod
					end
				end
			end
			-- Строка через запятую, а не массив: пустая таблица в net-таблице сериализуется
			-- неоднозначно, а строка "" - всегда валидное значение. Клиент делает split(",").
			local joined = table.concat(names, ",")
			if scd_costmods_cache[id] ~= joined then
				scd_costmods_cache[id] = joined
				CustomNetTables:SetTableValue("SCD_CostMods", tostring(id), { mods = joined })
			end
		end
	end
end

LinkLuaModifier( "modifier_extra_health_bonus", "modifiers/modifier_extra_health_bonus", LUA_MODIFIER_MOTION_NONE )
--Races
--Treants 1
--Undead 2
--Humans 3
--Orcs 4
--Dwarfs 5
--Elves 6
--Spiders 7
--Nagas 8
--Demons 9
--Elementals 10
--Diretide 11
--Frostivus 12
--Dragons 13
--Beastmen 14
--Primordials 15
--Invaders 16
--Сultists 17
--Pirates 18
--Nights 19
function SCGameMode:SelectRace(data)
	local races_names_addon = {}
	races_names_addon[1] = "treants"
	races_names_addon[2] = "undead"
	races_names_addon[3] = "humans"
	races_names_addon[4] = "orcs"
	races_names_addon[5] = "dwarfs"
	races_names_addon[6] = "elves"
	races_names_addon[7] = "spiders"
	races_names_addon[8] = "nagas"
	races_names_addon[9] = "demons"
	races_names_addon[10] = "elementals"
	races_names_addon[11] = "diretide"
	races_names_addon[12] = "frostivus"
	races_names_addon[13] = "dragons"
	races_names_addon[14] = "beastmen"
	races_names_addon[15] = "primordials"
	races_names_addon[16] = "invaders"
	races_names_addon[17] = "cultists"
	races_names_addon[18] = "pirates"
	races_names_addon[19] = "nights"
	local id = data.PlayerID
	if not id then return end
	if data.random_race then
		data.race = data.random_race
		local gameEvent = {}
        gameEvent["player_id"] = id
        gameEvent["teamnumber"] = -1
        --gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_" .. message
        gameEvent["message"] = "#Player_Chose_Random_Race"
        FireGameEvent( "dota_combat_event_message", gameEvent )
	end
	if not data.race then return end
	if not _G.playersinfo[id] then return end
	if data.race < 1 or data.race > _G.free_race_count and not IsInToolsMode() then
		if data.race > _G.race_count then
			return
		end
	end
	local precacheList = LoadKeyValues('scripts/npc/npc_units_custom.txt')
	for unit, info in pairs(precacheList) do
		print(unit)
		print(data.race)
		print(races_names_addon[data.race])
		print(string.find(unit, races_names_addon[data.race]))
		if string.find(unit, races_names_addon[data.race]) ~= nil then
			PrecacheAssync(unit)
		end
	end

	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(id), "HideSelectRace", {})
	if _G.playersinfo[id].race == nil or IsInToolsMode() then
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(id) , "EnableTopBar", {})
		--if data.race == 10 and not _G.elementals then
		--	_G.elementals = require( 'elementals' )
		--end
		if data.race == 11 and not _G.diretide then
			_G.diretide = require( 'diretide' )
		end
		if data.race == 12 and not _G.frostivus then
			_G.frostivus = require( 'frostivus' )
		end
		local racestable = FormRaceTable(LoadKeyValues("scripts/kv/races.kv"))
		-- DeepPrintTable(racestable)
		-- DeepPrintTable(racestable.races_names)
		-- print("SelectRace "..racestable.races_names[tostring(data.race)].." for "..id)
		PlayerResource:SetCameraTarget(id, nil)
		_G.playersinfo[id].race = data.race
		_G.playersinfo[id].unitsinfo = racestable[racestable.races_names[tostring(data.race)]].units
		_G.playersinfo[id].raceinfo = racestable[racestable.races_names[tostring(data.race)]].race_data
		_G.playersinfo[id].ancient:AddItemByName("item_melee_upgrade")
		_G.playersinfo[id].ancient:AddItemByName("item_range_upgrade")
		_G.playersinfo[id].ancient:AddItemByName("item_mage_upgrade")
		_G.playersinfo[id].ancient:AddItemByName("item_armor_upgrade")
		_G.playersinfo[id].ancient:AddItemByName("item_buildings_upgrade")
		local rb = _G.playersinfo[id].ancient:AddAbility(racestable.races_names[tostring(data.race)].."_race_bonus")
		rb:SetLevel(1)
		_G.playersinfo[id].ancient:SwapAbilities(racestable.races_names[tostring(data.race)].."_race_bonus", _G.playersinfo[id].ancient:GetAbilityByIndex(1):GetName(), true, true)
		_G.playersinfo[id].ancient:AddAbility("ancient_select_aura"):SetLevel(1)
		_G.playersinfo[id].ancient:SwapAbilities("ancient_select_aura", _G.playersinfo[id].ancient:GetAbilityByIndex(2):GetName(), true, true)
		_G.playersinfo[id].ancient:AddAbility(racestable.races_names[tostring(data.race)].."_ancient_ability1"):SetLevel(1)
		_G.playersinfo[id].ancient.abil2 = _G.playersinfo[id].ancient:AddAbility(racestable.races_names[tostring(data.race)].."_ancient_ability2")
		_G.playersinfo[id].ancient.abil2:SetLevel(1)
		_G.playersinfo[id].ancient.abil2:SetActivated(false)
		_G.playersinfo[id].ancient.ult_abil = _G.playersinfo[id].ancient:AddAbility("ancient_research_ultimate_ability")
		_G.playersinfo[id].ancient.ult_abil:SetLevel(1)
		_G.playersinfo[id].ancient.ult_abil:SetActivated(false)
		_G.playersinfo[id].ancient:SwapAbilities(racestable.races_names[tostring(data.race)].."_ancient_ability1", _G.playersinfo[id].ancient:GetAbilityByIndex(3):GetName(), true, true)
		_G.playersinfo[id].ancient:SwapAbilities(racestable.races_names[tostring(data.race)].."_ancient_ability2", _G.playersinfo[id].ancient:GetAbilityByIndex(4):GetName(), true, true)
		_G.playersinfo[id].ancient:SwapAbilities("ancient_research_ultimate_ability", _G.playersinfo[id].ancient:GetAbilityByIndex(5):GetName(), true, true)

		if _G.duos then
			_G.playersinfo[id].ancient:FindAbilityByName(racestable.races_names[tostring(data.race)].."_ancient_ability1"):SetLevel(2)
			_G.playersinfo[id].ancient:FindAbilityByName(racestable.races_names[tostring(data.race)].."_ancient_ability2"):SetLevel(2)
		end

		--_G.playersinfo[id].ancient:AddAbility("ancient_select_gift"):SetLevel(1)--for event

		_G.playersinfo[id].item_melee_upgrade = 0
		_G.playersinfo[id].item_range_upgrade = 0
		_G.playersinfo[id].item_mage_upgrade = 0
		_G.playersinfo[id].item_armor_upgrade = 0
		_G.playersinfo[id].item_buildings_upgrade = 0
		for k, barack in pairs(_G.playersinfo[id].baracks) do
			if data.race == 12 then
				barack:AddAbility("frostivus_barrack_shield"):SetLevel(1)
				barack:SwapAbilities("frostivus_barrack_shield", barack:GetAbilityByIndex(0):GetName(), true, true)
			else
				barack:AddAbility("repair_building"):SetLevel(1)
				barack:SwapAbilities("repair_building", barack:GetAbilityByIndex(0):GetName(), true, true)
			end
			barack:SwapAbilities("upgrade_barrack", barack:GetAbilityByIndex(1):GetName(), true, true)
			barack:AddAbility("invis_building"):SetLevel(1)
			
			barack.units = {}
			barack.units["npc_dota_"..racestable.races_names[tostring(data.race)].."_melee"] = 2
			barack.units["npc_dota_"..racestable.races_names[tostring(data.race)].."_range"] = 1
			barack.units["npc_dota_"..racestable.races_names[tostring(data.race)].."_mage"] = 1
			
			local barr_items = {
				"item_"..racestable.races_names[tostring(data.race)].."_melee",
				"item_"..racestable.races_names[tostring(data.race)].."_range",
				"item_"..racestable.races_names[tostring(data.race)].."_mage"
			}
			local barr_abils = {
				"spawn_hero_"..racestable.races_names[tostring(data.race)].."_tank",
				"spawn_hero_"..racestable.races_names[tostring(data.race)].."_mage",
				"spawn_hero_"..racestable.races_names[tostring(data.race)].."_asassin",
				"spawn_hero_"..racestable.races_names[tostring(data.race)].."_pusher"
			}
			local abils_counter = 1
			Timers:CreateTimer(0.2, function()
				if abils_counter <= 3 then
					barack:AddItemByName(barr_items[abils_counter])
					local ab = barack:AddAbility(barr_abils[abils_counter])
					ab:SetLevel(1)
					abils_counter = abils_counter + 1
					barack:SwapAbilities(ab:GetName(), barack:GetAbilityByIndex(abils_counter):GetName(), true, true)
					return 0.2
				else
					local ab = barack:AddAbility(barr_abils[abils_counter])
					ab:SetLevel(1)
					barack:SwapAbilities(ab:GetName(), barack:GetAbilityByIndex(abils_counter+1):GetName(), true, true)
				end
			end)

			barack:SetModel(_G.playersinfo[id].raceinfo.default_building_models.racks_model)
			barack:SetOriginalModel(_G.playersinfo[id].raceinfo.default_building_models.racks_model)
			barack:SetModelScale( _G.playersinfo[id].raceinfo.default_building_models.racks_model_scale )
		end

		for k, tower in pairs(_G.playersinfo[id].towers) do
			for num, abil_name in pairs(_G.playersinfo[id].raceinfo.tower_abilities) do
				tower:AddAbility(abil_name):SetLevel(1)
			end
			for num, abil_name in pairs(_G.playersinfo[id].raceinfo.tower_abilities) do
				if tonumber(num) < 9 then
					-- print("swap")
					-- print(abil_name)
					-- print(tower:GetAbilityByIndex(tonumber(num)-1):GetName())
					tower:SwapAbilities(abil_name, tower:GetAbilityByIndex(tonumber(num)-1):GetName(), true, true)
					Timers:CreateTimer(0, function()
						local abil = tower:FindAbilityByName(abil_name)
						abil:SetHidden(false)
					end)
				end
			end

			tower:SetModel(_G.playersinfo[id].raceinfo.default_building_models.tower_model)
			tower:SetOriginalModel(_G.playersinfo[id].raceinfo.default_building_models.tower_model)
			tower:SetModelScale( _G.playersinfo[id].raceinfo.default_building_models.tower_model_scale )
		end
		
		local specs_count = 1
		local all_specs = {}
		local spec_index = 1
		while _G.playersinfo[id].raceinfo.specs[tostring(spec_index)] do
			table.insert( all_specs, _G.playersinfo[id].raceinfo.specs[tostring(spec_index)] )
			spec_index = spec_index + 1
		end
		Timers:CreateTimer(0.1, function()
			if specs_count <= #all_specs then
				_G.playersinfo[id].spec:AddAbility(all_specs[specs_count]):SetLevel(1)
				specs_count = specs_count + 1
				return 0.1
			else
				--_G.playersinfo[id].spec:AddAbility("forall_spec_anti_hero_towers"):SetLevel(1)
				-- _G.playersinfo[id].spec:AddAbility("forall_spec_spell_shield"):SetLevel(1)
				_G.playersinfo[id].spec:AddAbility("forall_spec_hero_items"):SetLevel(1)
	
				--table.insert( all_specs, "forall_spec_anti_hero_towers" )
				table.insert( all_specs, "forall_spec_hero_items" )
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "building_selection_new", {
					abilities = all_specs,
					endTime = 90
				} )
			end
		end)


		_G.playersinfo[id].ancient:SetModel(_G.playersinfo[id].raceinfo.default_building_models.castle_model)
		_G.playersinfo[id].ancient:SetOriginalModel(_G.playersinfo[id].raceinfo.default_building_models.castle_model)
		_G.playersinfo[id].ancient:SetModelScale( _G.playersinfo[id].raceinfo.default_building_models.castle_model_scale )
		_G.playersinfo[id].spec:SetModel(_G.playersinfo[id].raceinfo.default_building_models.spec_model)
		_G.playersinfo[id].spec:SetOriginalModel(_G.playersinfo[id].raceinfo.default_building_models.spec_model)
		_G.playersinfo[id].spec:SetModelScale( _G.playersinfo[id].raceinfo.default_building_models.spec_model_scale )

		_G.playersinfo[id].ancient:RemoveAbility("twin_gate_portal_warp")

		if data.race == 1 then
			_G.playersinfo[id].ancient:AddAbility("attack_speed_pass"):SetLevel(20)
			for k, barack in pairs(_G.playersinfo[id].baracks) do
				barack:AddAbility("attack_speed_pass"):SetLevel(20)
			end
			for k, tower in pairs(_G.playersinfo[id].towers) do
				tower:AddAbility("attack_speed_pass"):SetLevel(20)
			end
		elseif data.race == 5 then
			for k, barack in pairs(_G.playersinfo[id].baracks) do
				--barack:AddNewModifier(_G.playersinfo[id].ancient, rb, "modifier_extra_health_bonus", {}):SetStackCount(8)
				--barack:CalculateGenericBonuses()

				local health_prc = barack:GetHealthPercent()
				local newhealth = barack:GetHealth() + barack:GetHealth() * 8 / 100
				barack:SetBaseMaxHealth(barack:GetBaseMaxHealth() + barack:GetHealth() * 8 / 100)
				barack:CalculateGenericBonuses()
				-- building:AddNewModifier(nil, nil, "fix_mod", {duration = 0.1})
				-- local newhealth = building:GetMaxHealth() * (health_prc/100)
				if newhealth <= 0 then
					newhealth = 1
				end
				barack:SetHealth(newhealth)
			end
		elseif data.race == 8 then
			
			_G.playersinfo[id].ancient:SetPhysicalArmorBaseValue(_G.playersinfo[id].ancient:GetPhysicalArmorBaseValue() + 2)
			for k, barack in pairs(_G.playersinfo[id].baracks) do
				barack:SetPhysicalArmorBaseValue(barack:GetPhysicalArmorBaseValue() + 2)
				barack:AddNewModifier(_G.playersinfo[id].ancient, rb, "modifier_extra_health_bonus", {}):SetStackCount(-2)
				barack:CalculateGenericBonuses()
			end
			for k, tower in pairs(_G.playersinfo[id].towers) do
				tower:SetPhysicalArmorBaseValue(tower:GetPhysicalArmorBaseValue() + 2)
			end
		elseif data.race == 9 then
			_G.playersinfo[id].ancient:SetBaseHealthRegen(1.3)
			for k, barack in pairs(_G.playersinfo[id].baracks) do
				barack:SetBaseHealthRegen(0.3)
			end
			for k, tower in pairs(_G.playersinfo[id].towers) do
				tower:SetBaseHealthRegen(1.3)
			end
		elseif data.race == 15 then
			_G.playersinfo[id].ancient:AddAbility("attack_speed_pass"):SetLevel(10)
			for k, barack in pairs(_G.playersinfo[id].baracks) do
				barack:AddAbility("attack_speed_pass"):SetLevel(10)
			end
			for k, tower in pairs(_G.playersinfo[id].towers) do
				tower:AddAbility("attack_speed_pass"):SetLevel(10)
			end
		end

		Store:OnRaceSelected(id)
		
		CustomNetTables:SetTableValue("Player_Races", tostring(id), {race = data.race})

	end
end

function SCGameMode:OnEntityKilled( keys )
	-- print( '[BAREBONES] OnEntityKilled Called' )
	-- DeepPrintTable( keys )

	-- The Unit that was Killed
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	-- local plc = PlayerResource:GetPlayerCount()
	local id = killedUnit:GetPlayerOwnerID()

	if killedUnit.gpt then
		_G.playersinfo[id].gpt = _G.playersinfo[id].gpt - killedUnit.gpt
	end
    
	-- The Killing entity
	local killerEntity = nil

	if keys.entindex_attacker ~= nil then
		killerEntity = EntIndexToHScript( keys.entindex_attacker )
	end
	
	if killedUnit:IsCreature() then
		local death_xp = killedUnit:GetDeathXP()
		if death_xp > 0 then
			local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
			local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
			local targets = FindUnitsInRadius(killedUnit:GetTeamNumber(), killedUnit:GetAbsOrigin(), nil, 1200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
			local new_targets = {}
			for k, v in pairs(targets) do
				if v:IsCustomHero() and v:IsAlive() and not v:IsIllusion() and v.hero_xp then
					table.insert(new_targets, v)
				end
			end
			if #new_targets > 0 then
				death_xp = death_xp/#new_targets
				if _G.turbo then
					death_xp = death_xp * 2
				end
				local item = killedUnit:IsCustomHero() and not killedUnit:IsIllusion()
				for k, v in pairs(new_targets) do
					if item and v.GiveRandomItem then
						item = false
						v:GiveRandomItem()
					end
					v:AddCustomXP(death_xp)
				end
			end
		end
		if killerEntity ~= nil and killerEntity.IsIllusion and killerEntity:IsIllusion() then
			local killerOwner = killerEntity:GetPlayerOwner()
			local killerOwnerID = killerEntity:GetPlayerOwnerID()
			local gold = RandomInt(killedUnit:GetMinimumGoldBounty(), killedUnit:GetMaximumGoldBounty())
			SendOverheadEventMessage(killerOwner, OVERHEAD_ALERT_GOLD, killedUnit, gold, killerOwner)
			PlayerResource:ModifyGold(killerOwnerID, gold, false, DOTA_ModifyGold_CreepKill)
		end
    end
	if id and PlayerResource:IsValidTeamPlayerID(id) and _G.playersinfo[id].alive then
		local baracks = 0
		local towers = 0
		if _G.playersinfo[id].ancient == killedUnit then
			_G.playersinfo[id].ancient = nil
		end
		for k, v in pairs(_G.playersinfo[id].baracks) do
			if v == killedUnit then
				_G.playersinfo[id].baracks[k] = nil
			else
				baracks = baracks + 1
			end
		end
		for k, v in pairs(_G.playersinfo[id].towers) do
			if v == killedUnit then
				_G.playersinfo[id].towers[k] = nil
			else
				towers = towers + 1
			end
		end
		if _G.playersinfo[id].ancient == nil and baracks == 0 and towers == 0 then
			_G:Defeat(id)
		end
	end

end

function CDOTA_BaseNPC:IsCustomHero()
	if self and self:IsConsideredHero() and not self:IsAncient() then--self:FindAbilityByName("hero_armor") ~= nil--if string.find(self:GetUnitName(), "_hero_") ~= nil then
		return true
	end
	return false
end

function _G:Defeat(id)
	_G.playersinfo[id].alive = false
	if not _G.duos then
		table.insert(_G.statsinfo, id)
	end
	if _G.playersinfo[id].spec.specpass then
		_G.playersinfo[id].spec.specpass_name = _G.playersinfo[id].spec.specpass:GetAbilityName()
		_G.playersinfo[id].spec:RemoveAbility(_G.playersinfo[id].spec.specpass_name)
	end
	
	local upn = {
		[1] = {5,6,7,8},
		[2] = {1,2,7,8},
		[3] = {1,2,3,4},
		[4] = {3,4,5,6}
	}
	for _, nid in pairs(upn[_G.playersinfo[id].base_pos]) do
		_G.additional_buildings[nid]:UpgradeNeutral()
	end

	local gameEvent = {}
	gameEvent["player_id"] = id
	gameEvent["teamnumber"] = -1
	gameEvent["message"] = "#Combat_Message_player_lose"
	FireGameEvent( "dota_combat_event_message", gameEvent )
	
	local place = 1
	local winner = nil
	for id2, _ in pairs(_G.playersinfo) do
		if _G.playersinfo[id2].alive == true then
			if place == 1 then
				winner = id2
			else
				if winner ~= nil and PlayerResource:GetTeam(winner) ~= PlayerResource:GetTeam(id2) then
					winner = nil
				end
			end
			place = place + 1
		end
	end
	
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "CloseSelectGift", {})

	Store:OnPlayerDefeat(id, place, winner)--Coins
	--BattlePasses:OnPlayerDefeat(id, place, winner)

	--if place == 3 then
	--	CustomGameEventManager:Send_ServerToAllClients( "AllowSurrend", {})
	--end

	if winner then
		--Challenges:TriggerEvent(winner, "player_win", {})

		if _G.duos then
			for id3, _ in pairs(_G.playersinfo) do
				if PlayerResource:GetTeam(winner) ~= PlayerResource:GetTeam(id3) then
					table.insert(_G.statsinfo,id3)
				end
			end
			for id3, _ in pairs(_G.playersinfo) do
				if PlayerResource:GetTeam(winner) == PlayerResource:GetTeam(id3) then
					table.insert(_G.statsinfo,id3)
				end
			end
		else
			table.insert(_G.statsinfo,winner)
		end
		for id3, _ in pairs(_G.playersinfo) do
			local raxs = Entities:FindAllByName("npc_dota_creature")
			local player_rax = nil
			for _, rax in pairs(raxs) do
				if rax:GetUnitName() == "npc_dota_custom_barrack" and rax:GetPlayerOwnerID() == id3 then
					player_rax = rax
					break
				end
			end
			local heroes = {}
			for i=0, player_rax:GetAbilityCount()-1 do
				local abil = player_rax:GetAbilityByIndex(i)
				if abil then
					local abil_name = abil:GetAbilityName()
					if string.find(abil_name, "spawn_hero_") ~= nil then
						local hero_name = string.sub(abil_name,12)
						hero_name = "npc_dota_"..string.gsub(hero_name,"_","_hero_",1)
						local lvl = nil
						local mbhero = Entities:FindAllByName("npc_dota_creature")
						for _, hero in pairs(mbhero) do
							if hero:GetUnitName() == hero_name and hero:GetPlayerOwnerID() == id3 then
								lvl = hero:GetLevel()
								break
							end
						end
						if not lvl then
							local hero_xp = _G.playersinfo[id3].unitsinfo[hero_name].hero_xp or 0
							local needxp = 100
							local lvlup = 1
							while hero_xp > needxp do
								lvlup = lvlup + 1
								hero_xp = hero_xp - needxp
								needxp = 100 * lvlup
							end
							lvl = lvlup
						end
						local data = {abil_name,lvl}
						table.insert(heroes, data)
					end
				end
			end
            local tbl = {
                race = _G.playersinfo[id3].race,
                gold = _G.playerstats[id3].goldspend + PlayerResource:GetGold(id3),
				lasthits = PlayerResource:GetLastHits(id3),
				-- Тут бывает сбой?
				spec = _G.playersinfo[id3].spec.specpass_name or _G.playersinfo[id3].spec.specpass:GetAbilityName(),
				heroes = heroes
			}
			-- DeepPrintTable(tbl)
            CustomNetTables:SetTableValue("Ends_Stats",tostring(id3),tbl)
		end
		
		CustomNetTables:SetTableValue("Ends_Stats", "statsinfo", _G.statsinfo)

		-- [SCD-OFFLINE] пересборка rating_table в конце игры отключена вместе с рейтингом.
		-- Важно: GetTableValue("Rating","stats") теперь возвращает nil (таблица не
		-- заполняется), и rating_table["ratings"] = {} уронил бы _G:Defeat ДО
		-- GameRules:SetGameWinner(...) - игра бы никогда не заканчивалась.
		if _G.SCD_RATING_ENABLED then
			local rating_table = CustomNetTables:GetTableValue("Rating","stats")
			rating_table["ratings"] = {}
			if _G.ratingstable["ratings"] then
				for i=0,PlayerResource:GetPlayerCount()-1 do
					rating_table["ratings"][i] = _G.ratingstable["ratings"][tostring(PlayerResource:GetSteamAccountID(i))] or {normal=1000,turbo=1000,duos=1000}
				end
			else
				for i=0,PlayerResource:GetPlayerCount()-1 do
					rating_table["ratings"][i] = {normal=1000,turbo=1000,duos=1000}
				end
			end
			CustomNetTables:SetTableValue("Rating","stats",rating_table)
		end
		
		SCGameMode:Stats(winner)
		--Challenges:OnGameEnded()
		GameRules:SetGameWinner(PlayerResource:GetTeam(winner))
		return
	end
	if not _G.duos then
		local team = PlayerResource:GetTeam(id)
		AddFOWViewer(team, Entities:FindByName( nil, "corner9"):GetAbsOrigin(), 5500, 99999, true)
		-- for i=1,#_G.additional_building_triggers do
		-- 	AddFOWViewer(team, _G.additional_building_triggers[i]:GetAbsOrigin(), 99999, 99999, true)
		-- end
		for i=1, 4 do
			AddFOWViewer(team, Entities:FindByName( nil, "corner"..(i*2 - 1)):GetAbsOrigin(), 5000, 99999, true)
		end
		for i=1, 4 do
			AddFOWViewer(team, Entities:FindByName( nil, "corner"..(i*2)):GetAbsOrigin(), 1750, 99999, true)
			AddFOWViewer(team, Entities:FindByName( nil, "spec_building_"..i):GetAbsOrigin(), 100, 99999, true)
		end
	end

	if _G.diretide then
		_G.diretide:OnPlayerDefeat(id)
	end
end

function _G:GetPlayerIDByTeam( team )
	for id, _ in pairs(_G.playersinfo) do
		if PlayerResource:GetTeam(id) == team then
			return id
		end
	end
	return nil
end

function SCGameMode:ModifyGoldFilter( event )
	if _G.turbo then
		event["gold"] = event["gold"] * 2
	end
    return true
end

function _G:UpdateSelectedEntity( id )
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "UpdateSelectedEntity", {})
end

function SCGameMode:SetSelectedEntity(data)
	-- print(data.entity)
	_G.selected_entity[data.PlayerID] = EntIndexToHScript(data.entity)
end

function SCGameMode:PlayerSurrend(data)
	local id = data.PlayerID
	if id and _G.playersinfo[id].alive then
		for k, v in pairs(_G.playersinfo[id].baracks) do
			v:ForceKill(false)
		end
		for k, v in pairs(_G.playersinfo[id].towers) do
			v:ForceKill(false)
		end
		if _G.playersinfo[id].ancient then
			_G.playersinfo[id].ancient:ForceKill(false)
		end
	end
end

function _G:HandleEventError(obj, name, err)
	print(err)

	-- Ensure we have data
	err = tostring(err or 'unknown')

	-- Tell everyone there was an error
	--Say(nil, name .. ' threw an error on event '..event, false)
	--Say(nil, err, false)
    --local req = CreateHTTPRequestScriptVM( "POST", "https://dotascd.ru/luadebug.php")
    --req:SetHTTPRequestGetOrPostParameter("v", GetDedicatedServerKeyV3("2"))
	--req:SetHTTPRequestGetOrPostParameter("match_id", tostring(GameRules:Script_GetMatchID()))
    --req:SetHTTPRequestGetOrPostParameter("debug", name .. ":" .. err)
    --req:Send(function(req_result)
    --    -- print(req_result.Body)
    --end)

	-- Prevent loop arounds
	if not obj.errorHandled then
		-- Store that we handled an error
		obj.errorHandled = true
	end
end