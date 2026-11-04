
--[[Author: Pizzalol,Noya
	Date: February 24, 2016
	Initializes the Illuminate and swaps the abilities]]
function IlluminateStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	ability.illuminate_position = caster:GetAbsOrigin()
	ability.illuminate_start_time = GameRules:GetGameTime()
    Timers:CreateTimer(0.1,function()
		ability.illuminate_direction = caster:GetForwardVector()
    end)
end

--[[Author: Pizzalol
	Date: February 24, 2016
	Calculates the channel time according to the starting time and current time
	Calculates the damage according to the channel time
	Creates a projectile based on the casters starting channeling position]]
function IlluminateEnd( keys )
	local caster = keys.caster
	local ability = keys.ability

	-- Ability variables	
	ability.illuminate_damage = 0
	local damage_per_second = ability:GetLevelSpecialValueFor("damage_per_second", (ability:GetLevel() - 1))

	-- Projectile variables
	local projectile_name = keys.projectile_name
	local projectile_speed = ability:GetLevelSpecialValueFor("speed", (ability:GetLevel() - 1))
	local projectile_distance = ability:GetLevelSpecialValueFor("range", (ability:GetLevel() - 1))
	local projectile_radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() - 1))


	-- Calculating the Illuminate channel time and damage
	ability.illuminate_channel_time = GameRules:GetGameTime() - ability.illuminate_start_time
	ability.illuminate_damage = ability.illuminate_channel_time * damage_per_second


	-- Create projectile
	local projectileTable =
	{
		EffectName = projectile_name,
		Ability = ability,
		vSpawnOrigin = ability.illuminate_position,
		vVelocity = ability.illuminate_direction * projectile_speed,
		fDistance = projectile_distance,
		fStartRadius = projectile_radius,
		fEndRadius = projectile_radius,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = true,
		iUnitTargetTeam = ability:GetAbilityTargetTeam(),
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
		iUnitTargetType = ability:GetAbilityTargetType()
	}
	ability.illuminate_projectileID = ProjectileManager:CreateLinearProjectile( projectileTable )
end

--[[Author: Pizzalol
	Date: February 24, 2016
	Deals damage according to the channel time]]
function IlluminateProjectileHit( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

    ApplyCustomDamage(target, caster, ability.illuminate_damage, 6, ability)
end

--[[Author: Pizzalol
	Date: 24.01.2015.
	Stops the ability channel]]
function IlluminateStop( keys )
	local caster = keys.caster

	caster:Stop()
end