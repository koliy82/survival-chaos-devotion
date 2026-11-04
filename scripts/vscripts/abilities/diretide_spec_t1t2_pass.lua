LinkLuaModifier( "modifier_diretide_spec_t1t2_pass", "abilities/diretide_spec_t1t2_pass", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_diretide_spec_t1t2_pass_buff", "abilities/diretide_spec_t1t2_pass", LUA_MODIFIER_MOTION_NONE )

diretide_spec_t1t2_pass = class ({})

--------------------------------------------------------------------------------

function diretide_spec_t1t2_pass:GetIntrinsicModifierName()
	return "modifier_diretide_spec_t1t2_pass"
end

--------------------------------------------------------------------------------

modifier_diretide_spec_t1t2_pass = class({})

--------------------------------------------------------------------------------

function modifier_diretide_spec_t1t2_pass:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_diretide_spec_t1t2_pass:IsAura()
	return true
end

function modifier_diretide_spec_t1t2_pass:GetAuraRadius()
	return 9999999
end

function modifier_diretide_spec_t1t2_pass:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_diretide_spec_t1t2_pass:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_diretide_spec_t1t2_pass:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_diretide_spec_t1t2_pass:GetModifierAura()
    if IsServer() then
        if not GameRules:IsDaytime() then
            return "modifier_diretide_spec_t1t2_pass_buff"
		end
    end
end

--------------------------------------------------------------------------------

modifier_diretide_spec_t1t2_pass_buff = class({})

function modifier_diretide_spec_t1t2_pass_buff:IsHidden()
	if self:GetParent():GetLevel() < 3 then
		return false
	else
		return true
    end
end

function modifier_diretide_spec_t1t2_pass_buff:OnCreated( params ) --kv
	self.as_bonus = self:GetAbility():GetSpecialValueFor( "as_bonus" )
	self.damage_bonus = self:GetAbility():GetSpecialValueFor( "damage_bonus" )

	if IsServer() and self:GetParent():GetLevel() < 3 then
        self:SetStackCount(1)
    end

end

function modifier_diretide_spec_t1t2_pass_buff:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_diretide_spec_t1t2_pass_buff:GetModifierDamageOutgoing_Percentage( params )
    return self.damage_bonus * self:GetStackCount()
end

function modifier_diretide_spec_t1t2_pass_buff:GetModifierAttackSpeedBonus_Constant( params )
    return self.as_bonus * self:GetStackCount()
end