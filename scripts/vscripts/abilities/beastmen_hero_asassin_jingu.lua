function OnAttackStart(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    
    if level > 0 then
        local need_attack = ability:GetLevelSpecialValueFor( "need_attack" , level - 1  )
        local attack_left = ability:GetLevelSpecialValueFor( "attack_left" , level - 1  )
        local mod = caster:FindModifierByName("modifier_beastmen_hero_asassin_jingu")

        if ability.is_active then
            mod:SetStackCount(mod:GetStackCount() - 1)
            if mod:GetStackCount() <= 0 then
                ability.is_active = false
                caster:RemoveModifierByName("modifier_beastmen_hero_asassin_jingu_buff")
            end
        else
            mod:SetStackCount(mod:GetStackCount() + 1)
            if mod:GetStackCount() >= need_attack then
                ability.is_active = true
                mod:SetStackCount(attack_left)
                ability:ApplyDataDrivenModifier(caster, caster, "modifier_beastmen_hero_asassin_jingu_buff", {})
            end
        end
    end
end