LinkLuaModifier( "modifier_primordials_spec_t1t2_asassin_pass", "abilities/primordials_spec_t1t2_asassin_pass", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primordials_spec_t1t2_asassin_pass_buff", "abilities/primordials_spec_t1t2_asassin_pass", LUA_MODIFIER_MOTION_NONE )

primordials_spec_t1t2_asassin_pass = class ({})

--------------------------------------------------------------------------------

function primordials_spec_t1t2_asassin_pass:GetIntrinsicModifierName()
	return "modifier_primordials_spec_t1t2_asassin_pass"
end

--------------------------------------------------------------------------------

modifier_primordials_spec_t1t2_asassin_pass = class({})

--------------------------------------------------------------------------------

function modifier_primordials_spec_t1t2_asassin_pass:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_primordials_spec_t1t2_asassin_pass:IsAura()
	return true
end

function modifier_primordials_spec_t1t2_asassin_pass:GetAuraRadius()
	return 9999999
end

function modifier_primordials_spec_t1t2_asassin_pass:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_primordials_spec_t1t2_asassin_pass:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_primordials_spec_t1t2_asassin_pass:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_primordials_spec_t1t2_asassin_pass:GetModifierAura()
    if IsServer() then
        return "modifier_primordials_spec_t1t2_asassin_pass_buff"
    end
end

--------------------------------------------------------------------------------

modifier_primordials_spec_t1t2_asassin_pass_buff = class({})

function modifier_primordials_spec_t1t2_asassin_pass_buff:IsHidden()
	if self:GetParent():GetLevel() < 3 then
		return false
	else
		return true
    end
end

function modifier_primordials_spec_t1t2_asassin_pass_buff:OnCreated( params ) --kv
	self.damage_bonus = self:GetAbility():GetSpecialValueFor( "damage_bonus" )

	if IsServer() and self:GetParent():GetLevel() < 3 then
        self:SetStackCount(1)
    end

end

function modifier_primordials_spec_t1t2_asassin_pass_buff:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_primordials_spec_t1t2_asassin_pass_buff:GetModifierDamageOutgoing_Percentage( params )
    return self.damage_bonus * self:GetStackCount()
end