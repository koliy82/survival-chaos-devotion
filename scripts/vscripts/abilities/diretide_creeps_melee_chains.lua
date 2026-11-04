function OnAttackLanded(event)
    local target = event.target
    if target and target:IsAlive() and not target:IsAncient() then 
        local ability = event.ability
        local level = ability:GetLevel()
        local duration = ability:GetLevelSpecialValueFor( "duration" , level - 1  )
        local maxstacks = ability:GetLevelSpecialValueFor( "max_stacks" , level - 1  )
        local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1  )
        local mod = target:FindModifierByName("modifier_diretide_creeps_melee_chains_stacks")
        if mod then
            local stacks = mod:GetStackCount()
            if stacks < maxstacks - 1 then
                mod:SetStackCount(stacks+1)
                ability:ApplyDataDrivenModifier(event.caster, target, "modifier_diretide_creeps_melee_chains_debuff", {duration = duration})
                mod:SetDuration(duration, true)
            else
                target:RemoveModifierByName("modifier_diretide_creeps_melee_chains_stacks")
                target:RemoveModifierByName("modifier_diretide_creeps_melee_chains_debuff")
                ApplyCustomDamage(target, event.caster, damage, 6, ability)
            end
        else
            ability:ApplyDataDrivenModifier(event.caster, target, "modifier_diretide_creeps_melee_chains_stacks", {duration = duration}):SetStackCount(1)
            ability:ApplyDataDrivenModifier(event.caster, target, "modifier_diretide_creeps_melee_chains_debuff", {duration = duration})
        end
    end
end