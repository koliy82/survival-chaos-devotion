function WaveOfHatred( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	-- local target_point = keys.target_points[1]
	local target_point = keys.target:GetAbsOrigin()
	local forwardVec = (target_point - caster_location):Normalized()

	local wave_speed = ability:GetLevelSpecialValueFor("wave_speed", (ability:GetLevel() - 1))
	local wave_width = ability:GetLevelSpecialValueFor("wave_width", (ability:GetLevel() - 1))
	local wave_range = ability:GetLevelSpecialValueFor("wave_range", (ability:GetLevel() - 1))
	local wave_location = caster_location
	local wave_particle = keys.wave_particle

	local projectileTable =
	{
		EffectName = wave_particle,
		Ability = ability,
		vSpawnOrigin = caster_location,
		vVelocity = Vector( forwardVec.x * wave_speed, forwardVec.y * wave_speed, 0 ),
		fDistance = wave_range,
		fStartRadius = wave_width,
		fEndRadius = wave_width,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
		iUnitTargetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	}
	projectile_id = ProjectileManager:CreateLinearProjectile( projectileTable )
end