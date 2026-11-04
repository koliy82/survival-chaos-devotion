function OnSpellStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	
	if ability_level >= 0 and ability:IsCooldownReady() then
		local target = keys.target
		local particle_name = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf"
		-- Parameters
		local wave_direction = caster:GetForwardVector()
		local wave_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
		local start_radius = ability:GetLevelSpecialValueFor("start_radius", ability_level)
		local end_radius = ability:GetLevelSpecialValueFor("end_radius", ability_level)
		local wave_distance = ability:GetLevelSpecialValueFor("wave_distance", ability_level)

		local wave_location = caster:GetAbsOrigin() + (5 *  wave_direction)

		ProjectileManager:CreateLinearProjectile( {
			Ability				= ability,
			EffectName			= particle_name,
			vSpawnOrigin		= wave_location,
			fDistance			= wave_distance,
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
		
		ability:StartCooldown(ability:GetEffectiveCooldown(ability_level + 1))
	end
end