function OnAttackLandedActOnTargets(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target
    local damageprc = event.damage/100
    ApplyCustomDamage(target, caster, damageprc*caster:GetAttackDamage(), caster.custom_damage_type, ability)
end