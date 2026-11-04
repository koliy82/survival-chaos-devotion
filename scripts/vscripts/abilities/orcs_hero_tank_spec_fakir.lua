function OnSpellStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target
	local particle_name = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf"
	-- Parameters
	local wave_direction = caster:GetForwardVector()
	local wave_speed = ability:GetLevelSpecialValueFor("speed", ability_level)
	local start_radius = ability:GetLevelSpecialValueFor("start_radius", ability_level)
	local end_radius = ability:GetLevelSpecialValueFor("end_radius", ability_level)
	local wave_distance = ability:GetLevelSpecialValueFor("range", ability_level)
	local wave_location = caster:GetAbsOrigin() + (5 *  wave_direction)
	
    local multicast = 1
    
    local multicast_ability = caster:FindAbilityByName("orcs_hero_tank_spec_multicast")
    if multicast_ability then
        local level = multicast_ability:GetLevel()
        if level > 0 then
            local two_times = multicast_ability:GetLevelSpecialValueFor( "multicast_2_times" , level - 1  )
            local three_times = multicast_ability:GetLevelSpecialValueFor( "multicast_3_times" , level - 1  )
            local four_times = multicast_ability:GetLevelSpecialValueFor( "multicast_4_times" , level - 1  )
            
            if RandomInt( 0,100 ) < two_times then multicast = 2 end
            if RandomInt( 0,100 ) < three_times then multicast = 3 end
            if RandomInt( 0,100 ) < four_times then multicast = 4 end
        end
    end
	
	if multicast > 1 then
		local effect_cast = ParticleManager:CreateParticle(
			"particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf",
			PATTACH_OVERHEAD_FOLLOW,
			caster
		)
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( multicast, 2, 0 ) )
		ParticleManager:ReleaseParticleIndex( effect_cast )
	end

	for i = 1, multicast do
		Timers:CreateTimer( (i-1)*0.4, function()
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
		end)
	end
end