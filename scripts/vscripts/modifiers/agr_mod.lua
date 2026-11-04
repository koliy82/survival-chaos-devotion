LinkLuaModifier( "agr_mod", "modifiers/agr_mod.lua", LUA_MODIFIER_MOTION_NONE )
agr_mod = class({})

-- function agr_mod:OnCreated( kv )
--     if IsServer() then
--         self:GetAbility():OnEquipped()
--     end
-- end

function agr_mod:IsHidden()
    return false
end

function agr_mod:GetStatusEffectName()
    return "particles/status_fx/status_effect_beserkers_call.vpcf"
end

function agr_mod:StatusEffectPriority()
    return 10
end

function agr_mod:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = true
	}
end

function AgrTarget(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target
    local duration = event.Duration
    target:AddNewModifier(caster, ability, "agr_mod", {duration = duration})
end