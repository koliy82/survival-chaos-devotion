LinkLuaModifier( "treants_hero_mage_cooldown_pass_mod", "abilities/treants_hero_mage_cooldown_pass", LUA_MODIFIER_MOTION_NONE )

treants_hero_mage_cooldown_pass = class ({})

--------------------------------------------------------------------------------

function treants_hero_mage_cooldown_pass:GetIntrinsicModifierName()
	return "treants_hero_mage_cooldown_pass_mod"
end

--------------------------------------------------------------------------------

treants_hero_mage_cooldown_pass_mod = class({})

--------------------------------------------------------------------------------

-- function treants_hero_mage_cooldown_pass_mod:OnCreated( kv )
-- 	self.cooldown_red = self:GetAbility():GetSpecialValueFor( "cooldown_red" )
-- end

function treants_hero_mage_cooldown_pass_mod:IsHidden() 
	return true
end

-- function treants_hero_mage_cooldown_pass_mod:GetTexture()
--     return 
-- end


function treants_hero_mage_cooldown_pass_mod:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}

	return funcs
end

function treants_hero_mage_cooldown_pass_mod:GetModifierPercentageCooldown()
	return self:GetAbility():GetSpecialValueFor( "cooldown_red" )
end