function OnAttacked(event)
    local caster = event.caster
    local attacker = event.attacker
    if caster == attacker then
        local target = event.target
        local ability = event.ability
        local level = ability:GetLevel()
        local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1  )
    
        ApplyCustomDamage(target, caster, damage, 6, ability)
    end
end