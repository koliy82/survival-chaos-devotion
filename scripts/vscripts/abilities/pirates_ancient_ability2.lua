function tripple_gush( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target
    local id = caster:GetPlayerOwnerID()
	local particle_name = "particles/econ/items/kunkka/kunkka_immortal/kunkka_immortal_ghost_ship.vpcf"
	-- Parameters
	local wave_speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
	local wave_width = ability:GetLevelSpecialValueFor("wave_width", ability_level)
    local wave_distance = ability:GetLevelSpecialValueFor("wave_distance", ability_level)
    local radius = ability:GetLevelSpecialValueFor("exp_radius", ability_level)
    local exp_damage = ability:GetLevelSpecialValueFor("exp_damage", ability_level)
    local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)
    local forward_direction = caster:GetForwardVector()
    local casterLoc = caster:GetAbsOrigin()
    local rots = {
        [1] = {180, -90, 0},
        [2] = {90, 0, -90},
        [3] = {180, 90, 0},
        [4] = {90, 180, -90}
    }
    if _G.duos then
        rots = {
            [1] = {180, -90, 0},
            [2] = {0, 90, 180},
            [3] = {180, -90, 0},
            [4] = {180, 90, 0},
        }
    end
    
    
    for i=1, #rots[_G.playersinfo[id].base_pos] do
        local wave_direction = (RotatePosition(Vector(0, 0, 0), QAngle(0, rots[_G.playersinfo[id].base_pos][i], 0), forward_direction)):Normalized()
        local wave_location = casterLoc + (5 *  wave_direction)

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
        Timers:CreateTimer( 3, function()
            local impactPoint = casterLoc + (wave_distance *  wave_direction)
			local units = FindUnitsInRadius(
				caster:GetTeamNumber(), impactPoint, caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false
			)
			
			local dummy = CreateUnitByName( "npc_dummy_unit", impactPoint, false, caster, caster, caster:GetTeamNumber() )
			StartSoundEvent( "Ability.Ghostship.crash", dummy )
			dummy:ForceKill( true )
			
			for k, v in pairs( units ) do
				if not v:IsMagicImmune() then
					ApplyCustomDamage(v, caster, exp_damage, 6, ability)
				end
				
				v:AddNewModifier( caster, nil, "modifier_stunned", { Duration = stun_duration } )
			end
		end
	)
    end
end