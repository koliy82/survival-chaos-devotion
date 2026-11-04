function OnSpellStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target
	
	local pathLength = ability:GetLevelSpecialValueFor("wave_distance", ability_level)
	local startPos = caster:GetAbsOrigin()
	local endPos = startPos + caster:GetForwardVector() * pathLength
	
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
    ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_origin", endPos, true)
	ParticleManager:ReleaseParticleIndex(pfx)
	
	local wave_direction = caster:GetForwardVector()
	local wave_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
	local start_radius = ability:GetLevelSpecialValueFor("start_radius", ability_level)
	local end_radius = ability:GetLevelSpecialValueFor("end_radius", ability_level)
	EmitSoundOn("Ability.LagunaBladeImpact", target)
	

	local wave_location = caster:GetAbsOrigin() + (5 *  wave_direction)

	ProjectileManager:CreateLinearProjectile( {
		Ability				= ability,
		--EffectName			= particle_name,
		vSpawnOrigin		= wave_location,
		fDistance			= pathLength,
		fStartRadius		= start_radius,
		fEndRadius			= end_radius,
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