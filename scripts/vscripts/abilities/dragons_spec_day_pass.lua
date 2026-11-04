LinkLuaModifier( "modifier_dragons_spec_day_pass", "abilities/dragons_spec_day_pass", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dragons_spec_day_pass_buff", "abilities/dragons_spec_day_pass", LUA_MODIFIER_MOTION_NONE )

dragons_spec_day_pass = class ({})

--------------------------------------------------------------------------------

function dragons_spec_day_pass:GetIntrinsicModifierName()
	return "modifier_dragons_spec_day_pass"
end

--------------------------------------------------------------------------------

modifier_dragons_spec_day_pass = class({})

--------------------------------------------------------------------------------

function modifier_dragons_spec_day_pass:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_dragons_spec_day_pass:IsAura()
	return true
end

function modifier_dragons_spec_day_pass:GetAuraRadius()
	return 9999999
end

function modifier_dragons_spec_day_pass:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_dragons_spec_day_pass:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_dragons_spec_day_pass:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_dragons_spec_day_pass:GetModifierAura()
    if IsServer() then
        if GameRules:IsDaytime() then
            return "modifier_dragons_spec_day_pass_buff"
		end
    end
end

--------------------------------------------------------------------------------

modifier_dragons_spec_day_pass_buff = class({})

function modifier_dragons_spec_day_pass_buff:IsHidden()
	if self:GetParent():GetLevel() < 5 then
		return false
	else
		return true
    end
end

function modifier_dragons_spec_day_pass_buff:OnCreated( params ) --kv
	self.mana_regen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
	self.hp_regen = self:GetAbility():GetSpecialValueFor( "hp_regen" )
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "as_bonus" )
	self.damage_bonus = self:GetAbility():GetSpecialValueFor( "damage_bonus" )

	if IsServer() and self:GetParent():GetLevel() < 5 then
        self:SetStackCount(1)
    end

end

function modifier_dragons_spec_day_pass_buff:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_dragons_spec_day_pass_buff:GetModifierDamageOutgoing_Percentage( params )
    return self.damage_bonus * self:GetStackCount()
end

function modifier_dragons_spec_day_pass_buff:GetModifierAttackSpeedBonus_Constant( params )
    return self.as_bonus * self:GetStackCount()
end

function modifier_dragons_spec_day_pass_buff:GetModifierConstantHealthRegen( params )
    return self.hp_regen * self:GetStackCount()
end

function modifier_dragons_spec_day_pass_buff:GetModifierConstantManaRegen( params )
    return self.mana_regen * self:GetStackCount()
end