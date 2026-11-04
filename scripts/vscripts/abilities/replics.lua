function undead_tank(event)
    local caster = event.caster
	local replics = {"skeleton_king_wraith_ability_incarn1_07",
	"skeleton_king_wraith_spawn_02",
	"skeleton_king_wraith_attack_02",
	"skeleton_king_wraith_rare_08",
	"skeleton_king_wraith_move_19",
	"skeleton_king_wraith_move_10",
	"skeleton_king_wraith_move_08",
	"skeleton_king_wraith_attack_03",
	"skeleton_king_wraith_level_06",
	"skeleton_king_wraith_kill_12",
	"skeleton_king_wraith_win_01",
	"skeleton_king_wraith_respawn_08",
	"skeleton_king_wraith_move_20",
	"skeleton_king_wraith_move_12",
	"skeleton_king_wraith_move_07",
	"skeleton_king_wraith_level_09",
	"skeleton_king_wraith_level_03",
	"skeleton_king_wraith_level_01",
	"skeleton_king_wraith_lasthit_11",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function undead_mage(event)
    local caster = event.caster
	local replics = {"lich_lich_ability_armor_04",
	"lich_lich_ability_chain_02",
	"lich_lich_ability_chain_01",
	"lich_lich_ability_chain_03",
	"lich_lich_ability_chain_04",
	"lich_lich_ability_chain_05",
	"lich_lich_ability_chain_10",
	"lich_lich_lasthit_05",
	"lich_lich_level_09",
	"lich_lich_win_01",
	"lich_lich_spawn_03",
	"lich_lich_respawn_07",
	"lich_lich_regen_02",
	"lich_lich_rare_03",
	"lich_lich_move_15",
	"lich_lich_move_13",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end
------ Меня нагрели… (смерть)

function undead_killer(event)
    local caster = event.caster
	local replics = {"clinkz_clinkz_ability_pact_03",
	"clinkz_clinkz_immort_03",
	"clinkz_clinkz_move_11",
	"clinkz_clinkz_respawn_03",
	"clinkz_clinkz_respawn_07",
	"clinkz_clinkz_laugh_08",
	"clinkz_clinkz_illus_03",
	"clinkz_clinkz_illus_02",
	"clinkz_clinkz_ability_pact_05",
	"clinkz_clinkz_ability_sear_01",
	"clinkz_clinkz_ability_strafe_01",
	"clinkz_clinkz_attack_08",
	"clinkz_clinkz_battlebegins_01",
	"clinkz_clinkz_death_11",
	"clinkz_clinkz_doubdam_02",
	"clinkz_clinkz_kill_01",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function nagas_tank(event)
    local caster = event.caster
	local replics = {"slardar_slar_ability_ampdam_01",
	"slardar_slar_level_04",
	"slardar_slar_kill_04",
	"slardar_slar_kill_08",
	"slardar_slar_respawn_08",
	"slardar_slar_win_05",
	"slardar_slar_kill_05",
	"slardar_slar_win_05",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function nagas_mage(event)
    local caster = event.caster
	local replics = {"medusa_medus_rare_01",
	"medusa_medus_attack_12",
	"medusa_medus_stonegaze_11",
	"medusa_medus_kill_09",
	"medusa_medus_rival_21",
	"medusa_medus_ally_08",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function nagas_killer(event)
    local caster = event.caster
	local replics = {"slark_slark_spawn_05",
	"slark_slark_attack_01",
	"slark_slark_battlebegins_01",
	"slark_slark_lasthit_06",
	"slark_slark_lasthit_10",
	"slark_slark_respawn_05",
	"slark_slark_rival_02",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function nagas_pusher(event)
    local caster = event.caster
	local replics = {"tidehunter_tide_attack_06",
	"tidehunter_tide_attack_07",
	"tidehunter_tide_attack_09",
	"tidehunter_tide_ability_ravage_01",
	"tidehunter_tide_ability_ravage_02",
	"tidehunter_tide_kill_12",
	"tidehunter_tide_kill_10",
	"tidehunter_tide_kill_08",
	"tidehunter_tide_kill_02",
	"tidehunter_tide_respawn_05",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function demons_tank(event)
    local caster = event.caster
	local replics = {"abyssal_underlord_abys_spawn_08",
	"abyssal_underlord_abys_darkrift_05",
	"abyssal_underlord_abys_kill_02",
	"abyssal_underlord_abys_kill_07",
	"abyssal_underlord_abys_illus_02",
	"abyssal_underlord_abys_respawn_02",
	"abyssal_underlord_abys_rare_01",
	"abyssal_underlord_abys_rare_02",
	"abyssal_underlord_abys_failure_01",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function demons_mage(event)
    local caster = event.caster
	local replics = {"nevermore_nev_ability_presence_02",
	"nevermore_nev_level_08",
	"nevermore_nev_arc_death_06",
	"nevermore_nev_arc_rare_05",
	"nevermore_nev_arc_rare_06",
	"nevermore_nev_arc_respawn_04",
	"nevermore_nev_arc_win_06",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function demons_killer(event)
    local caster = event.caster
	local replics = {"terrorblade_terr_metamorphosis_05",
	"terrorblade_terr_metamorphosis_07",
	"terrorblade_terr_kill_07",
	"terrorblade_terr_kill_08",
	"terrorblade_terr_kill_11",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function demons_pusher(event)
    local caster = event.caster
	local replics = {"doom_bringer_doom_ability_doom_01",
	"doom_bringer_doom_ability_doom_04",
	"doom_bringer_doom_ability_doom_06",
	"doom_bringer_doom_ability_lvldeath_04",
	"doom_bringer_doom_ability_scorched_03",
	"doom_bringer_doom_ally_02",
	"doom_bringer_doom_anger_09",
	"doom_bringer_doom_attack_06",
	"doom_bringer_doom_attack_09",
	"doom_bringer_doom_attack_10",
	"doom_bringer_doom_cast_01",
	"doom_bringer_doom_cast_03",
	"doom_bringer_doom_deny_04",
	"doom_bringer_doom_immort_02",
	"doom_bringer_doom_kill_09",
	"doom_bringer_doom_kill_11",
	"doom_bringer_doom_move_08",
	"doom_bringer_doom_move_09",
	"doom_bringer_doom_respawn_12",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function treants_tank(event)
    local caster = event.caster
	local replics = {"treant_treant_ability_leechseed_02",
	"treant_treant_ability_leechseed_05",
	"treant_treant_ability_livingarmor_03",
	"treant_treant_ability_livingarmor_04",
	"treant_treant_ability_overgrowth_03",
	"treant_treant_ability_overgrowth_04",
	"treant_treant_anger_06",
	"treant_treant_attack_06",
	"treant_treant_attack_08",
	"treant_treant_battlebegins_01",
	"treant_treant_death_11",
	"treant_treant_drop_rare",
	"treant_treant_immort_01",
	"treant_treant_levelup_01",
	"treant_treant_levelup_06",
	"treant_treant_levelup_07",
	"treant_treant_levelup_08",
	"treant_treant_respawn_06",
	"treant_treant_respawn_11",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function humans_tank(event)
    local caster = event.caster
	local replics = {"omniknight_omni_ability_degaura_01",
	"omniknight_omni_ability_degaura_03",
	"omniknight_omni_ability_degaura_12",
	"omniknight_omni_ability_guard_01",
	"omniknight_omni_ability_guard_03",
	"omniknight_omni_ability_guard_04",
	"omniknight_omni_ability_guard_10",
	"omniknight_omni_ability_guard_11",
	"omniknight_omni_ability_purif_07",
	"omniknight_omni_ability_repel_03",
	"omniknight_omni_attack_02",
	"omniknight_omni_attack_01",
	"omniknight_omni_battlebegins_01",
	"omniknight_omni_deny_09",
	"omniknight_omni_kill_05",
	"omniknight_omni_kill_11",
	"omniknight_omni_level_10",
	"omniknight_omni_move_17",
	"omniknight_omni_respawn_02",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function humans_mage(event)
    local caster = event.caster
	local replics = {"keeper_of_the_light_keep_cast_02",
	"keeper_of_the_light_keep_chakramagic_02",
	"keeper_of_the_light_keep_chakramagic_01",
	"keeper_of_the_light_keep_deny_12",
	"keeper_of_the_light_keep_illuminate_04",
	"keeper_of_the_light_keep_incant_02",
	"keeper_of_the_light_keep_incant_01",
	"keeper_of_the_light_keep_incant_03",
	"keeper_of_the_light_keep_incant_04",
	"keeper_of_the_light_keep_incant_05",
	"keeper_of_the_light_keep_incant_06",
	"keeper_of_the_light_keep_incant_08",
	"keeper_of_the_light_keep_incant_09",
	"keeper_of_the_light_keep_incant_11",
	"keeper_of_the_light_keep_kill_13",
	"keeper_of_the_light_keep_spiritform_05",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function humans_killer(event)
    local caster = event.caster
	local replics = {"phantom_assassin_phass_spawn_01",
	"phantom_assassin_phass_spawn_02",
	"phantom_assassin_phass_spawn_03",
	"phantom_assassin_phass_respawn_06",
	"phantom_assassin_phass_respawn_04",
	"phantom_assassin_phass_move_19",
	"phantom_assassin_phass_move_18",
	"phantom_assassin_phass_move_15",
	"phantom_assassin_phass_move_16",
	"phantom_assassin_phass_move_14",
	"phantom_assassin_phass_move_13",
	"phantom_assassin_phass_move_09",
	"phantom_assassin_phass_level_06",
	"phantom_assassin_phass_level_04",
	"phantom_assassin_phass_level_01",
	"phantom_assassin_phass_level_02",
	"phantom_assassin_phass_laugh_06",
	"phantom_assassin_phass_kill_02",
	"phantom_assassin_phass_invis_02",
	"phantom_assassin_phass_immort_02",
	"phantom_assassin_phass_happy_07",
	"phantom_assassin_phass_doubdam_02",
	"phantom_assassin_phass_deny_13",
	"phantom_assassin_phass_cast_04",
	"phantom_assassin_phass_attack_07",
	"phantom_assassin_phass_ability_blur_01",
	"phantom_assassin_phass_ability_blur_02",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function humans_pusher(event)
    local caster = event.caster
	local replics = {"legion_commander_legcom_attack_01",
	"legion_commander_legcom_attack_04",
	"legion_commander_legcom_attack_06",
	"legion_commander_legcom_attack_08",
	"legion_commander_legcom_begin_01",
	"legion_commander_legcom_bottle_01",
	"legion_commander_legcom_cast_02",
	"legion_commander_legcom_doubdam_02",
	"legion_commander_legcom_duel_04",
	"legion_commander_legcom_duel_05",
	"legion_commander_legcom_duelhero_11",
	"legion_commander_legcom_duelhero_13",
	"legion_commander_legcom_duelhero_18",
	"legion_commander_legcom_duelhero_26",
	"legion_commander_legcom_duelhero_30",
	"legion_commander_legcom_duelhero_32",
	"legion_commander_legcom_econ_ally_01",
	"legion_commander_legcom_econ_attack_03",
	"legion_commander_legcom_econ_death_02",
	"legion_commander_legcom_econ_kill_04",
	"legion_commander_legcom_econ_lose_01",
	"legion_commander_legcom_econ_move_08",
	"legion_commander_legcom_econ_move_10",
	"legion_commander_legcom_econ_spawn_03",
	"legion_commander_legcom_econ_win_01",
	"legion_commander_legcom_fastres_01",
	"legion_commander_legcom_kill_04",
	"legion_commander_legcom_laugh_05",
	"legion_commander_legcom_levelup_07",
	"legion_commander_legcom_levelup_03",
	"legion_commander_legcom_momentofcourage_02",
	"legion_commander_legcom_move_07",
	"legion_commander_legcom_move_14",
	"legion_commander_legcom_overwhelmingodds_03",
	"legion_commander_legcom_presstheattack_03",
	"legion_commander_legcom_presstheattack_06",
	"legion_commander_legcom_presstheattack_09",
	"legion_commander_legcom_respawn_02",
	"legion_commander_legcom_respawn_03",
	"legion_commander_legcom_rival_06",
	"legion_commander_legcom_rival_19",
	"legion_commander_legcom_win_04",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function orcs_mage(event)
    local caster = event.caster
	local replics = {"disruptor_dis_win_04",
	"disruptor_dis_thunderstrike_03",
	"disruptor_dis_thunderstrike_04",
	"disruptor_dis_thunderstrike_02",
	"disruptor_dis_rival_07",
	"disruptor_dis_rival_06",
	"disruptor_dis_rare_02",
	"disruptor_dis_levelup_11",
	"disruptor_dis_levelup_09",
	"disruptor_dis_kineticfield_03",
	"disruptor_dis_kineticfield_01",
	"disruptor_dis_kill_09",
	"disruptor_dis_cast_03",
	"disruptor_dis_begin_01",
	"disruptor_dis_ally_06",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function orcs_killer(event)
    local caster = event.caster
	local replics = {"juggernaut_jug_ability_bladefury_09",
	"juggernaut_jug_ability_bladefury_05",
	"juggernaut_jug_arc_ability_bladefury_02",
	"juggernaut_jug_arc_ability_bladefury_09",
	"juggernaut_jug_arc_laugh_06",
	"juggernaut_jug_arc_stance_02",
	"juggernaut_jug_arc_stance_04",
	"juggernaut_jug_arc_stance_06",
	"juggernaut_jug_arc_stance_07",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function orcs_pusher(event)
    local caster = event.caster
	local replics = {"alchemist_alch_ability_rage_15",
	"alchemist_alch_ability_rage_23",
	"alchemist_alch_ability_rage_24",
	"alchemist_alch_attack_14",
	"alchemist_alch_kill_16",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function dwarfs_tank(event)
    local caster = event.caster
	local replics = {"rattletrap_ratt_ability_flare_07",
	"rattletrap_ratt_cuz_23",
	"rattletrap_ratt_cuz_22",
	"rattletrap_ratt_cuz_20",
	"rattletrap_ratt_cuz_19",
	"rattletrap_ratt_cuz_18",
	"rattletrap_ratt_cuz_17",
	"rattletrap_ratt_cuz_15",
	"rattletrap_ratt_cuz_12",
	"rattletrap_ratt_cuz_14",
	"rattletrap_ratt_cuz_11",
	"rattletrap_ratt_cuz_05",
	"rattletrap_ratt_cuz_04",
	"rattletrap_ratt_cuz_03",
	"rattletrap_ratt_cuz_02",
	"rattletrap_ratt_attack_11",
	"rattletrap_ratt_respawn_18",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function dwarfs_killer(event)
    local caster = event.caster
	local replics = {"sniper_snip_ability_shrapnel_06",
	"sniper_snip_ability_assass_02",
	"sniper_snip_ability_shrapnel_02",
	"sniper_snip_ability_shrapnel_07",
	"sniper_snip_attack_04",
	"sniper_snip_attack_05",
	"sniper_snip_kill_01",
	"sniper_snip_kill_02",
	"sniper_snip_kill_06",
	"sniper_snip_kill_10",
	"sniper_snip_lasthit_04",
	"sniper_snip_lasthit_06",
	"sniper_snip_spawn_03",
	"sniper_snip_ability_shrapnel_06",
	"sniper_snip_ability_shrapnel_06",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function elves_mage(event)
    local caster = event.caster
	local replics = {"invoker_invo_ability_forgespirit_03",
	"invoker_invo_ability_forgespirit_02",
	"invoker_invo_ability_forgespirit_01",
	"invoker_invo_ability_forgespirit_06",
	"invoker_invo_move_13",
	"invoker_invo_level_11",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function elves_killer(event)
    local caster = event.caster
	local replics = {"templar_assassin_temp_invis_02",
	"templar_assassin_temp_attack_03",
	"templar_assassin_temp_attack_06",
	"templar_assassin_temp_attack_07",
	"templar_assassin_temp_blink_02",
	"templar_assassin_temp_happy_04",
	"templar_assassin_temp_illus_02",
	"templar_assassin_temp_immort_02",
	"templar_assassin_temp_kill_12",
	"templar_assassin_temp_lasthit_05",
	"templar_assassin_temp_laugh_05",
	"templar_assassin_temp_meld_01",
	"templar_assassin_temp_meld_02",
	"templar_assassin_temp_psiblades_01",
	"templar_assassin_temp_psionictrap_03",
	"templar_assassin_temp_purch_02",
	"templar_assassin_temp_respawn_05",
	"templar_assassin_temp_spawn_04",
	"templar_assassin_temp_thanks_05",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function spiders_tank(event)
    local caster = event.caster
	local replics = {"sandking_skg_kill_04",
	"sandking_skg_ability_epicenter_01",
	"sandking_skg_ability_epicenter_04",
	"sandking_skg_ability_epicenter_blink_01",
	"sandking_skg_ability_sandstorm_02",
	"sandking_skg_attack_04",
	"sandking_skg_attack_05",
	"sandking_skg_attack_11",
	"sandking_skg_respawn_06",
	"sandking_skg_win_04",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function spiders_pusher(event)
    local caster = event.caster
	local replics = {"broodmother_broo_kill_02",
	"broodmother_broo_ability_hunger_01",
	"broodmother_broo_ability_hunger_02",
	"broodmother_broo_ability_hunger_03",
	"broodmother_broo_ability_hunger_04",
	"broodmother_broo_ability_hunger_05",
	"broodmother_broo_ability_spawn_01",
	"broodmother_broo_ability_spawn_02",
	"broodmother_broo_ability_spawn_12",
	"broodmother_broo_attack_03",
	"broodmother_broo_battlebegins_01",
	"broodmother_broo_cast_04",
	"broodmother_broo_haste_02",
	"broodmother_broo_illus_02",
	"broodmother_broo_kill_01",
	"broodmother_broo_kill_16",
	"broodmother_broo_lasthit_12",
	"broodmother_broo_move_09",
	"broodmother_broo_rare_02",
	"broodmother_broo_regen_02",
	"broodmother_broo_spawn_03",
	"broodmother_broo_spawn_05",
	"broodmother_broo_win_03",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function treants_mage_spec(event)
    local caster = event.caster
	local replics = {"dark_willow_sylph_move_24",
	"dark_willow_sylph_move_12",
	"dark_willow_sylph_ability4_13",
	"dark_willow_sylph_ability4_12",
	"dark_willow_sylph_ability4_01",
	"dark_willow_sylph_levelup_05",
	"dark_willow_sylph_levelup_01",
	"dark_willow_sylph_kill_05",
	"dark_willow_sylph_laugh_05",
	"dark_willow_sylph_laugh_14",
	"dark_willow_sylph_laugh_11",
	"dark_willow_sylph_laugh_07",
	"dark_willow_sylph_laugh_13",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function undead_mage_spec(event)
    local caster = event.caster
	local replics = {"necrolyte_necr_ability_aura_03",
	"necrolyte_necr_ability_reap_01",
	"necrolyte_necr_ability_tox_03",
	"necrolyte_necr_attack_04",
	"necrolyte_necr_cast_03",
	"necrolyte_necr_deny_08",
	"necrolyte_necr_deny_10",
	"necrolyte_necr_immort_02",
	"necrolyte_necr_kill_02",
	"necrolyte_necr_kill_05",
	"necrolyte_necr_laugh_03",
	"necrolyte_necr_laugh_07",
	"necrolyte_necr_level_05",
	"necrolyte_necr_pudge_05",
	"necrolyte_necr_rare_04",
	"necrolyte_necr_rare_05",
	"necrolyte_necr_respawn_04",
	"necrolyte_necr_respawn_12",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function humans_killer_spec(event)
    local caster = event.caster
	local replics = {"drowranger_dro_ability_06",
	"drowranger_dro_attack_03",
	"drowranger_drow_kill_08",
	"drowranger_drow_levelup_03",
	"drowranger_drow_levelup_04",
	"drowranger_drow_levelup_07",
	"drowranger_dro_attack_10",
	"drowranger_dro_cast_01",
	"drowranger_dro_deny_03",
	"drowranger_dro_kill_01",
	"drowranger_dro_kill_07",
	"drowranger_dro_laugh_08",
	"drowranger_dro_laugh_07",
	"drowranger_dro_spawn_07",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function orcs_tank_spec(event)
    local caster = event.caster
	local replics = {"ogre_magi_ogmag_ability_bloodlust_04",
	"ogre_magi_ogmag_ability_firebl_03",
	"ogre_magi_ogmag_ability_ignite_03",
	"ogre_magi_ogmag_ability_multi_01",
	"ogre_magi_ogmag_ability_multi_02",
	"ogre_magi_ogmag_ability_multi_05",
	"ogre_magi_ogmag_ability_multi_04",
	"ogre_magi_ogmag_ability_multi_07",
	"ogre_magi_ogmag_ability_multi_09",
	"ogre_magi_ogmag_ability_multi_hit_01",
	"ogre_magi_ogmag_ability_multi_hit_11",
	"ogre_magi_ogmag_attack_03",
	"ogre_magi_ogmag_attack_02",
	"ogre_magi_ogmag_attack_04",
	"ogre_magi_ogmag_attack_05",
	"ogre_magi_ogmag_attack_11",
	"ogre_magi_ogmag_attack_12",
	"ogre_magi_ogmag_cast_01",
	"ogre_magi_ogmag_cast_02",
	"ogre_magi_ogmag_death_05",
	"ogre_magi_ogmag_deny_01",
	"ogre_magi_ogmag_deny_03",
	"ogre_magi_ogmag_deny_06",
	"ogre_magi_ogmag_deny_16",
	"ogre_magi_ogmag_deny_17",
	"ogre_magi_ogmag_illus_02",
	"ogre_magi_ogmag_immort_02",
	"ogre_magi_ogmag_inthebag_01",
	"ogre_magi_ogmag_invis_02",
	"ogre_magi_ogmag_kill_01",
	"ogre_magi_ogmag_kill_04",
	"ogre_magi_ogmag_kill_07",
	"ogre_magi_ogmag_kill_12",
	"ogre_magi_ogmag_lasthit_01",
	"ogre_magi_ogmag_lasthit_03",
	"ogre_magi_ogmag_laugh_02",
	"ogre_magi_ogmag_laugh_03",
	"ogre_magi_ogmag_laugh_06",
	"ogre_magi_ogmag_laugh_14",
	"ogre_magi_ogmag_level_02",
	"ogre_magi_ogmag_level_03",
	"ogre_magi_ogmag_level_07",
	"ogre_magi_ogmag_lose_03",
	"ogre_magi_ogmag_regen_02",
	"ogre_magi_ogmag_respawn_01",
	"ogre_magi_ogmag_respawn_06",
	"ogre_magi_ogmag_respawn_10",
	"ogre_magi_ogmag_rival_01",
	"ogre_magi_ogmag_rival_20",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function dwarfs_mage_spec(event)
    local caster = event.caster
	local replics = {"gyrocopter_gyro_call_down_04",
	"gyrocopter_gyro_attack_05",
	"gyrocopter_gyro_attack_06",
	"gyrocopter_gyro_attack_14",
	"gyrocopter_gyro_attack_18",
	"gyrocopter_gyro_attack_19",
	"gyrocopter_gyro_begins_01",
	"gyrocopter_gyro_blink_02",
	"gyrocopter_gyro_call_down_01",
	"gyrocopter_gyro_call_down_07",
	"gyrocopter_gyro_flak_cannon_09",
	"gyrocopter_gyro_homing_missile_fire_07",
	"gyrocopter_gyro_kill_02",
	"gyrocopter_gyro_kill_07",
	"gyrocopter_gyro_kill_16",
	"gyrocopter_gyro_laugh_12",
	"gyrocopter_gyro_laugh_11",
	"gyrocopter_gyro_level_04",
	"gyrocopter_gyro_level_13",
	"gyrocopter_gyro_move_27",
	"gyrocopter_gyro_rival_16",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function diretide_tank(event)
    local caster = event.caster
	local replics = {"pudge_pud_ability_hook_01",
	"pudge_pud_ability_hook_03",
	"pudge_pud_ability_hook_05",
	"pudge_pud_ability_hook_10",
	"pudge_pud_ability_hook_09",
	"pudge_pud_ability_hook_miss_05",
	"pudge_pud_ability_hook_miss_06",
	"pudge_pud_ability_rot_09",
	"pudge_pud_attack_01",
	"pudge_pud_attack_03",
	"pudge_pud_attack_05",
	"pudge_pud_attack_06",
	"pudge_pud_attack_08",
	"pudge_pud_attack_14",
	"pudge_pud_battlebegins_01",
	"pudge_pud_deny_02",
	"pudge_pud_deny_03",
	"pudge_pud_deny_09",
	"pudge_pud_kill_01",
	"pudge_pud_kill_09",
	"pudge_pud_kill_08",
	"pudge_pud_kill_11",
	"pudge_pud_lasthit_04",
	"pudge_pud_level_05",
	"pudge_pud_level_09",
	"pudge_pud_lose_04",
	"pudge_pud_rare_01",
	"pudge_pud_respawn_04",
	"pudge_pud_respawn_05",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function frostivus_killer(event)
    local caster = event.caster
	local replics = {"sven_sven_ability_godstrength_01",
	"sven_sven_attack_01",
	"sven_sven_attack_02",
	"sven_sven_attack_06",
	"sven_sven_attack_09",
	"sven_sven_attack_10",
	"sven_sven_haste_02",
	"sven_sven_immort_04",
	"sven_sven_invis_02",
	"sven_sven_kill_02",
	"sven_sven_kill_08",
	"sven_sven_level_02",
	"sven_sven_respawn_05",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function dragons_tank(event)
    local caster = event.caster
	local replics = {"dragon_knight_dragon_ability_eldrag_01",
	"dragon_knight_dragon_ability_eldrag_02",
	"dragon_knight_dragon_ability_eldrag_03",
	"dragon_knight_dragon_ability_eldrag_05",
	"dragon_knight_dragon_attack_02",
	"dragon_knight_dragon_attack_03",
	"dragon_knight_dragon_attack_04",
	"dragon_knight_dragon_attack_09",
	"dragon_knight_dragon_attack_10",
	"dragon_knight_dragon_cast_01",
	"dragon_knight_dragon_cast_02",
	"dragon_knight_dragon_cast_03",
	"dragon_knight_dragon_dragonsound_01",
	"dragon_knight_dragon_immort_02",
	"dragon_knight_dragon_kill_01",
	"dragon_knight_dragon_kill_03",
	"dragon_knight_dragon_kill_07",
	"dragon_knight_dragon_level_01",
	"dragon_knight_dragon_regen_02",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function dragons_mage(event)
    local caster = event.caster
	local replics = {"winter_wyvern_winwyv_articburn_01",
	"winter_wyvern_winwyv_articburn_04",
	"winter_wyvern_winwyv_attack_03",
	"winter_wyvern_winwyv_attack_05",
	"winter_wyvern_winwyv_attack_07",
	"winter_wyvern_winwyv_attack_08",
	"winter_wyvern_winwyv_attack_10",
	"winter_wyvern_winwyv_battlebegins_01",
	"winter_wyvern_winwyv_cast_01",
	"winter_wyvern_winwyv_cast_02",
	"winter_wyvern_winwyv_cast_03",
	"winter_wyvern_winwyv_deny_08",
	"winter_wyvern_winwyv_deny_07",
	"winter_wyvern_winwyv_deny_15",
	"winter_wyvern_winwyv_immort_02",
	"winter_wyvern_winwyv_kill_03",
	"winter_wyvern_winwyv_kill_05",
	"winter_wyvern_winwyv_levelup_04",
	"winter_wyvern_winwyv_rare_03",
	"winter_wyvern_winwyv_respawn_03",
	"winter_wyvern_winwyv_win_03",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function beastmen_tank(event)
    local caster = event.caster
	local replics = {"earthshaker_erth_ability_echo_01",
	"earthshaker_erth_ability_echo_03",
	"earthshaker_erth_ability_enchant_01",
	"earthshaker_erth_ability_enchant_02",
	"earthshaker_erth_ability_fissure_01",
	"earthshaker_erth_ability_fissure_02",
	"earthshaker_erth_ability_fissure_03",
	"earthshaker_erth_attack_03",
	"earthshaker_erth_attack_07",
	"earthshaker_erth_battlebegins_01",
	"earthshaker_erth_doubdam_02",
	"earthshaker_erth_doubdam_03",
	"earthshaker_erth_fastres_01",
	"earthshaker_erth_invis_02",
	"earthshaker_erth_kill_02",
	"earthshaker_erth_kill_07",
	"earthshaker_erth_kill_04",
	"earthshaker_erth_kill_05",
	"earthshaker_erth_level_04",
	"earthshaker_erth_level_05",
	"earthshaker_erth_level_09",
	"earthshaker_erth_respawn_06",
	"earthshaker_erth_spawn_06",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function beastmen_killer(event)
    local caster = event.caster
	local replics = {"monkey_king_monkey_ability1_03",
	"monkey_king_monkey_ability1_05",
	"monkey_king_monkey_ability2_02",
	"monkey_king_monkey_ability4_01",
	"monkey_king_monkey_ability4_03",
	"monkey_king_monkey_ability4_04",
	"monkey_king_monkey_ability4_05",
	"monkey_king_monkey_attack_01",
	"monkey_king_monkey_attack_02",
	"monkey_king_monkey_attack_03",
	"monkey_king_monkey_attack_04",
	"monkey_king_monkey_attack_05",
	"monkey_king_monkey_attack_07",
	"monkey_king_monkey_attack_12",
	"monkey_king_monkey_attack_13",
	"monkey_king_monkey_attack_14",
	"monkey_king_monkey_battlebegins_02",
	"monkey_king_monkey_battlebegins_03",
	"monkey_king_monkey_blink_02",
	"monkey_king_monkey_cast_02",
	"monkey_king_monkey_cast_03",
	"monkey_king_monkey_death_02",
	"monkey_king_monkey_deny_05",
	"monkey_king_monkey_doubledam_01",
	"monkey_king_monkey_doubledam_02",
	"monkey_king_monkey_fastres_01",
	"monkey_king_monkey_invis_01",
	"monkey_king_monkey_kill_05",
	"monkey_king_monkey_kill_06",
	"monkey_king_monkey_kill_12",
	"monkey_king_monkey_lasthit_05",
	"monkey_king_monkey_laugh_09",
	"monkey_king_monkey_levelup_06",
	"monkey_king_monkey_levelup_07",
	"monkey_king_monkey_levelup_08",
	"monkey_king_monkey_levelup_10",
	"monkey_king_monkey_rare_02",
	"monkey_king_monkey_rare_04",
	"monkey_king_monkey_respawn_01",
	"monkey_king_monkey_spawn_01",
	"monkey_king_monkey_spawn_09",
	"monkey_king_monkey_win_02"}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function beastmen_pusher(event)
    local caster = event.caster
	local replics = {"lycan_lycan_ability_revert_01",
	"lycan_lycan_ability_shapeshift_01",
	"lycan_lycan_ability_shapeshift_02",
	"lycan_lycan_ability_shapeshift_03",
	"lycan_lycan_ability_shapeshift_04",
	"lycan_lycan_ability_shapeshift_05",
	"lycan_lycan_ability_shapeshift_09",
	"lycan_lycan_ability_shapeshift_10",
	"lycan_lycan_attack_02",
	"lycan_lycan_attack_03",
	"lycan_lycan_attack_04",
	"lycan_lycan_attack_05",
	"lycan_lycan_attack_06",
	"lycan_lycan_attack_07",
	"lycan_lycan_battlebegins_02",
	"lycan_lycan_cast_01",
	"lycan_lycan_cast_02",
	"lycan_lycan_cast_03",
	"lycan_lycan_kill_07",
	"lycan_lycan_kill_11",
	"lycan_lycan_laugh_02",
	"lycan_lycan_laugh_05",
	"lycan_lycan_level_01",
	"lycan_lycan_level_05",
	"lycan_lycan_rare_01",
	"lycan_lycan_rare_02",
	"lycan_lycan_win_03",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function primordials_mage(event)
    local caster = event.caster
	local replics = {"zuus_zuus_ability_thunder_02",
	"zuus_zuus_ability_thunder_06",
	"zuus_zuus_arc_attack_02",
	"zuus_zuus_arc_attack_04",
	"zuus_zuus_arc_attack_07",
	"zuus_zuus_arc_attack_08",
	"zuus_zuus_arc_battlebegins_01",
	"zuus_zuus_arc_cast_01",
	"zuus_zuus_arc_kill_03",
	"zuus_zuus_arc_kill_05",
	"zuus_zuus_arc_kill_06",
	"zuus_zuus_arc_kill_08",
	"zuus_zuus_arc_kill_10",
	"zuus_zuus_arc_kill_11",
	"zuus_zuus_arc_kill_12",
	"zuus_zuus_arc_level_01",
	"zuus_zuus_arc_level_02",
	"zuus_zuus_arc_level_03",
	"zuus_zuus_arc_level_04",
	"zuus_zuus_arc_level_05",
	"zuus_zuus_arc_rare_04",
	"zuus_zuus_arc_rare_05",
	"zuus_zuus_arc_respawn_06",
	"zuus_zuus_arc_respawn_08",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end

function elementals_tank(event)
    local caster = event.caster
	local replics = {"earthspi_ally_01",
	"earthspi_ally_02",
	"earthspi_ally_20",
	"earthspi_attack_03",
	"earthspi_attack_05",
	"earthspi_cast_03",
	"earthspi_firstblood_03",
	"earthspi_immort_02",
	"earthspi_immort_03",
	"earthspi_levelup_10",
	"earthspi_move_05",
	"earthspi_move_23",
	"earthspi_respawn_04",
	"earthspi_respawn_07",
	"earthspi_respawn_10",
	"earthspi_rollingboulder_06",
	"earthspi_spawn_03",
	"earthspi_stonecaller_02",
	"earthspi_stonecaller_08",
	"earthspi_win_03",
	"earth_spirit_earthspi_stonecaller_07",
	""}
	StartSoundEvent(replics[RandomInt(1,#replics)], caster)
end