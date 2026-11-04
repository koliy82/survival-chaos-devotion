function tripple_gush( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target
    local id = caster:GetPlayerOwnerID()
	local particle_name = "particles/units/heroes/hero_tidehunter/tidehunter_gush_upgrade.vpcf"
	-- Parameters
	local wave_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
	local wave_width = ability:GetLevelSpecialValueFor("wave_width", ability_level)
    local wave_distance = ability:GetLevelSpecialValueFor("wave_distance", ability_level)
    local forward_direction = caster:GetForwardVector()
    local rots = {
        [1] = {0, 45, 90, 135, 180, 225, 270, 315}
    }
    
    
    for i=1, #rots[1] do
        local wave_direction = (RotatePosition(Vector(0, 0, 0), QAngle(0, rots[1][i], 0), forward_direction)):Normalized()
        local wave_location = caster:GetAbsOrigin() + (5 *  wave_direction)

        ProjectileManager:CreateLinearProjectile( {
            Ability			= ability,
            EffectName			= particle_name,
            vSpawnOrigin		= wave_location,
            fDistance			= wave_distance,
            fStartRadius		= wave_width,
            fEndRadius			= wave_width,
            Source			= caster,
            bHasFrontalCone		= true,
            bReplaceExisting		= false,
            iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetFlags		= DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
            iUnitTargetType		= DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
            --	fExpireTime			= ,
            bDeleteOnHit		= false,
            vVelocity			= wave_direction * wave_speed,
            bProvidesVision		= false,
        } )
    end
end