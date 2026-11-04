function ApplyDamage(t)
	local caster = t.caster
	local units = FindUnitsInRadius(caster:GetTeam(),
                              t.target:GetOrigin(),
                              nil,
                              t.ability:GetSpecialValueFor("range"),
                              t.ability:GetAbilityTargetTeam(),
                              t.ability:GetAbilityTargetType(),
                              t.ability:GetAbilityTargetFlags(),
                              FIND_CLOSEST,
                              false)
	for k,v in pairs(units) do
		ApplyCustomDamage(units[i], t.caster, t.caster:GetAttackDamage() * t.damage * 0.01, 1)
	end
end