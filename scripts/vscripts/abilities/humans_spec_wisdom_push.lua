function projectile( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target
	local particle_name = "particles/new/human_mage/kotl_illuminate.vpcf"
	-- Parameters
	local wave_speed = 1000
	local wave_width = 400
    local wave_distance = ability:GetLevelSpecialValueFor("radius", ability_level)
	--local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local interval = ability:GetLevelSpecialValueFor("interval", ability_level)
    local forward_direction = caster:GetForwardVector()
    local rots = {
        [DOTA_TEAM_GOODGUYS] = {180, -90, 0},
        [DOTA_TEAM_BADGUYS] = {90, 0, -90},
        [DOTA_TEAM_CUSTOM_1] = {180, 90, 0},
        [DOTA_TEAM_CUSTOM_2] = {90, 180, -90}
    }

    for i = 1, interval do
		Timers:CreateTimer( (i-1)*interval, function()
    		for i=1, #rots[caster:GetTeam()] do
    		    local wave_direction = (RotatePosition(Vector(0, 0, 0), QAngle(0, rots[caster:GetTeam()][i], 0), forward_direction)):Normalized()
    		    local wave_location = caster:GetAbsOrigin() + (5 *  wave_direction)

    		    ProjectileManager:CreateLinearProjectile( {
    		        Ability			= ability,
    		        EffectName			= particle_name,
    		        vSpawnOrigin		= wave_location,
    		        fDistance			= wave_distance,
    		        fStartRadius		= wave_width,
    		        fEndRadius			= wave_width,
    		        Source				= caster,
    		        bHasFrontalCone		= true,
    		        bReplaceExisting	= false,
    		        iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
    		        iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
    		        iUnitTargetType		= DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
    		        --	fExpireTime		= ,
    		        bDeleteOnHit		= false,
    		        vVelocity			= wave_direction * wave_speed,
    		        bProvidesVision		= false,
    		    } )
			end
    	end)
	end
end

function knockback( event )
	local vCaster = event.caster:GetAbsOrigin()
	local vTarget = event.target:GetAbsOrigin()
	local len = ( vTarget - vCaster ):Length2D()
	len = event.distance - event.distance * ( len / event.range )
	local knockbackModifierTable =
	{
		should_stun = 0,
		knockback_duration = event.duration,
		duration = event.duration,
		knockback_distance = len,
		knockback_height = event.height,
		center_x = event.caster:GetAbsOrigin().x,
		center_y = event.caster:GetAbsOrigin().y,
		center_z = event.caster:GetAbsOrigin().z
	}
	event.target:AddNewModifier( event.caster, nil, "modifier_knockback", knockbackModifierTable )
end