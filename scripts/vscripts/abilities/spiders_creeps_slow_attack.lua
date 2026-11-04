LinkLuaModifier( "modifier_spiders_creeps_slow_attack_slow", "abilities/spiders_creeps_slow_attack.lua", LUA_MODIFIER_MOTION_NONE )
function OnAttackLanded(event)
    local target = event.target
    if target and target:IsAlive() and not target:IsAncient() and not target:IsMagicImmune() then 
        local ability = event.ability
        local level = ability:GetLevel()
        local duration = ability:GetLevelSpecialValueFor( "duration" , level - 1  )
        local maxstacks = ability:GetLevelSpecialValueFor( "max_stacks" , level - 1  )
        local mod = target:FindModifierByName("modifier_spiders_creeps_slow_attack_slow")
        if mod then
            local stacks = mod:GetStackCount()
            if stacks < maxstacks then
                mod:SetStackCount(stacks+1)
            end
            mod:SetDuration(duration, true)
        else
            target:AddNewModifier(event.caster, ability, "modifier_spiders_creeps_slow_attack_slow", {duration = duration}):SetStackCount(1)
        end
    end
end

modifier_spiders_creeps_slow_attack_slow = class( {} )

function modifier_spiders_creeps_slow_attack_slow:OnCreated( kv )
    self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
    self.slow = self:GetAbility():GetSpecialValueFor( "slow_attack_speed" )
    self:StartIntervalThink(1)
end

function modifier_spiders_creeps_slow_attack_slow:OnIntervalThink()
    ApplyCustomDamage(self:GetParent(), self:GetCaster(), self.damage * self:GetStackCount(), 6, self:GetAbility())
	return 1
end

function modifier_spiders_creeps_slow_attack_slow:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_spiders_creeps_slow_attack_slow:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_spiders_creeps_slow_attack_slow:GetModifierAttackSpeedBonus_Constant( params )
    return -(self.slow * self:GetStackCount())
end