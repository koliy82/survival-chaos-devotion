LinkLuaModifier( "asassin_hero_killer_mod", "abilities/humans_hero_asassin_hero_killer", LUA_MODIFIER_MOTION_NONE )

humans_hero_asassin_hero_killer = class ({})

--------------------------------------------------------------------------------

function humans_hero_asassin_hero_killer:GetIntrinsicModifierName()
	return "asassin_hero_killer_mod"
end

--------------------------------------------------------------------------------

asassin_hero_killer_mod = class({})

--------------------------------------------------------------------------------

function asassin_hero_killer_mod:IsHidden() 
	return true
end

function asassin_hero_killer_mod:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function asassin_hero_killer_mod:OnAttackLanded(event)
    if IsServer() then
        self:GetParent().custom_damage_armor_multiplier[5] = 1 + self:GetAbility():GetSpecialValueFor( "damage_mult_prc" )/100
    end
end