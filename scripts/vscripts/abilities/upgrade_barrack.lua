LinkLuaModifier( "modifier_elite_unit", "modifiers/modifier_elite_unit.lua", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_barrack_antiair", "modifiers/modifier_barrack_antiair.lua", LUA_MODIFIER_MOTION_NONE )
function OnSpellStart(event)
    --DeepPrintTable(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()
    local id = caster:GetPlayerOwnerID()
    local hp_gain = 750
    -- local heroduration = ability:GetLevelSpecialValueFor("hero_duration", level-1)
    -- local creepduration = ability:GetLevelSpecialValueFor("creep_duration", level-1)
    
    if level == 1 then
        caster.barrack_timer = caster.barrack_timer - 3
        --caster:AddNewModifier(caster, ability, "modifier_barrack_antiair", {})
    elseif level == 2 then
        caster:AddNewModifier(caster, ability, "modifier_elite_unit", {})
        caster.barrack_timer = caster.barrack_timer - 2
    elseif level == 3 then
        caster.barrack_timer = caster.barrack_timer - 1
        ability:SetHidden(true)
    end

    if _G.playersinfo[id].race == 1 then
        caster:SetHPRegenGain(0.25)
        if level == 1 then
            if caster.units["npc_dota_treants_melee"] then
                caster.units["npc_dota_treants_melee"] = caster.units["npc_dota_treants_melee"] + 1
            else
                caster.units["npc_dota_treants_melee_v2"] = caster.units["npc_dota_treants_melee_v2"] + 1
            end
            caster.units["npc_dota_treants_arme"] = 2
            caster:AddItemByName("item_treants_arme")
        elseif level == 2 then
            caster.units["npc_dota_treants_range"] = caster.units["npc_dota_treants_range"] + 1
            --caster.units["npc_dota_treants_mage"] = caster.units["npc_dota_treants_mage"] + 1
            caster.units["npc_dota_treants_air"] = 1
            caster:AddItemByName("item_treants_air")
        elseif level == 3 then
            --caster.units["npc_dota_treants_arme"] = caster.units["npc_dota_treants_arme"] + 1
            --if caster.units["npc_dota_treants_melee"] then
            --    caster.units["npc_dota_treants_melee"] = caster.units["npc_dota_treants_melee"] + 1
            --else
            --    caster.units["npc_dota_treants_melee_v2"] = caster.units["npc_dota_treants_melee_v2"] + 1
            --end
            caster.units["npc_dota_treants_siege"] = 1
            caster:AddItemByName("item_treants_siege")
        end
    elseif _G.playersinfo[id].race == 2 then
        if level == 1 then
            caster.units["npc_dota_undead_melee"] = caster.units["npc_dota_undead_melee"] + 1
            caster.units["npc_dota_undead_arme"] = 2
            caster:AddItemByName("item_undead_arme")
        elseif level == 2 then
            caster.units["npc_dota_undead_range"] = caster.units["npc_dota_undead_range"] + 1
            --caster.units["npc_dota_undead_mage"] = caster.units["npc_dota_undead_mage"] + 1
            if _G.playersinfo[id].spec.specpass and _G.playersinfo[id].spec.specpass:GetAbilityName() == "undead_spec_air_swap_pass" then
                caster.units["npc_dota_undead_air_spec"] = 1
                caster:AddItemByName("item_undead_air_spec")
            else
                caster.units["npc_dota_undead_air"] = 1
                caster:AddItemByName("item_undead_air")
            end
        elseif level == 3 then
            --caster.units["npc_dota_undead_arme"] = caster.units["npc_dota_undead_arme"] + 1
            --caster.units["npc_dota_undead_melee"] = caster.units["npc_dota_undead_melee"] + 1
            caster.units["npc_dota_undead_siege"] = 1
            caster:AddItemByName("item_undead_siege")
        end
    elseif _G.playersinfo[id].race == 3 then
        if level == 1 then
            caster.units["npc_dota_humans_melee"] = caster.units["npc_dota_humans_melee"] + 1
            caster.units["npc_dota_humans_arme"] = 2
            caster:AddItemByName("item_humans_arme")
        elseif level == 2 then
            caster.units["npc_dota_humans_range"] = caster.units["npc_dota_humans_range"] + 1
            --if caster.units["npc_dota_humans_mage"] then
            --    caster.units["npc_dota_humans_mage"] = caster.units["npc_dota_humans_mage"] + 1
            --else
            --    caster.units["npc_dota_humans_mage_spec"] = caster.units["npc_dota_humans_mage_spec"] + 1
            --end
            caster.units["npc_dota_humans_air"] = 1
            caster:AddItemByName("item_humans_air")
        elseif level == 3 then
            --caster.units["npc_dota_humans_arme"] = caster.units["npc_dota_humans_arme"] + 1
            --caster.units["npc_dota_humans_melee"] = caster.units["npc_dota_humans_melee"] + 1
            if _G.playersinfo[id].spec.specpass and _G.playersinfo[id].spec.specpass:GetAbilityName() == "humans_spec_siege_swap_pass" then
                caster.units["npc_dota_humans_morph"] = 1
                caster:AddItemByName("item_humans_morph")
            else
                caster.units["npc_dota_humans_siege"] = 1
                caster:AddItemByName("item_humans_siege")
            end
        end
    elseif _G.playersinfo[id].race == 4 then
        if level == 1 then
            caster.units["npc_dota_orcs_melee"] = caster.units["npc_dota_orcs_melee"] + 1
            caster.units["npc_dota_orcs_arme"] = 2
            caster:AddItemByName("item_orcs_arme")
        elseif level == 2 then
            caster.units["npc_dota_orcs_range"] = caster.units["npc_dota_orcs_range"] + 1
            --caster.units["npc_dota_orcs_mage"] = caster.units["npc_dota_orcs_mage"] + 1
            caster.units["npc_dota_orcs_air"] = 1
            caster:AddItemByName("item_orcs_air")
        elseif level == 3 then
            --caster.units["npc_dota_orcs_arme"] = caster.units["npc_dota_orcs_arme"] + 1
            --caster.units["npc_dota_orcs_melee"] = caster.units["npc_dota_orcs_melee"] + 1
            if _G.playersinfo[id].spec.specpass and _G.playersinfo[id].spec.specpass:GetAbilityName() == "orcs_spec_siege_swap_pass" then
                caster.units["npc_dota_orcs_siege_spec"] = 1
                caster:AddItemByName("item_orcs_siege_spec")
            else
                caster.units["npc_dota_orcs_siege"] = 1
                caster:AddItemByName("item_orcs_siege")
            end
        end
    elseif _G.playersinfo[id].race == 5 then
        hp_gain = 810
        if level == 1 then
            caster.units["npc_dota_dwarfs_melee"] = caster.units["npc_dota_dwarfs_melee"] + 1
            caster.units["npc_dota_dwarfs_arme"] = 2
            caster:AddItemByName("item_dwarfs_arme")
        elseif level == 2 then
            caster.units["npc_dota_dwarfs_range"] = caster.units["npc_dota_dwarfs_range"] + 1
            --caster.units["npc_dota_dwarfs_mage"] = caster.units["npc_dota_dwarfs_mage"] + 1
            caster.units["npc_dota_dwarfs_air"] = 1
            caster:AddItemByName("item_dwarfs_air")
        elseif level == 3 then
            --caster.units["npc_dota_dwarfs_arme"] = caster.units["npc_dota_dwarfs_arme"] + 1
            --caster.units["npc_dota_dwarfs_melee"] = caster.units["npc_dota_dwarfs_melee"] + 1
            caster.units["npc_dota_dwarfs_siege"] = 1
            caster:AddItemByName("item_dwarfs_siege")
        end
    elseif _G.playersinfo[id].race == 6 then
        if level == 1 then
            caster.units["npc_dota_elves_melee"] = caster.units["npc_dota_elves_melee"] + 1
            caster.units["npc_dota_elves_arme"] = 2
            caster:AddItemByName("item_elves_arme")
        elseif level == 2 then
            caster.units["npc_dota_elves_range"] = caster.units["npc_dota_elves_range"] + 1
            --if caster.units["npc_dota_elves_mage"] then
            --    caster.units["npc_dota_elves_mage"] = caster.units["npc_dota_elves_mage"] + 1
            --else
            --    caster.units["npc_dota_elves_mage_spec"] = caster.units["npc_dota_elves_mage_spec"] + 1
            --end
            if _G.playersinfo[id].spec.specpass and _G.playersinfo[id].spec.specpass:GetAbilityName() == "elves_spec_air_swap_pass" then
                caster.units["npc_dota_elves_air_spec"] = 1
                caster:AddItemByName("item_elves_air_spec")
            else
                caster.units["npc_dota_elves_air"] = 1
                caster:AddItemByName("item_elves_air")
            end
        elseif level == 3 then
            --caster.units["npc_dota_elves_arme"] = caster.units["npc_dota_elves_arme"] + 1
            --caster.units["npc_dota_elves_melee"] = caster.units["npc_dota_elves_melee"] + 1
            caster.units["npc_dota_elves_siege"] = 1
            caster:AddItemByName("item_elves_siege")
        end
    elseif _G.playersinfo[id].race == 7 then
        if level == 1 then
            caster.units["npc_dota_spiders_melee"] = caster.units["npc_dota_spiders_melee"] + 1
            caster.units["npc_dota_spiders_arme"] = 2
            caster:AddItemByName("item_spiders_arme")
        elseif level == 2 then
            caster.units["npc_dota_spiders_range"] = caster.units["npc_dota_spiders_range"] + 1
            --caster.units["npc_dota_spiders_mage"] = caster.units["npc_dota_spiders_mage"] + 1
            if _G.playersinfo[id].spec.specpass and _G.playersinfo[id].spec.specpass:GetAbilityName() == "spiders_spec_air_swap_pass" then
                caster.units["npc_dota_spiders_air_spec"] = 1
                caster:AddItemByName("item_spiders_air_spec")
            else
                caster.units["npc_dota_spiders_air"] = 1
                caster:AddItemByName("item_spiders_air")
            end
        elseif level == 3 then
            --caster.units["npc_dota_spiders_arme"] = caster.units["npc_dota_spiders_arme"] + 1
            --caster.units["npc_dota_spiders_melee"] = caster.units["npc_dota_spiders_melee"] + 1
            caster.units["npc_dota_spiders_siege"] = 1
            caster:AddItemByName("item_spiders_siege")
        end
    elseif _G.playersinfo[id].race == 8 then
        if level == 1 then
            caster.units["npc_dota_nagas_melee"] = caster.units["npc_dota_nagas_melee"] + 1
            caster.units["npc_dota_nagas_arme"] = 2
            caster:AddItemByName("item_nagas_arme")
        elseif level == 2 then
            caster.units["npc_dota_nagas_range"] = caster.units["npc_dota_nagas_range"] + 1
            --caster.units["npc_dota_nagas_mage"] = caster.units["npc_dota_nagas_mage"] + 1
            caster.units["npc_dota_nagas_air"] = 1
            caster:AddItemByName("item_nagas_air")
        elseif level == 3 then
            --caster.units["npc_dota_nagas_arme"] = caster.units["npc_dota_nagas_arme"] + 1
            --caster.units["npc_dota_nagas_melee"] = caster.units["npc_dota_nagas_melee"] + 1
            caster.units["npc_dota_nagas_siege"] = 1
            caster:AddItemByName("item_nagas_siege")
        end
    elseif _G.playersinfo[id].race == 9 then
        if level == 1 then
            caster.units["npc_dota_demons_melee"] = caster.units["npc_dota_demons_melee"] + 1
            caster.units["npc_dota_demons_arme"] = 2
            caster:AddItemByName("item_demons_arme")
        elseif level == 2 then
            caster.units["npc_dota_demons_range"] = caster.units["npc_dota_demons_range"] + 1
            --caster.units["npc_dota_demons_mage"] = caster.units["npc_dota_demons_mage"] + 1
            caster.units["npc_dota_demons_air"] = 1
            caster:AddItemByName("item_demons_air")
        elseif level == 3 then
            --caster.units["npc_dota_demons_arme"] = caster.units["npc_dota_demons_arme"] + 1
            --caster.units["npc_dota_demons_melee"] = caster.units["npc_dota_demons_melee"] + 1
            caster.units["npc_dota_demons_siege"] = 1
            caster:AddItemByName("item_demons_siege")
        end
    elseif _G.playersinfo[id].race == 10 then
        if level == 1 then
            caster.units["npc_dota_elementals_melee"] = caster.units["npc_dota_elementals_melee"] + 1
            caster.units["npc_dota_elementals_arme"] = 2
            caster:AddItemByName("item_elementals_arme")
        elseif level == 2 then
            caster.units["npc_dota_elementals_range"] = caster.units["npc_dota_elementals_range"] + 1
            --caster.units["npc_dota_elementals_mage"] = caster.units["npc_dota_elementals_mage"] + 1
            caster.units["npc_dota_elementals_air"] = 1
            caster:AddItemByName("item_elementals_air")
        elseif level == 3 then
            --caster.units["npc_dota_elementals_arme"] = caster.units["npc_dota_elementals_arme"] + 1
            --caster.units["npc_dota_elementals_melee"] = caster.units["npc_dota_elementals_melee"] + 1
            caster.units["npc_dota_elementals_siege"] = 1
            caster:AddItemByName("item_elementals_siege")
        end
    elseif _G.playersinfo[id].race == 11 then
        if level == 1 then
            caster.units["npc_dota_diretide_melee"] = caster.units["npc_dota_diretide_melee"] + 1
            caster.units["npc_dota_diretide_arme"] = 2
            caster:AddItemByName("item_diretide_arme")
        elseif level == 2 then
            caster.units["npc_dota_diretide_range"] = caster.units["npc_dota_diretide_range"] + 1
            --caster.units["npc_dota_diretide_mage"] = caster.units["npc_dota_diretide_mage"] + 1
            caster.units["npc_dota_diretide_air"] = 1
            caster:AddItemByName("item_diretide_air")
        elseif level == 3 then
            --caster.units["npc_dota_diretide_arme"] = caster.units["npc_dota_diretide_arme"] + 1
            --caster.units["npc_dota_diretide_melee"] = caster.units["npc_dota_diretide_melee"] + 1
            caster.units["npc_dota_diretide_siege"] = 1
            caster:AddItemByName("item_diretide_siege")
        end
    elseif _G.playersinfo[id].race == 12 then
        if level == 1 then
            caster.units["npc_dota_frostivus_melee"] = caster.units["npc_dota_frostivus_melee"] + 1
            caster.units["npc_dota_frostivus_arme"] = 2
            caster:AddItemByName("item_frostivus_arme")
        elseif level == 2 then
            caster.units["npc_dota_frostivus_range"] = caster.units["npc_dota_frostivus_range"] + 1
            --caster.units["npc_dota_frostivus_mage"] = caster.units["npc_dota_frostivus_mage"] + 1
            caster.units["npc_dota_frostivus_air"] = 1
            caster:AddItemByName("item_frostivus_air")
        elseif level == 3 then
            --caster.units["npc_dota_frostivus_arme"] = caster.units["npc_dota_frostivus_arme"] + 1
            --caster.units["npc_dota_frostivus_melee"] = caster.units["npc_dota_frostivus_melee"] + 1
            caster.units["npc_dota_frostivus_siege"] = 1
            caster:AddItemByName("item_frostivus_siege")
        end
    elseif _G.playersinfo[id].race == 13 then
        if level == 1 then
            caster.units["npc_dota_dragons_melee"] = caster.units["npc_dota_dragons_melee"] + 1
            caster.units["npc_dota_dragons_arme"] = 2
            caster:AddItemByName("item_dragons_arme")
        elseif level == 2 then
            caster.units["npc_dota_dragons_range"] = caster.units["npc_dota_dragons_range"] + 1
            --caster.units["npc_dota_dragons_mage"] = caster.units["npc_dota_dragons_mage"] + 1
            caster.units["npc_dota_dragons_air"] = 1
            caster:AddItemByName("item_dragons_air")
        elseif level == 3 then
            --caster.units["npc_dota_dragons_arme"] = caster.units["npc_dota_dragons_arme"] + 1
            --caster.units["npc_dota_dragons_melee"] = caster.units["npc_dota_dragons_melee"] + 1
            caster.units["npc_dota_dragons_siege"] = 1
            caster:AddItemByName("item_dragons_siege")
        end
    elseif _G.playersinfo[id].race == 14 then
        if level == 1 then
            caster.units["npc_dota_beastmen_melee"] = caster.units["npc_dota_beastmen_melee"] + 1
            caster.units["npc_dota_beastmen_arme"] = 2
            caster:AddItemByName("item_beastmen_arme")
        elseif level == 2 then
            caster.units["npc_dota_beastmen_range"] = caster.units["npc_dota_beastmen_range"] + 1
            --caster.units["npc_dota_beastmen_mage"] = caster.units["npc_dota_beastmen_mage"] + 1
            caster.units["npc_dota_beastmen_air"] = 1
            caster:AddItemByName("item_beastmen_air")
        elseif level == 3 then
            --caster.units["npc_dota_beastmen_arme"] = caster.units["npc_dota_beastmen_arme"] + 1
            --caster.units["npc_dota_beastmen_melee"] = caster.units["npc_dota_beastmen_melee"] + 1
            caster.units["npc_dota_beastmen_siege"] = 1
            caster:AddItemByName("item_beastmen_siege")
        end
    elseif _G.playersinfo[id].race == 15 then
        if level == 1 then
            caster.units["npc_dota_primordials_melee"] = caster.units["npc_dota_primordials_melee"] + 1
            caster.units["npc_dota_primordials_arme"] = 2
            caster:AddItemByName("item_primordials_arme")
        elseif level == 2 then
            caster.units["npc_dota_primordials_range"] = caster.units["npc_dota_primordials_range"] + 1
            --caster.units["npc_dota_primordials_mage"] = caster.units["npc_dota_primordials_mage"] + 1
            caster.units["npc_dota_primordials_air"] = 1
            caster:AddItemByName("item_primordials_air")
        elseif level == 3 then
            --caster.units["npc_dota_primordials_arme"] = caster.units["npc_dota_primordials_arme"] + 1
            --caster.units["npc_dota_primordials_melee"] = caster.units["npc_dota_primordials_melee"] + 1
            caster.units["npc_dota_primordials_siege"] = 1
            caster:AddItemByName("item_primordials_siege")
        end
    elseif _G.playersinfo[id].race == 16 then
        if level == 1 then
            caster.units["npc_dota_invaders_melee"] = caster.units["npc_dota_invaders_melee"] + 1
            caster.units["npc_dota_invaders_arme"] = 2
            caster:AddItemByName("item_invaders_arme")
        elseif level == 2 then
            caster.units["npc_dota_invaders_range"] = caster.units["npc_dota_invaders_range"] + 1
            --caster.units["npc_dota_invaders_mage"] = caster.units["npc_dota_invaders_mage"] + 1
            caster.units["npc_dota_invaders_air"] = 1
            caster:AddItemByName("item_invaders_air")
        elseif level == 3 then
            --caster.units["npc_dota_invaders_arme"] = caster.units["npc_dota_invaders_arme"] + 1
            --caster.units["npc_dota_invaders_melee"] = caster.units["npc_dota_invaders_melee"] + 1
            caster.units["npc_dota_invaders_siege"] = 1
            caster:AddItemByName("item_invaders_siege")
        end
    elseif _G.playersinfo[id].race == 17 then
        if level == 1 then
            if _G.playersinfo[id].spec.specpass and _G.playersinfo[id].spec.specpass:GetAbilityName() == "cultists_spec_arme_swap_pass" then
                caster.units["npc_dota_cultists_arme_spec"] = 2
                caster:AddItemByName("item_cultists_arme_spec")
            else
                caster.units["npc_dota_cultists_arme"] = 2
                caster:AddItemByName("item_cultists_arme")
            end
            caster.units["npc_dota_cultists_melee"] = caster.units["npc_dota_cultists_melee"] + 1
        elseif level == 2 then
            caster.units["npc_dota_cultists_range"] = caster.units["npc_dota_cultists_range"] + 1
            --caster.units["npc_dota_cultists_mage"] = caster.units["npc_dota_cultists_mage"] + 1
            caster.units["npc_dota_cultists_air"] = 1
            caster:AddItemByName("item_cultists_air")
        elseif level == 3 then
            --if _G.playersinfo[id].spec.specpass and _G.playersinfo[id].spec.specpass:GetAbilityName() == "cultists_spec_arme_swap_pass" then
            --    caster.units["npc_dota_cultists_arme_spec"] = caster.units["npc_dota_cultists_arme_spec"] + 1
            --else
            --    caster.units["npc_dota_cultists_arme"] = caster.units["npc_dota_cultists_arme"] + 1
            --end
            --caster.units["npc_dota_cultists_melee"] = caster.units["npc_dota_cultists_melee"] + 1
            caster.units["npc_dota_cultists_siege"] = 1
            caster:AddItemByName("item_cultists_siege")
        end
    elseif _G.playersinfo[id].race == 18 then
        if level == 1 then
            if caster.units["npc_dota_pirates_melee"] then
                caster.units["npc_dota_pirates_melee"] = caster.units["npc_dota_pirates_melee"] + 1
            else
                caster.units["npc_dota_pirates_melee_spec"] = caster.units["npc_dota_pirates_melee_spec"] + 1
            end
            caster.units["npc_dota_pirates_arme"] = 2
            caster:AddItemByName("item_pirates_arme")
        elseif level == 2 then
            caster.units["npc_dota_pirates_range"] = caster.units["npc_dota_pirates_range"] + 1
            --caster.units["npc_dota_pirates_mage"] = caster.units["npc_dota_pirates_mage"] + 1
            caster.units["npc_dota_pirates_air"] = 1
            caster:AddItemByName("item_pirates_air")
        elseif level == 3 then
            --caster.units["npc_dota_pirates_arme"] = caster.units["npc_dota_pirates_arme"] + 1
            --if caster.units["npc_dota_pirates_melee"] then
            --    caster.units["npc_dota_pirates_melee"] = caster.units["npc_dota_pirates_melee"] + 1
            --else
            --    caster.units["npc_dota_pirates_melee_spec"] = caster.units["npc_dota_pirates_melee_spec"] + 1
            --end
            caster.units["npc_dota_pirates_siege"] = 1
            caster:AddItemByName("item_pirates_siege")
        end
    elseif _G.playersinfo[id].race == 19 then
        if level == 1 then
            if caster.units["npc_dota_nights_melee"] then
                caster.units["npc_dota_nights_melee"] = caster.units["npc_dota_nights_melee"] + 1
            else
                caster.units["npc_dota_nights_melee_spec"] = caster.units["npc_dota_nights_melee_spec"] + 1
            end
            caster.units["npc_dota_nights_arme"] = 2
            caster:AddItemByName("item_nights_arme")
        elseif level == 2 then
            caster.units["npc_dota_nights_range"] = caster.units["npc_dota_nights_range"] + 1
            --caster.units["npc_dota_nights_mage"] = caster.units["npc_dota_nights_mage"] + 1
            caster.units["npc_dota_nights_air"] = 1
            caster:AddItemByName("item_nights_air")
        elseif level == 3 then
            --caster.units["npc_dota_nights_arme"] = caster.units["npc_dota_nights_arme"] + 1
            --if caster.units["npc_dota_nights_melee"] then
            --    caster.units["npc_dota_nights_melee"] = caster.units["npc_dota_nights_melee"] + 1
            --else
            --    caster.units["npc_dota_nights_melee_spec"] = caster.units["npc_dota_nights_melee_spec"] + 1
            --end
            caster.units["npc_dota_nights_siege"] = 1
            caster:AddItemByName("item_nights_siege")
        end
    end
    caster:SetHPGain(hp_gain)
    caster:SetArmorGain(2)
    local health_prc = caster:GetHealthPercent()
    if health_prc <= 0 then
        health_prc = 1
    end
    local current_hp = caster:GetHealth()
    caster:CreatureLevelUp(1)
    caster:SetHealth(current_hp + hp_gain)
    ability:SetLevel(level+1)
    FireGameEvent("building_upgrade", {building = caster:entindex()})
end