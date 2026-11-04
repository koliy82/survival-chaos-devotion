LinkLuaModifier( "undead_creeps_mage_cooldown_pass_mod", "abilities/undead_creeps_mage_cooldown_pass", LUA_MODIFIER_MOTION_NONE )

undead_creeps_mage_cooldown_pass = class ({})

--------------------------------------------------------------------------------

function undead_creeps_mage_cooldown_pass:GetIntrinsicModifierName()
	return "undead_creeps_mage_cooldown_pass_mod"
end

--------------------------------------------------------------------------------

undead_creeps_mage_cooldown_pass_mod = class({})

--------------------------------------------------------------------------------

-- function undead_creeps_mage_cooldown_pass_mod:OnCreated( kv )
-- 	self.cooldown_red = self:GetAbility():GetSpecialValueFor( "cooldown_red" )
-- end

function undead_creeps_mage_cooldown_pass_mod:IsHidden() 
	return true
end

-- function undead_creeps_mage_cooldown_pass_mod:GetTexture()
--     return 
-- end


function undead_creeps_mage_cooldown_pass_mod:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}

	return funcs
end

function undead_creeps_mage_cooldown_pass_mod:GetModifierPercentageCooldown()
	return self:GetAbility():GetSpecialValueFor( "cooldown_red" )
end

function undead_creeps_mage_cooldown_pass_mod:GetModifierConstantManaRegen()
	return self:GetAbility():GetSpecialValueFor( "mana_regen" )
end