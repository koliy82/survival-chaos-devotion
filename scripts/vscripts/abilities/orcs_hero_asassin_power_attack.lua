function OnAttackLanded(keys)
    local caster = keys.caster
    local ability = keys.ability
    if ability:GetLevel() > 0 then
        local buff = caster:FindModifierByName("modifier_orcs_hero_asassin_power_attack")
        local stacks = buff:GetStackCount()
        if stacks >= 2 then
            buff:SetStackCount(0)
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_orcs_hero_asassin_power_attack_buff", {})
        else
            buff:SetStackCount(stacks+1)
        end
    end
end