function OnAttackLanded(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    if level > 0 and not target:IsAncient() then
        local need_attack = ability:GetLevelSpecialValueFor( "need_attack" , level - 1  )
        local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1  )
        local mod = caster:FindModifierByName("modifier_elves_hero_asassin_strong_attack")
        mod:SetStackCount(mod:GetStackCount()+1)
        if mod:GetStackCount() >= need_attack then
            mod:SetStackCount(0)
            --ApplyCustomDamage(target, caster, damage, 6, ability)
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_elves_hero_asassin_strong_attack_crit", {})
        end
    end
end