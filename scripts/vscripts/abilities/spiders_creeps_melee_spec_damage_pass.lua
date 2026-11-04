LinkLuaModifier( "spiders_creeps_melee_spec_damage_pass_mod", "abilities/spiders_creeps_melee_spec_damage_pass.lua", LUA_MODIFIER_MOTION_NONE )
spiders_creeps_melee_spec_damage_pass = class({})

function spiders_creeps_melee_spec_damage_pass:GetIntrinsicModifierName()
	return "spiders_creeps_melee_spec_damage_pass_mod"
end

spiders_creeps_melee_spec_damage_pass_mod = class({})

function spiders_creeps_melee_spec_damage_pass_mod:OnCreated( kv )
    local ability = self:GetAbility()
    self.bonus_damage = ability:GetLevelSpecialValueFor( "damage", 0 )
    self.hp_border = ability:GetLevelSpecialValueFor( "hp_border", 0 )/100
end

function spiders_creeps_melee_spec_damage_pass_mod:IsHidden()
    return self:GetStackCount() == 0
end

function spiders_creeps_melee_spec_damage_pass_mod:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
	return funcs
end

function spiders_creeps_melee_spec_damage_pass_mod:GetModifierDamageOutgoing_Percentage()
    if IsServer() then
        local parent = self:GetParent()
        if parent:GetHealth() < parent:GetMaxHealth()*self.hp_border then
            self:SetStackCount(1)
        else
            self:SetStackCount(0)
        end
    end
    return self:GetStackCount() * self.bonus_damage
end