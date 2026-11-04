function OnAttackStart(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    if level > 0 then
        local need_attack = ability:GetLevelSpecialValueFor( "need_attack" , level - 1  )
        local mod = caster:FindModifierByName("modifier_beastmen_hero_tank_enchant")
        mod:SetStackCount(mod:GetStackCount()+1)
        if mod:GetStackCount() >= need_attack then
            mod:SetStackCount(0)
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_beastmen_hero_tank_enchant_cleave", {})
        end
    end
end