function OnAttackLanded(event)
    local target = event.target
    if target and target:IsAlive() then
        local caster = event.caster
        local ability = event.ability
        local level = ability:GetLevel()
        local need_stacks = ability:GetLevelSpecialValueFor( "need_stacks" , level - 1  )
        local duration = ability:GetLevelSpecialValueFor( "duration" , level - 1  )
        local stack_duration = ability:GetLevelSpecialValueFor( "stack_duration" , level - 1  )
        
        local silence_mod = target:FindModifierByName("modifier_humans_hero_asassin_spec_accuracy_silence")
        if silence_mod == nil then
            local mod = target:FindModifierByName("modifier_humans_hero_asassin_spec_accuracy_stack_count")
            if mod then
                local stacks = mod:GetStackCount()
                if stacks < need_stacks then
                    mod:SetStackCount(stacks+1)
                end
                if stacks == need_stacks - 1 then
                    ability:ApplyDataDrivenModifier(caster, caster, "modifier_humans_hero_asassin_spec_accuracy_speed", {duration = duration})
                    if not target:IsAncient() then
                        ability:ApplyDataDrivenModifier(caster, target, "modifier_humans_hero_asassin_spec_accuracy_silence", {duration = duration})
                    end
                    mod:SetStackCount(0)
                end
                mod:SetDuration(stack_duration, true)
            else
                ability:ApplyDataDrivenModifier(caster, target, "modifier_humans_hero_asassin_spec_accuracy_stack_count", {duration = stack_duration}):SetStackCount(1)
            end
        end
    end
end