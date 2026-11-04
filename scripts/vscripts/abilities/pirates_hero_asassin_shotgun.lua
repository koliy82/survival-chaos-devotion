function OnIntervalThink( event )
	local caster = event.caster
	local ability = event.ability
	local casterLoc = caster:GetAbsOrigin()
	local wave_distance = ability:GetLevelSpecialValueFor( "range", ability:GetLevel() - 1 )
	local start_radius = ability:GetLevelSpecialValueFor( "start_radius", ability:GetLevel() - 1 )
	local end_radius = ability:GetLevelSpecialValueFor( "end_radius", ability:GetLevel() - 1 )
	local projectile_speed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
	
	local direction = caster:GetForwardVector()--(target:GetOrigin()-casterLoc):Normalized()

	local projectileTable = {
		Ability = ability,
		EffectName = "particles/units/heroes/hero_snapfire/hero_snapfire_shotgun.vpcf",
		vSpawnOrigin = casterLoc,
		fDistance = wave_distance,
		fStartRadius = start_radius,
		fEndRadius = end_radius,
		Source = caster,
		bHasFrontalCone = true,
		bReplaceExisting = false,
		bProvidesVision = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		vVelocity = direction * projectile_speed
		}
	ProjectileManager:CreateLinearProjectile( projectileTable )
end