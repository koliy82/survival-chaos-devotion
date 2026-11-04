LinkLuaModifier( "modifier_nagas_creep_range_poison_sting_damage_and_debuff", "abilities/nagas_creep_range_poison_sting.lua", LUA_MODIFIER_MOTION_NONE )
function OnAttackLanded(event)
    local target = event.target
    if target and target:IsAlive() then 
        local ability = event.ability
        local level = ability:GetLevel()
        local duration = ability:GetLevelSpecialValueFor( "duration" , level - 1  )
        local maxstacks = ability:GetLevelSpecialValueFor( "max_stacks" , level - 1  )
        local mod = target:FindModifierByName("modifier_nagas_creep_range_poison_sting_damage_and_debuff")
        if mod then
            local stacks = mod:GetStackCount()
            if stacks < maxstacks then
                mod:SetStackCount(stacks+1)
            end
            mod:SetDuration(duration, true)
        else
            target:AddNewModifier(event.caster, ability, "modifier_nagas_creep_range_poison_sting_damage_and_debuff", {duration = duration}):SetStackCount(1)
        end
    end
end

modifier_nagas_creep_range_poison_sting_damage_and_debuff = class( {} )

function modifier_nagas_creep_range_poison_sting_damage_and_debuff:OnCreated( kv )
    self.damage = self:GetAbility():GetSpecialValueFor( "poison_damage" )
    self.slow = self:GetAbility():GetSpecialValueFor( "movement_slow" )
    self:StartIntervalThink(1)
end

function modifier_nagas_creep_range_poison_sting_damage_and_debuff:OnIntervalThink()
    ApplyCustomDamage(self:GetParent(), self:GetCaster(), 0 + self.damage * self:GetStackCount(), 6, self:GetAbility())
	return 1
end

function modifier_nagas_creep_range_poison_sting_damage_and_debuff:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_nagas_creep_range_poison_sting_damage_and_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_nagas_creep_range_poison_sting_damage_and_debuff:GetModifierMoveSpeedBonus_Percentage( params )
    return (self.slow * self:GetStackCount())
end