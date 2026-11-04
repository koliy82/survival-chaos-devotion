LinkLuaModifier( "pusher_damage_pass_mod", "abilities/treants_hero_pusher_damage_pass", LUA_MODIFIER_MOTION_NONE )

treants_hero_pusher_damage_pass = class ({})

--------------------------------------------------------------------------------

function treants_hero_pusher_damage_pass:GetIntrinsicModifierName()
	return "pusher_damage_pass_mod"
end

--------------------------------------------------------------------------------

pusher_damage_pass_mod = class({})

--------------------------------------------------------------------------------

function pusher_damage_pass_mod:IsHidden() 
	return true
end

function pusher_damage_pass_mod:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_EVENT_ON_TAKEDAMAGE,
	}

	return funcs
end

function pusher_damage_pass_mod:OnTakeDamage(event)
    if IsServer() then
        self:GetParent().custom_damage_armor_multiplier[4] = 1 + self:GetAbility():GetSpecialValueFor( "bonus_damage_prc" )/100
    end
end