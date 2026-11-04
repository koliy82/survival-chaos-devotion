function OnAttackLanded(event)
    local target = event.target
    if target and target:IsAlive() and not target:IsAncient() and not target:IsMagicImmune() then
        local ability = event.ability
        local caster = event.caster
        local level = ability:GetLevel()
        local duration = ability:GetLevelSpecialValueFor( "duration" , level - 1  )
        local need_attack = ability:GetLevelSpecialValueFor( "need_attack" , level - 1  )
        if target:IsCustomHero() then
            local mod = target:FindModifierByName("modifier_pirates_creeps_arme_mark_debuff_hero")

            if mod then
                local stacks = mod:GetStackCount()
                if stacks < need_attack then
                    mod:SetStackCount(stacks+1)
                    mod:SetDuration(duration, true)
                else
                    ability:ApplyDataDrivenModifier(caster, target, "modifier_pirates_creeps_arme_mark_buff_emitter", {})
                end
            else
                ability:ApplyDataDrivenModifier(caster, target, "modifier_pirates_creeps_arme_mark_debuff_hero", {}):SetStackCount(1)
            end
        else
            local mod = target:FindModifierByName("modifier_pirates_creeps_arme_mark_debuff")

            if mod then
                local stacks = mod:GetStackCount()
                if stacks < need_attack then
                    mod:SetStackCount(stacks+1)
                    mod:SetDuration(duration, true)
                else
                    ability:ApplyDataDrivenModifier(caster, target, "modifier_pirates_creeps_arme_mark_buff_emitter", {})
                end
            else
                ability:ApplyDataDrivenModifier(caster, target, "modifier_pirates_creeps_arme_mark_debuff", {}):SetStackCount(1)
            end
        end
    end
end