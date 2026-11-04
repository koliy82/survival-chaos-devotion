function OnAttackLanded(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    if level > 0 then
        if target:IsCustomHero() then
            local damage = ability:GetLevelSpecialValueFor( "damage", level - 1 )
			ApplyCustomDamage(target, caster, damage, 6, ability)
        end
    end
end