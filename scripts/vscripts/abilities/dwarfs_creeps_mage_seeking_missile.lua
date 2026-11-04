--[[
	CHANGELIST:
	09.01.2015 - Standardized variables
]]

--[[
	Author: kritth
	Date: 7.1.2015.
	Fire missiles if there are targets, else play dud
]]
function heat_seeking_missile_seek_targets( keys )
	-- Variables
	local caster = keys.caster
	local ability = keys.ability
	local particleName = "particles/units/heroes/hero_tinker/tinker_missile.vpcf"
	local modifierDudName = "modifier_heat_seeking_missile_dud"
	local projectileSpeed = ability:GetLevelSpecialValueFor( "speed", ability:GetLevel() - 1 )
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local max_targets = ability:GetLevelSpecialValueFor( "targets", ability:GetLevel() - 1 )
	local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local targetFlag = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	local projectileDodgable = false
	local projectileProvidesVision = false
	
	-- pick up x nearest target heroes and create tracking projectile targeting the number of targets
	local units = FindUnitsInRadius(
		caster:GetTeamNumber(), caster:GetAbsOrigin(), caster, radius, targetTeam, targetType, targetFlag, FIND_CLOSEST, false
	)
	
	-- Seek out target
	local count = 0
	for k, v in pairs( units ) do
		if count < max_targets then
			local projTable = {
				Target = v,
				Source = caster,
				Ability = ability,
				EffectName = particleName,
				bDodgeable = projectileDodgable,
				bProvidesVision = projectileProvidesVision,
				iMoveSpeed = projectileSpeed, 
				vSpawnOrigin = caster:GetAbsOrigin()
			}
			ProjectileManager:CreateTrackingProjectile( projTable )
			count = count + 1
		else
			break
		end
	end
	
	-- If no unit is found, fire dud
	if count == 0 then
		ability:ApplyDataDrivenModifier( caster, caster, modifierDudName, {} )
	end
end
