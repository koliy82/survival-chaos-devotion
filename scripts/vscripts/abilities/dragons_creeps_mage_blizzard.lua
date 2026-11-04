function ActOnTargets(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability

	local heal = ability:GetLevelSpecialValueFor( "heal", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )

    local caster_team = caster:GetTeamNumber()

    if target:GetTeamNumber() == caster_team then
        target:Heal( heal, ability )
    else
        ApplyCustomDamage(target, caster, damage, 6, ability)
    end
end