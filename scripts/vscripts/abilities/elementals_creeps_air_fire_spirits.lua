function Fervor(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    
    if level > 0 then
        local max_stacks = ability:GetLevelSpecialValueFor( "max_stacks" , level - 1  )
        local attack_left = ability:GetLevelSpecialValueFor( "attack_left" , level - 1  )
        local mod = caster:FindModifierByName("modifier_elementals_creeps_air_fire_spirits_stack")

        if mod then
            if mod:GetStackCount() >= max_stacks then
                caster:RemoveModifierByName("modifier_elementals_creeps_air_fire_spirits_stack")
                ability:ApplyDataDrivenModifier(caster, caster, "modifier_elementals_creeps_air_fire_spirits_aoe", {})
            end
            mod:SetStackCount(mod:GetStackCount() + 1)
        else
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_elementals_creeps_air_fire_spirits_stack", {}):SetStackCount(1)
        end
    end
end