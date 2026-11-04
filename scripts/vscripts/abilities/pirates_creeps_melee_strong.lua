function OnAttackLanded(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()
    if level > 0 then
        local need_attack = ability:GetLevelSpecialValueFor( "need_attack" , level - 1  )
        local mod = caster:FindModifierByName("modifier_pirates_creeps_melee_strong")
        mod:SetStackCount(mod:GetStackCount()+1)
        if mod:GetStackCount() >= need_attack then
            mod:SetStackCount(0)
            local target = event.target
            local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1  )
            ApplyCustomDamage(target, caster, damage * caster:GetDisplayAttackSpeed() / 100, 6, ability)
            local max_mana = caster:GetMaxMana()
            local mana = ability:GetLevelSpecialValueFor( "mana" , level - 1  )
            if max_mana == 150 then
                caster:SetMaxMana(150 + mana)
            end
            caster:GiveMana(mana)
        end
    end
end