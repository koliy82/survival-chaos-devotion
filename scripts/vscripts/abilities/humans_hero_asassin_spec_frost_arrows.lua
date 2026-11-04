LinkLuaModifier( "modifier_frost_arrows_caster_slow", "abilities/humans_hero_asassin_spec_frost_arrows.lua", LUA_MODIFIER_MOTION_NONE )
function OnAttackLanded(event)
    local target = event.target
    if target and target:IsAlive() then
        local caster = event.caster
        local ability = event.ability
        local level = ability:GetLevel()
        local stack_duration = ability:GetLevelSpecialValueFor( "stack_duration" , level - 1  )
        local slow_duration = ability:GetLevelSpecialValueFor( "slow_duration" , level - 1  )
        local maxstacks = ability:GetLevelSpecialValueFor( "max_stacks" , level - 1  )
        local mod = target:FindModifierByName("modifier_frost_arrows_caster_slow")
        local stacks = 0
        if mod then
            stacks = mod:GetStackCount()
            if stacks < maxstacks then
                mod:SetStackCount(stacks+1)
            end
            mod:SetDuration(stack_duration, true)
        else
            target:AddNewModifier(caster, ability, "modifier_frost_arrows_caster_slow", {duration = stack_duration}):SetStackCount(1)
        end
        
        ability:ApplyDataDrivenModifier(caster, target, "modifiers_humans_hero_asassin_spec_frost_arrows_slow", {duration = slow_duration})
        local damage_per_stacks = ability:GetLevelSpecialValueFor( "damage_per_stacks" , level - 1  )
        local damage_add = ability:GetLevelSpecialValueFor( "damage" , level - 1  )
        
        ApplyCustomDamage(target, caster, damage_per_stacks * stacks + damage_add, 6, ability)--7
    end
end

modifier_frost_arrows_caster_slow = class( {} )

function modifier_frost_arrows_caster_slow:OnStackCountChanged( kv )

end

function modifier_frost_arrows_caster_slow:IsDebuff()
	return true
end
