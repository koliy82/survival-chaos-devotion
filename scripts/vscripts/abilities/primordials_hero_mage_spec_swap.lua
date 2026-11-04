function OnAbilityExecuted( keys )
	local ability = keys.ability
    local caster = keys.caster
    local ability_cast
    Timers:CreateTimer(0.01, function()
		for i=0, caster:GetAbilityCount()-1 do
            local abil = caster:GetAbilityByIndex(i)
            if abil and abil ~= nil then
                local cd = abil:GetCooldownTimeRemaining()
			    local full_cd = abil:GetEffectiveCooldown(abil:GetLevel()-1)

			    if cd > 0 and full_cd - cd < 0.3 then
			    	ability_cast = abil
			    end
            end
        end
	    if ability_cast then
            local index = ability_cast:GetAbilityIndex()
            local cd = ability_cast:GetCooldownTimeRemaining()
            Timers:CreateTimer(cd, function()
                local level = ability_cast:GetLevel()
                if index == 0 then
                    caster:RemoveAbilityByHandle(ability_cast)
                    caster:AddAbility(ability.abilities_1[RandomInt(1, #ability.abilities_1)]):SetLevel(level)
                elseif index == 1 then
                    caster:RemoveAbilityByHandle(ability_cast)
                    caster:AddAbility(ability.abilities_2[RandomInt(1, #ability.abilities_2)]):SetLevel(level)
                elseif index == 2 then
                    caster:RemoveAbilityByHandle(ability_cast)
                    caster:AddAbility(ability.abilities_3[RandomInt(1, #ability.abilities_3)]):SetLevel(level)
                end
            end)
        end
    end)
end

function OnCreated( keys )
    local caster = keys.caster
	local ability = keys.ability

    ability.abilities_1 = {"treants_hero_mage_spec_thorn_bush",
    "treants_hero_mage_seed",
    "undead_hero_mage_spec_swarm",
    "undead_hero_mage_ice_vortex",
    "humans_hero_mage_fire_strike",
    "dwarfs_hero_mage_spec_rocket_barrage",
    "dwarfs_hero_mage_march",
    "spiders_hero_mage_impale",
    "nagas_hero_mage_arcs",
    "demons_hero_mage_pillar_of_flame",
    "frostivus_hero_mage_frozen_blast",
    "dragons_hero_mage_spec_ice_lab",
    "dragons_hero_mage_freezing_expl",
    "beastmen_hero_mage_attendants",
    "primordials_hero_mage_bolt",
    "invaders_hero_mage_orb",
    "pirates_hero_mage_tentacles"}
    ability.abilities_2 = {"treants_hero_mage_spec_forest_curse",
    "undead_hero_mage_spec_pulse",
    "undead_hero_mage_frost_armor",
    "orcs_hero_mage_static_buff",
    "dwarfs_hero_mage_spec_homing_missile",
    "dwarfs_hero_mage_laguna_blade",
    "elves_hero_mage_arcs",
    "demons_hero_mage_sacrifice",
    "frostivus_hero_mage_ice_spire",
    "dragons_hero_mage_spec_icarus_dive",
    "dragons_hero_mage_freezing_field",
    "beastmen_hero_mage_heal",
    "primordials_hero_mage_nimbus",
    "invaders_hero_mage_storm",
    "pirates_hero_mage_wind"}
    ability.abilities_3 = {"treants_hero_mage_spec_gust",
    "treants_hero_mage_nature_arc",
    "undead_hero_mage_spec_decay",
    "humans_hero_mage_illuminate",
    "orcs_hero_mage_void",
    "dwarfs_hero_mage_spec_flak_cannon",
    "elves_hero_mage_dragon_slave",
    "spiders_hero_mage_carapace",
    "nagas_hero_mage_tripple_gush",
    "frostivus_hero_mage_ice_walls",
    "dragons_hero_mage_spec_ice_breath",
    "dragons_hero_mage_ice_path",
    "invaders_hero_mage_flux",
    "pirates_hero_mage_torrent"}

    local abil = caster:GetAbilityByIndex(0)
    local level = abil:GetLevel()

    caster:RemoveAbilityByHandle(abil)
    caster:AddAbility(ability.abilities_1[RandomInt(1, #ability.abilities_1)]):SetLevel(level)

    abil = caster:GetAbilityByIndex(1)
    level = abil:GetLevel()

    caster:RemoveAbilityByHandle(abil)
    caster:AddAbility(ability.abilities_2[RandomInt(1, #ability.abilities_2)]):SetLevel(level)

    abil = caster:GetAbilityByIndex(2)
    level = abil:GetLevel()

    caster:RemoveAbilityByHandle(abil)
    caster:AddAbility(ability.abilities_3[RandomInt(1, #ability.abilities_3)]):SetLevel(level)
end