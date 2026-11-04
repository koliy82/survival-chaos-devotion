function OnSpellStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target
	local particle_name = "particles/econ/items/spectre/spectre_arcana/spectre_arcana_spectral_dagger.vpcf"
	-- Parameters
	local wave_direction = caster:GetForwardVector()
	local wave_speed = ability:GetLevelSpecialValueFor("speed", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)
	local wave_distance = ability:GetLevelSpecialValueFor("wave_distance", ability_level)
	local wave_location = caster:GetAbsOrigin() + (5 *  wave_direction)
	
	caster:EmitSound("Hero_Spectre.DaggerCast")

	ability.dagger_path = ProjectileManager:CreateLinearProjectile( {
		Ability				= ability,
		EffectName			= particle_name,
		vSpawnOrigin		= wave_location,
		fDistance			= wave_distance,
		fStartRadius		= radius,
		fEndRadius			= radius,
		Source				= caster,
		bHasFrontalCone		= true,
		bReplaceExisting	= false,
		iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
		iUnitTargetType		= DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		bDeleteOnHit		= false,
		vVelocity			= wave_direction * wave_speed,
		bProvidesVision		= false,
	} )
	
end