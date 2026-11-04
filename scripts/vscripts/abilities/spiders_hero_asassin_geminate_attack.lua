function OnAttackLanded(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    if level > 0 then
        local need_attack = ability:GetLevelSpecialValueFor( "need_attack" , level - 1  )
        local mod = caster:FindModifierByName("modifier_spiders_hero_asassin_geminate_attack")
        mod:SetStackCount(mod:GetStackCount()+1)
        if mod:GetStackCount() >= need_attack then
            mod:SetStackCount(0)
            caster:PerformAttack(target, true, true, true, true, true, false, false )
        end
    end
end