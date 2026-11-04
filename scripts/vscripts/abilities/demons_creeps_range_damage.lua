LinkLuaModifier( "modifier_demons_creeps_range_damage_slow", "abilities/demons_creeps_range_damage.lua", LUA_MODIFIER_MOTION_NONE )
function OnAttackLanded(event)
    local target = event.target
    if target and target:IsAlive() and not target:IsMagicImmune() then 
        local ability = event.ability
        local level = ability:GetLevel()
        local duration = ability:GetLevelSpecialValueFor( "duration" , level - 1  )
        local maxstacks = ability:GetLevelSpecialValueFor( "max_stacks" , level - 1  )
        local mod = target:FindModifierByName("modifier_demons_creeps_range_damage_slow")
        if mod then
            local stacks = mod:GetStackCount()
            if stacks < maxstacks then
                mod:SetStackCount(stacks+1)
            end
            mod:SetDuration(duration, true)
        else
            target:AddNewModifier(event.caster, ability, "modifier_demons_creeps_range_damage_slow", {duration = duration}):SetStackCount(1)
        end
    end
end

modifier_demons_creeps_range_damage_slow = class( {} )

function modifier_demons_creeps_range_damage_slow:OnCreated( kv )
    self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
    self.damage_build = self:GetAbility():GetSpecialValueFor( "damage_build" )
    self:StartIntervalThink(1)
end

function modifier_demons_creeps_range_damage_slow:OnIntervalThink()
    if self:GetParent():IsAncient() then
        ApplyCustomDamage(self:GetParent(), self:GetCaster(), self.damage * self:GetStackCount() * self.damage_build / 100, 6, self:GetAbility())
    else
        ApplyCustomDamage(self:GetParent(), self:GetCaster(), self.damage * self:GetStackCount(), 6, self:GetAbility())
    end
	return 1
end

function modifier_demons_creeps_range_damage_slow:IsDebuff()
	return true
end
