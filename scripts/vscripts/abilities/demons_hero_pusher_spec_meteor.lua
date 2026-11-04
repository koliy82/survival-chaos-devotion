function OnSpellStart(keys)
	local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel() - 1

	local caster_pos = caster:GetAbsOrigin()
    local wave_direction = (keys.target:GetOrigin()-caster_pos):Normalized()
	local wave_speed = ability:GetLevelSpecialValueFor("speed", level)
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local wave_distance = ability:GetLevelSpecialValueFor("distance", level)
	local wave_location = caster_pos + (100 *  wave_direction)
	
	caster:EmitSound("Hero_Invoker.ChaosMeteor.Cast")
	caster:EmitSound("Hero_Invoker.ChaosMeteor.Loop")

	local chaos_meteor_fly_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 0, caster_pos + Vector(0, 0, 1000))
	ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 1, wave_location)
	ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 2, Vector(1.3, 0, 0))

	Timers:CreateTimer({
		endTime = 1.3,
		callback = function()
			
		caster:StopSound("Hero_Invoker.ChaosMeteor.Loop")

    	ProjectileManager:CreateLinearProjectile( {
			Ability				= ability,
			EffectName			= "particles/units/heroes/hero_invoker/invoker_chaos_meteor.vpcf",
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
		})
	end})
end