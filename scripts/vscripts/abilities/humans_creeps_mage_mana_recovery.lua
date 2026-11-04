function OnAttackLanded(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()
    if level > 0 then
        local mana = ability:GetLevelSpecialValueFor( "mana" , level - 1  )
        caster:GiveMana(mana)
    end
end