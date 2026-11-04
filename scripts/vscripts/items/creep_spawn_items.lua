LinkLuaModifier( "creep_spawn_items_mod", "items/creep_spawn_items.lua", LUA_MODIFIER_MOTION_NONE )
creep_spawn_items_mod = class({})

function creep_spawn_items_mod:OnCreated( kv )
    if IsServer() then
        self:GetAbility():OnEquipped()
    end
end

function creep_spawn_items_mod:IsHidden()
    return true
end

function creep_spawn_items_mod:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

--------------------------------------------------------------------------------

function SpawnUnit(event)
    local caster = event.caster
    local team = caster:GetTeam()
    local owner = caster:GetOwner()
    local unit = CreateUnitByName(event.unit_name, caster.creepspawnpoint, true, owner, owner, team)
    if unit:IsRangedAttacker() then
        FindClearSpaceForUnit(unit, event.caster.herospawnpoint, false)
    end
    if caster.mid_barrack and not _G.duos then
        unit:SetMinimumGoldBounty(unit:GetMinimumGoldBounty() * caster.mid_barrack_gold_bounty_mult)
        unit:SetMaximumGoldBounty(unit:GetMaximumGoldBounty() * caster.mid_barrack_gold_bounty_mult)
        unit:SetDeathXP(unit:GetDeathXP() * caster.mid_barrack_exp_bounty_mult)
    end
    return unit
end

--------------------------------------------------------------------------------

    item_class = class({})
    item_class.creep_spawn_item = true

    function item_class:OnEquipped( )
        if IsServer() then
            self.charge_restore_time = self:GetSpecialValueFor("charge_restore_time")
            if self:GetParent():HasModifier("modifiers_nagas_spec_mutated_carapace_pass") then
                self.charge_restore_time = self.charge_restore_time * 0.6
            end
            self.max_charges = self:GetSpecialValueFor("max_charges")
            if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
                self:StartGame()
            else
                table.insert(_G.onstartgame, self)
            end
        end
    end

    function item_class:StartGame()
        if IsServer() then
            Timers:CreateTimer(self.charge_restore_time, function()
                if self and not self:IsNull() then
                    if self:GetCurrentCharges() < self.max_charges then
                        self:SetCurrentCharges(self:GetCurrentCharges()+1)
                        if self:GetCurrentCharges() < self.max_charges then
                            return self.charge_restore_time
                        end
                    end
                end
            end)
        end
    end

    function item_class:OnSpellStart()
        if IsServer() then
            if self:GetCurrentCharges() == self.max_charges then
                self:StartGame()
            end
            self:SetCurrentCharges(self:GetCurrentCharges()-1)
            local data = {}
            data.caster = self:GetCaster()
            data.unit_name = "npc_dota_"..string.sub(self:GetAbilityName(),6)
            local unit = SpawnUnit(data)
            data.item = self
            --Challenges:TriggerEvent(data.caster:GetPlayerOwnerID(), "spawn_creep", data)
            FireGameEvent("custom_spawn_unit", {spawner_unit = data.caster:entindex(), spawner_ability = self:entindex(), unit = unit:entindex()})
        end
    end

    function item_class:GetIntrinsicModifierName()
        return "creep_spawn_items_mod"
    end

--Treants
--------------------------------------------------------------------------------

    item_treants_melee = item_class
    item_treants_melee_v2 = item_class
    item_treants_range = item_class
    item_treants_mage = item_class
    item_treants_arme = item_class
    item_treants_air = item_class
    item_treants_siege = item_class

--Undead
--------------------------------------------------------------------------------

    item_undead_melee = item_class
    item_undead_range = item_class
    item_undead_melee_v2 = item_class
    item_undead_mage = item_class
    item_undead_mage_spec = item_class
    item_undead_arme = item_class
    item_undead_air = item_class
    item_undead_air_spec = item_class
    item_undead_siege = item_class

--Humans
--------------------------------------------------------------------------------

    item_humans_melee = item_class
    item_humans_range = item_class
    item_humans_mage = item_class
    item_humans_mage_spec = item_class
    item_humans_arme = item_class
    item_humans_air = item_class
    item_humans_siege = item_class
    item_humans_morph = item_class

--Orcs
--------------------------------------------------------------------------------

    item_orcs_melee = item_class
    item_orcs_range = item_class
    item_orcs_mage = item_class
    item_orcs_arme = item_class
    item_orcs_air = item_class
    item_orcs_siege = item_class
    item_orcs_siege_spec = item_class

--Dwarfs
--------------------------------------------------------------------------------

    item_dwarfs_melee = item_class
    item_dwarfs_range = item_class
    item_dwarfs_mage = item_class
    item_dwarfs_arme = item_class
    item_dwarfs_air = item_class
    item_dwarfs_siege = item_class

--Elves
--------------------------------------------------------------------------------

    item_elves_melee = item_class
    item_elves_range = item_class
    item_elves_mage = item_class
    item_elves_mage_spec = item_class
    item_elves_arme = item_class
    item_elves_air = item_class
    item_elves_air_spec = item_class
    item_elves_siege = item_class

--Spiders
--------------------------------------------------------------------------------

    item_spiders_melee = item_class
    item_spiders_range = item_class
    item_spiders_mage = item_class
    item_spiders_arme = item_class
    item_spiders_air = item_class
    item_spiders_air_spec = item_class
    item_spiders_siege = item_class

--Nagas
--------------------------------------------------------------------------------

    item_nagas_melee = item_class
    item_nagas_range = item_class
    item_nagas_mage = item_class
    item_nagas_arme = item_class
    item_nagas_air = item_class
    item_nagas_siege = item_class

--Demons
--------------------------------------------------------------------------------

    item_demons_melee = item_class
    item_demons_range = item_class
    item_demons_mage = item_class
    item_demons_arme = item_class
    item_demons_air = item_class
    item_demons_siege = item_class

--Elementals
--------------------------------------------------------------------------------

    item_elementals_melee = item_class
    item_elementals_range = item_class
    item_elementals_mage = item_class
    item_elementals_arme = item_class
    item_elementals_air = item_class
    item_elementals_siege = item_class

--Diretide
--------------------------------------------------------------------------------

    item_diretide_melee = item_class
    item_diretide_range = item_class
    item_diretide_mage = item_class
    item_diretide_arme = item_class
    item_diretide_air = item_class
    item_diretide_siege = item_class

--Frostivus
--------------------------------------------------------------------------------

    item_frostivus_melee = item_class
    item_frostivus_range = item_class
    item_frostivus_mage = item_class
    item_frostivus_arme = item_class
    item_frostivus_air = item_class
    item_frostivus_siege = item_class

--Dragons
--------------------------------------------------------------------------------

    item_dragons_melee = item_class
    item_dragons_range = item_class
    item_dragons_mage = item_class
    item_dragons_arme = item_class
    item_dragons_air = item_class
    item_dragons_siege = item_class

--Beastmen
--------------------------------------------------------------------------------

    item_beastmen_melee = item_class
    item_beastmen_range = item_class
    item_beastmen_mage = item_class
    item_beastmen_arme = item_class
    item_beastmen_air = item_class
    item_beastmen_siege = item_class

--Primordials
--------------------------------------------------------------------------------

    item_primordials_melee = item_class
    item_primordials_range = item_class
    item_primordials_mage = item_class
    item_primordials_arme = item_class
    item_primordials_air = item_class
    item_primordials_siege = item_class

--Invaders
--------------------------------------------------------------------------------

    item_invaders_melee = item_class
    item_invaders_range = item_class
    item_invaders_mage = item_class
    item_invaders_arme = item_class
    item_invaders_air = item_class
    item_invaders_siege = item_class

--Cultists
--------------------------------------------------------------------------------

    item_cultists_melee = item_class
    item_cultists_range = item_class
    item_cultists_mage = item_class
    item_cultists_arme = item_class
    item_cultists_arme_spec = item_class
    item_cultists_air = item_class
    item_cultists_siege = item_class

--Pirates
--------------------------------------------------------------------------------

    item_pirates_melee = item_class
    item_pirates_melee_spec = item_class
    item_pirates_range = item_class
    item_pirates_mage = item_class
    item_pirates_arme = item_class
    item_pirates_air = item_class
    item_pirates_siege = item_class

--Nigts
--------------------------------------------------------------------------------

    item_nights_melee = item_class
    item_nights_melee_spec = item_class
    item_nights_range = item_class
    item_nights_mage = item_class
    item_nights_arme = item_class
    item_nights_air = item_class
    item_nights_siege = item_class