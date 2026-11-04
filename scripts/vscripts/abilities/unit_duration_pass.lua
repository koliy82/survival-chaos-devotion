LinkLuaModifier( "unit_duration_pass_mod", "abilities/unit_duration_pass.lua", LUA_MODIFIER_MOTION_NONE )
unit_duration_pass = class({})

function unit_duration_pass:GetIntrinsicModifierName()
	return "unit_duration_pass_mod"
end

unit_duration_pass_mod = class({})

function unit_duration_pass_mod:OnCreated( kv )
    if IsServer() then
        Timers:CreateTimer(0.1, function()
			self:GetCaster():AddNewModifier(self:GetCaster(), nil, "modifier_kill", {duration = self:GetAbility():GetLevel()})
        end)
    end
end