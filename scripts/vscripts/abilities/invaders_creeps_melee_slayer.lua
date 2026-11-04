LinkLuaModifier( "modifier_invaders_creeps_melee_slayer_damage_red", "abilities/invaders_creeps_melee_slayer.lua", LUA_MODIFIER_MOTION_NONE )
function OnAttackLanded(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local chance = event.chance

    if caster:FindModifierByName("modifier_invaders_creeps_melee_shield") then
        local spec_ability = caster:FindAbilityByName("invaders_creeps_melee_shield")
        chance = spec_ability:GetLevelSpecialValueFor( "new_chance" , spec_ability:GetLevel() - 1 )
    end

    if target and target:IsAlive() and not target:IsAncient() and not target:IsMagicImmune() and RollPercentage(chance) then 
        local level = ability:GetLevel()
        local duration = ability:GetLevelSpecialValueFor( "duration" , level - 1  )
        local maxstacks = ability:GetLevelSpecialValueFor( "max_stacks" , level - 1  )
        local mod = target:FindModifierByName("modifier_invaders_creeps_melee_slayer_damage_red")
        if mod then
            local stacks = mod:GetStackCount()
            if stacks < maxstacks then
                mod:SetStackCount(stacks+1)
            end
            mod:SetDuration(duration, true)
        else
            target:AddNewModifier(caster, ability, "modifier_invaders_creeps_melee_slayer_damage_red", {duration = duration}):SetStackCount(1)
        end
    end
end

modifier_invaders_creeps_melee_slayer_damage_red = class( {} )

function modifier_invaders_creeps_melee_slayer_damage_red:OnCreated( kv )
    self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
    self.damage_red = self:GetAbility():GetSpecialValueFor( "damage_red" )
    self:StartIntervalThink(1)
end

function modifier_invaders_creeps_melee_slayer_damage_red:OnIntervalThink()
    ApplyCustomDamage(self:GetParent(), self:GetCaster(), self.damage * self:GetStackCount(), 6, self:GetAbility())
	return 1
end

function modifier_invaders_creeps_melee_slayer_damage_red:IsDebuff()
	return true
end

function modifier_invaders_creeps_melee_slayer_damage_red:GetEffectName()
	return "particles/items3_fx/mage_slayer_debuff.vpcf"
end

function modifier_invaders_creeps_melee_slayer_damage_red:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

function modifier_invaders_creeps_melee_slayer_damage_red:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_invaders_creeps_melee_slayer_damage_red:GetModifierDamageOutgoing_Percentage( params )
    return -(self.damage_red * self:GetStackCount())
end