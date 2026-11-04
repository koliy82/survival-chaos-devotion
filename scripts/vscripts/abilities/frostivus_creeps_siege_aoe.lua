function ActOnTargets(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	if target:GetMoveSpeedModifier(target:GetBaseMoveSpeed(), false) < 345 then
        ApplyCustomDamage(target, caster, keys.mass_damage * keys.multiplicator, 6, ability)
	else
        ApplyCustomDamage(target, caster, keys.mass_damage, 6, ability)
	end
end

