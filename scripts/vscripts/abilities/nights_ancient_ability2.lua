function SpellStart(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()

    for k, v in pairs(_G.playersinfo[id].baracks) do
        ability:ApplyDataDrivenModifier(caster, v, "modifier_nights_ancient_ability2", {})
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        ability:ApplyDataDrivenModifier(caster, v, "modifier_nights_ancient_ability2", {})
    end
	--ability:ApplyDataDrivenModifier(caster, caster, "modifier_nights_ancient_ability2", {})
end

function moon_glaive_start_create_dummy( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Create the dummy unit which keeps track of bounces
	caster:AddAbility("nights_ancient_ability2_dummy")
	local dummy_ability = caster:FindAbilityByName("nights_ancient_ability2_dummy")

	-- Ability variables
	dummy_ability.damage_type = caster.custom_damage_type
	dummy_ability.damage = caster:GetAttackDamage()
	dummy_ability.bounceTable = {}
	dummy_ability.bounceCount = 0
	dummy_ability.maxBounces = ability:GetLevelSpecialValueFor("bounces", ability_level)
	dummy_ability.bounceRange = ability:GetLevelSpecialValueFor("range", ability_level) 
	--dummy_ability.dmgMultiplier = ability:GetLevelSpecialValueFor("damage_reduction_percent", ability_level) / 100
	dummy_ability.original_ability = ability

    dummy_ability.particle_name = caster:GetRangedProjectileName()
    dummy_ability.projectile_speed = caster:GetProjectileSpeed()
	dummy_ability.projectileFrom = target
	dummy_ability.projectileTo = nil

	-- Find the closest target that fits the search criteria
	local iTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local iType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local iFlag = DOTA_UNIT_TARGET_FLAG_NONE
	local bounce_targets = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, dummy_ability.bounceRange, iTeam, iType, iFlag, FIND_CLOSEST, false)

	-- It has to be a target different from the current one
	for _,v in pairs(bounce_targets) do
		if v ~= target then
			dummy_ability.projectileTo = v
			break
		end
	end

	-- If we didnt find a new target then kill the dummy and end the function
	if dummy_ability.projectileTo == nil then
		caster:RemoveAbility("nights_ancient_ability2_dummy")
	else
	-- Otherwise continue with creating a bounce projectile
		dummy_ability.bounceCount = dummy_ability.bounceCount + 1
		local info = {
			Target = dummy_ability.projectileTo,
			Source = dummy_ability.projectileFrom,
			EffectName = dummy_ability.particle_name,
			Ability = dummy_ability,
			bDodgeable = false,
			bProvidesVision = false,
			iMoveSpeed = dummy_ability.projectile_speed,
			iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
    	}
    	ProjectileManager:CreateTrackingProjectile( info )
    end
end

--[[Author: Pizzalol
	Date: 29.09.2015.
	Creates bounce projectiles to the nearest target if there is any]]
function moon_glaive_bounce( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	-- Initialize the damage table
	-- local damage_table = {}
	-- damage_table.attacker = caster:GetOwner()
	-- damage_table.victim = target
	-- damage_table.ability = ability.original_ability
	-- damage_table.damage_type = DAMAGE_TYPE_PHYSICAL
	-- damage_table.damage = ability.damage * (1 - ability.dmgMultiplier)

	if ability == nil or ability.damage == nil or ability.damage_type == nil then return end
	if target == nil then return end

	--ability.damage = ability.damage * (1 - ability.dmgMultiplier)
	-- Save the new damage for future bounces

	-- Reset target data and find new targets
	ability.projectileFrom = ability.projectileTo
	ability.projectileTo = nil

	local iTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local iType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local iFlag = DOTA_UNIT_TARGET_FLAG_NONE
	local bounce_targets = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, ability.bounceRange, iTeam, iType, iFlag, FIND_CLOSEST, false)

	ApplyCustomDamage(target, caster, ability.damage, ability.damage_type)

	-- If we exceeded the bounce limit then remove the dummy and stop the function
	if ability.bounceCount >= ability.maxBounces then
		caster:RemoveAbility("nights_ancient_ability2_dummy")
		return
	end
	
	-- Find a new target that is not the current one
	for _,v in pairs(bounce_targets) do
		if v ~= target then
			ability.projectileTo = v
			break
		end
	end

	-- If we didnt find a new target then kill the dummy
	if ability.projectileTo == nil then
		caster:RemoveAbility("nights_ancient_ability2_dummy")
	else
	-- Otherwise increase the bounce count and create a new bounce projectile
		ability.bounceCount = ability.bounceCount + 1
		local info = {
        Target = ability.projectileTo,
        Source = ability.projectileFrom,
        EffectName = ability.particle_name,
        Ability = ability,
        bDodgeable = false,
        bProvidesVision = false,
        iMoveSpeed = ability.projectile_speed,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
    	}
    	ProjectileManager:CreateTrackingProjectile( info )
    end
end