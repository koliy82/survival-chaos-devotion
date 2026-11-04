LinkLuaModifier( "modifier_ultimate_abilities_magic_resist", "abilities/ultimate_abilities", LUA_MODIFIER_MOTION_NONE )

modifier_ultimate_abilities_magic_resist = class({})

function modifier_ultimate_abilities_magic_resist:IsHidden()
    
end

function modifier_ultimate_abilities_magic_resist:OnCreated(table)
    if IsServer() then
        self:GetParent().custom_damage_reduction[6] = self:GetParent().custom_damage_reduction[6] - 0.4
    end
end

function modifier_ultimate_abilities_magic_resist:OnDestroy()
    if IsServer() then
        self:GetParent().custom_damage_reduction[6] = self:GetParent().custom_damage_reduction[6] + 0.4
    end
end

--------------------------------------------------------------------------------

function OnChannelSucceededResearch(event)
    local caster = event.caster
    local player = caster:GetPlayerOwner()
    if caster:GetLevel() > 2 then
        local id = player:GetPlayerID()
        local team = caster:GetTeam()
        _G.playersinfo[id].ancient:RemoveAbility("ancient_research_ultimate_ability")
        _G.playersinfo[id].ancient.ult_abil = nil
        _G.playersinfo[id].ancient:AddAbility("ancient_select_ultimate_ability"):SetLevel(1)

        --AddFOWViewer(team, Entities:FindByName( nil, "corner9"):GetAbsOrigin(), 99999, 99999, true)
        --for i=1,#_G.additional_building_triggers do
        --    AddFOWViewer(team, _G.additional_building_triggers[i]:GetAbsOrigin(), 99999, 99999, true)
        --end
        for i=1, 4 do
            AddFOWViewer(team, Entities:FindByName( nil, "base_1_"..i):GetAbsOrigin(), 10, 99999, true)
            AddFOWViewer(team, Entities:FindByName( nil, "barack_1_"..i):GetAbsOrigin(), 10, 99999, true)
            AddFOWViewer(team, Entities:FindByName( nil, "barack_2_"..i):GetAbsOrigin(), 10, 99999, true)
            AddFOWViewer(team, Entities:FindByName( nil, "barack_3_"..i):GetAbsOrigin(), 10, 99999, true)
            AddFOWViewer(team, Entities:FindByName( nil, "tower_1_"..i):GetAbsOrigin(), 10, 99999, true)
            AddFOWViewer(team, Entities:FindByName( nil, "tower_2_"..i):GetAbsOrigin(), 10, 99999, true)
            AddFOWViewer(team, Entities:FindByName( nil, "tower_3_"..i):GetAbsOrigin(), 10, 99999, true)
            AddFOWViewer(team, Entities:FindByName( nil, "tower_4_"..i):GetAbsOrigin(), 10, 99999, true)
        end
    else
        CustomGameEventManager:Send_ServerToPlayer(player, "display_custom_error", { message = "#need_ancient_level_3" })
    end
end

function OnSpellStartSelect(event)
    local caster = event.caster
    local player = caster:GetPlayerOwner()
    local id = caster:GetPlayerOwnerID()
    if caster:GetLevel() > 2 then
        CustomGameEventManager:Send_ServerToPlayer(player, "OpenSelectAbil", {mode = "ult", lvls = {_G.playersinfo[id].item_melee_upgrade, _G.playersinfo[id].item_range_upgrade, _G.playersinfo[id].item_armor_upgrade, _G.playersinfo[id].item_buildings_upgrade, _G.playersinfo[id].item_mage_upgrade}})
    else
        CustomGameEventManager:Send_ServerToPlayer(player, "display_custom_error", { message = "#need_ancient_level_3" })
    end
end

function BuyMana(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()
	local mana = ability:GetLevelSpecialValueFor("mana", level)
    
    if ability.flag ~= true then
        caster:GiveMana(mana)
        ability.flag = true
    else
        caster:GiveMana(mana)
        caster:RemoveAbility("ancient_buy_mana")
    end
end
--Challenges:TriggerEvent(caster:GetPlayerOwnerID(), "buy_mana", {})

function UseUltimate(event)
    local caster = event.caster
    local ability = event.ability
    
    Timers:CreateTimer(0.1, function()
        if not ability:IsCooldownReady() then
            local gameEvent = {}
            gameEvent["player_id"] = caster:GetPlayerOwnerID()
            gameEvent["teamnumber"] = -1
            gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_" .. ability:GetAbilityName()
            gameEvent["message"] = "#Combat_Message_use_ultimate"
            FireGameEvent( "dota_combat_event_message", gameEvent )
        end
    end)
end

function UltimateSpellShield(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()
    local level = ability:GetLevel()
	local shield_absorb = ability:GetLevelSpecialValueFor("shield_absorb", level)
	local duration = ability:GetLevelSpecialValueFor("duration", level)
    
    local caster_mod = caster:AddBarrier(shield_absorb, 6, duration, caster, ability)
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:AddBarrier(shield_absorb, 6, duration, caster, ability)
	end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:AddBarrier(shield_absorb, 6, duration, caster, ability)
	end
    local shieldParticle = ParticleManager:CreateParticle("particles/new/spell_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(shieldParticle, 1, Vector(800,0,0))
    caster_mod:AddParticle(shieldParticle, false, false, 0, false, false)
end

function UltimateManaShield(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()
    local id = caster:GetPlayerOwnerID()
	local damage_per_mana = ability:GetLevelSpecialValueFor("damage_per_mana", level)
	local duration = ability:GetLevelSpecialValueFor("duration", level)
    
    caster:AddBarrier(damage_per_mana, 0, duration, caster, ability)
    for _, v in pairs(_G.playersinfo[id].baracks) do
        v:AddBarrier(damage_per_mana, 0, duration, caster, ability)
	end
    for _, v in pairs(_G.playersinfo[id].towers) do
        v:AddBarrier(damage_per_mana, 0, duration, caster, ability)
	end
end

function UltimateManaBurn(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target
    local level = ability:GetLevel()
	local mana_burn = ability:GetLevelSpecialValueFor("mana_burn", level)
	local burn_particle_name = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf"
    
    if target:IsAncient() and target:GetMaxMana() > 0 then
        --target:ReduceMana( mana_burn )
        local target_mana = target:GetMana()
        if target_mana <= mana_burn then
            target:SetMana(0)
        else
            target:SpendMana(mana_burn, ability)
        end
        ParticleManager:CreateParticle( burn_particle_name, PATTACH_ABSORIGIN, target )
    else
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#dota_hud_error_cant_cast_on_other" })
        ability:RefundManaCost()
        ability:EndCooldown()
    end
end

function UltimateManaDrain(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target
    
    if target:IsAncient() and target:GetMaxMana() > 0 then
        ability:ApplyDataDrivenModifier( caster, target, "modifier_ancient_ultimate_mana_drain", {} )
    else
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#dota_hud_error_cant_cast_on_other" })
        ability:RefundManaCost()
        ability:EndCooldown()
    end
end

function UltimateManaDrainThink(event)
	local caster = event.caster
	local target = event.target
    local ability = event.ability
    
    if caster == nil or caster:IsNull() or not caster:IsAlive() then
        target:RemoveModifierByNameAndCaster("modifier_ancient_ultimate_mana_drain", caster)
        return
    end

	-- Mana calculation
	local mana_drain = ability:GetLevelSpecialValueFor("mana_per_sec", (ability:GetLevel() - 1))
	local target_mana = target:GetMana()

	-- Mana drain part
	-- If the target has enough mana then drain the maximum amount
	-- otherwise drain whatever is left
	if target_mana >= mana_drain then
		--target:ReduceMana(mana_drain)
        target:SpendMana(mana_drain, ability)
		caster:GiveMana(mana_drain)
	else
		--target:ReduceMana(target_mana)
        target:SpendMana(target_mana, ability)
		caster:GiveMana(target_mana)
	end
end

function UltimateRepair(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target
	local repair = ability:GetLevelSpecialValueFor("repair", (ability:GetLevel() - 1))
    
    if target:IsAncient() then
        target:Heal(repair, caster)
    else
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#dota_hud_error_cant_cast_on_other" })
        ability:RefundManaCost()
        ability:EndCooldown()
    end
end

function UltimateDamageBuild(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
    
    if target:IsAncient() then
        local partindx = ParticleManager:CreateParticle( "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf", PATTACH_ABSORIGIN, caster )
        ParticleManager:SetParticleControl(partindx, 0, target:GetAbsOrigin())
        ApplyCustomDamage(target, caster, damage, 6, ability)
        if target and target:IsAlive() and not target:IsInvulnerable() then
            target:AddNewModifier(caster, ability, "modifier_ultimate_abilities_magic_resist", {duration = 60})
        end
    else
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#dota_hud_error_cant_cast_on_other" })
        ability:RefundManaCost()
        ability:EndCooldown()
    end
end

function UltimateDamagePlayer(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target
    local part = "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf"
    local id = target:GetPlayerOwnerID()
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
    
    if _G.playersinfo[id].ancient then
        local partindx = ParticleManager:CreateParticle( part, PATTACH_ABSORIGIN, caster )
        ParticleManager:SetParticleControl(partindx, 0, _G.playersinfo[id].ancient:GetAbsOrigin())
        ApplyCustomDamage(_G.playersinfo[id].ancient, caster, damage, 6, ability)
        if _G.playersinfo[id].ancient and _G.playersinfo[id].ancient:IsAlive() and not _G.playersinfo[id].ancient:IsInvulnerable() then
            _G.playersinfo[id].ancient:AddNewModifier(caster, ability, "modifier_ultimate_abilities_magic_resist", {duration = 180})
        end
    end
    for k, v in pairs(_G.playersinfo[id].baracks) do
        -- partindx = ParticleManager:CreateParticle( part, PATTACH_ABSORIGIN, caster )
        -- ParticleManager:SetParticleControl(partindx, 0, v:GetAbsOrigin())
        ApplyCustomDamage(v, caster, damage, 6, ability)
        if v and v:IsAlive() and not v:IsInvulnerable() then
            v:AddNewModifier(caster, ability, "modifier_ultimate_abilities_magic_resist", {duration = 180})
        end
	end
    for k, v in pairs(_G.playersinfo[id].towers) do
        -- partindx = ParticleManager:CreateParticle( part, PATTACH_ABSORIGIN, caster )
        -- ParticleManager:SetParticleControl(partindx, 0, v:GetAbsOrigin())
        ApplyCustomDamage(v, caster, damage, 6, ability)
        if v and v:IsAlive() and not v:IsInvulnerable() then
            v:AddNewModifier(caster, ability, "modifier_ultimate_abilities_magic_resist", {duration = 180})
        end
	end
end

function UltimateDamageEnemies(event)
    local caster = event.caster
    local ability = event.ability
    local part = "particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_egset.vpcf"
    local casterid = caster:GetPlayerOwnerID()
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
    
    for id, _ in pairs(_G.playersinfo) do
        if PlayerResource:GetTeam(id) ~= PlayerResource:GetTeam(casterid) then
            if _G.playersinfo[id].ancient then
                local partindx = ParticleManager:CreateParticle( part, PATTACH_ABSORIGIN, caster )
                ParticleManager:SetParticleControl(partindx, 0, _G.playersinfo[id].ancient:GetAbsOrigin())
                ParticleManager:SetParticleControl(partindx, 1, Vector(1000,0,0))
                ApplyCustomDamage(_G.playersinfo[id].ancient, caster, damage, 6, ability)
            end
            for k, v in pairs(_G.playersinfo[id].baracks) do
                -- partindx = ParticleManager:CreateParticle( part, PATTACH_ABSORIGIN, caster )
                -- ParticleManager:SetParticleControl(partindx, 0, v:GetAbsOrigin())
                ApplyCustomDamage(v, caster, damage, 6, ability)
            end
            for k, v in pairs(_G.playersinfo[id].towers) do
                -- partindx = ParticleManager:CreateParticle( part, PATTACH_ABSORIGIN, caster )
                -- ParticleManager:SetParticleControl(partindx, 0, v:GetAbsOrigin())
                ApplyCustomDamage(v, caster, damage, 6, ability)
            end
        end
    end
end

function UltimateDamageAll(event)
    local caster = event.caster
    local ability = event.ability
    local part = "particles/econ/items/lina/lina_ti7/lina_spell_light_strike_array_ti7.vpcf"
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))
    
    for id, _ in pairs(_G.playersinfo) do
        if _G.playersinfo[id].ancient then
            local partindx = ParticleManager:CreateParticle( part, PATTACH_ABSORIGIN, caster )
            ParticleManager:SetParticleControl(partindx, 0, _G.playersinfo[id].ancient:GetAbsOrigin())
            ParticleManager:SetParticleControl(partindx, 1, Vector(800,0,0))
            ApplyCustomDamage(_G.playersinfo[id].ancient, caster, damage, 6, ability)
        end
        for k, v in pairs(_G.playersinfo[id].baracks) do
            -- partindx = ParticleManager:CreateParticle( part, PATTACH_ABSORIGIN, caster )
            -- ParticleManager:SetParticleControl(partindx, 0, v:GetAbsOrigin())
            ApplyCustomDamage(v, caster, damage, 6, ability)
        end
        for k, v in pairs(_G.playersinfo[id].towers) do
            -- partindx = ParticleManager:CreateParticle( part, PATTACH_ABSORIGIN, caster )
            -- ParticleManager:SetParticleControl(partindx, 0, v:GetAbsOrigin())
            ApplyCustomDamage(v, caster, damage, 6, ability)
        end
    end
end

function OnCreated_ultimate_damage_all(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()

    if _G.playersinfo[id].ancient then
        ability:ApplyDataDrivenModifier(caster, _G.playersinfo[id].ancient, "modifier_ancient_ultimate_damage_all_buff", {})
	end
    for k, v in pairs(_G.playersinfo[id].baracks) do
        ability:ApplyDataDrivenModifier(caster, v, "modifier_ancient_ultimate_damage_all_buff", {})
	end
    for k, v in pairs(_G.playersinfo[id].towers) do
        ability:ApplyDataDrivenModifier(caster, v, "modifier_ancient_ultimate_damage_all_buff", {})
	end
end

function OnDestroy_ultimate_damage_all(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()

    if _G.playersinfo[id].ancient then
        _G.playersinfo[id].ancient:RemoveModifierByName("modifier_ancient_ultimate_damage_all_buff")
	end
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:RemoveModifierByName("modifier_ancient_ultimate_damage_all_buff")
	end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveModifierByName("modifier_ancient_ultimate_damage_all_buff")
	end
end