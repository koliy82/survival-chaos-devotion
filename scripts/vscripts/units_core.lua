LinkLuaModifier( "units_core_mod", "units_core.lua", LUA_MODIFIER_MOTION_NONE )
units_core = class({})

function units_core:GetIntrinsicModifierName()
	return "units_core_mod"
end

units_core_mod = class({})

function units_core_mod:OnCreated( kv )
    if IsServer() then
        local caster = self:GetCaster()
        local unit_name = caster:GetUnitName()
        local id = caster:GetPlayerOwnerID()
        -- print(id)
        if id == -1 then
            id = 0
        end
        
        Timers:CreateTimer(0, function()
            if _G.playersinfo[id].unitsinfo[unit_name].store_model then
                caster:SetModel(_G.playersinfo[id].unitsinfo[unit_name].store_model)
                caster:SetOriginalModel(_G.playersinfo[id].unitsinfo[unit_name].store_model)
            end
            if _G.playersinfo[id].unitsinfo[unit_name].store_model_scale then
                caster:SetModelScale(_G.playersinfo[id].unitsinfo[unit_name].store_model_scale)
            end
            local war_table = _G.playersinfo[id].unitsinfo[unit_name].store_wearables or _G.playersinfo[id].unitsinfo[unit_name].def_wearables
            if war_table ~= nil then
                Wearable:WearDefaults(caster)
                for _, wearable in pairs(war_table) do
                    Wearable:Wear(caster, wearable)
                end
            end
            caster:FixAnims()
        end)


        -- if not id then
        --     id = caster:GetPlayerID()
            -- caster:SetBaseMaxHealth(_G.playersinfo[id].unitsinfo[unit_name].health)
        -- else
        -- end
        -- print("units_core")
        self:SetStackCount(id)
        caster:SetBaseDamageMin(_G.playersinfo[id].unitsinfo[unit_name].min_damage)
        caster:SetBaseDamageMax(_G.playersinfo[id].unitsinfo[unit_name].max_damage)
        caster:SetBaseManaRegen(caster:GetManaRegen() + (_G.playersinfo[id].unitsinfo[unit_name].bonus_mana_regen or 0))
        caster:SetBaseHealthRegen(caster:GetBaseHealthRegen() + (_G.playersinfo[id].unitsinfo[unit_name].bonus_health_regen or 0))
        if caster.mana then
            caster.mana = caster.mana + _G.playersinfo[id].unitsinfo[unit_name].mana
        else
            caster.mana = _G.playersinfo[id].unitsinfo[unit_name].mana
        end
        caster:CalculateGenericBonuses()
        -- caster:SetManaGain(_G.playersinfo[id].unitsinfo[unit_name].mana)
        -- caster:CreatureLevelUp(1)
        -- caster:SetManaGain(0)
        -- caster:CreatureLevelUp(-1)
        Timers:CreateTimer(0, function()
            caster:SetPhysicalArmorBaseValue(_G.playersinfo[id].unitsinfo[unit_name].armor + caster:GetPhysicalArmorBaseValue())
            caster:SetMana(caster.mana)
            for k, v in pairs(_G.playersinfo[id].unitsinfo[unit_name].abilities) do
                local ability = caster:AddAbility(k)
                ability:SetLevel(v)
            end
            -- print(_G.playersinfo[id].unitsinfo[unit_name].health)
            if not caster:HasAbility("elite_unit_pass") then
                caster:SetBaseMaxHealth(_G.playersinfo[id].unitsinfo[unit_name].health)
                caster:SetMaxHealth(_G.playersinfo[id].unitsinfo[unit_name].health)
                caster:CalculateGenericBonuses()
                caster:SetHealth(_G.playersinfo[id].unitsinfo[unit_name].health)
            end
        end)
        if unit_name == "npc_dota_elves_siege" then
            caster:SetRenderColor(100, 255, 255)
        end
        if unit_name == "npc_dota_dragons_arme" then
            caster:SetRenderColor(107, 183, 255)
        end
    end
end

function units_core_mod:IsHidden()
    return true
end

-- function units_core_mod:CheckState()
-- 	local state = {}
-- 	state[MODIFIER_STATE_ROOTED] = true
--     state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
-- 	return state
-- end

function units_core_mod:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_MANA_BONUS
	}
	return funcs
end

function units_core_mod:GetModifierManaBonus()
    return self:GetCaster().mana
end