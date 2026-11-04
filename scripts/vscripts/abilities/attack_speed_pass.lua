LinkLuaModifier( "attack_speed_pass_mod", "abilities/attack_speed_pass.lua", LUA_MODIFIER_MOTION_NONE )
attack_speed_pass = class({})

function attack_speed_pass:GetIntrinsicModifierName()
	return "attack_speed_pass_mod"
end

attack_speed_pass_mod = class({})

function attack_speed_pass_mod:OnCreated( kv )
    if IsServer() then
        Timers:CreateTimer(0.1, function()
            self:SetStackCount(self:GetAbility():GetLevel())
        end)
    end
end

function attack_speed_pass_mod:IsHidden()
    return true
end

function attack_speed_pass_mod:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function attack_speed_pass_mod:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function attack_speed_pass_mod:GetModifierAttackSpeedBonus_Constant()
    return self:GetStackCount()
end