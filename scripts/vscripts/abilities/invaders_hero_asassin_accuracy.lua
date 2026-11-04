function OnAttackStart(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    if level > 0 and not caster:HasModifier("modifier_invaders_hero_asassin_accuracy_hero_buff") then
        local need_attack = ability:GetLevelSpecialValueFor( "need_attack" , level - 1  )
        local mod = caster:FindModifierByName("modifier_invaders_hero_asassin_accuracy_attack_counter")
        mod:SetStackCount(mod:GetStackCount()+1)
        if mod:GetStackCount() >= need_attack then
            mod:SetStackCount(0)
            local heal = ability:GetLevelSpecialValueFor( "heal" , level - 1  )
            caster:Heal( heal, ability )
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_invaders_hero_asassin_accuracy_hero_buff", {})
        end
    end
end