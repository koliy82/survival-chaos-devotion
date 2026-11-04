function OnProjectileHitUnit(keys)
	local caster = keys.caster
	local target = keys.target
	if target:IsAncient() then return end
	local ability = keys.ability
	if not ability then return end
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() -1)
	local damage_per_jump = ability:GetLevelSpecialValueFor("damage_per_jump", ability:GetLevel() -1)
	local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local targetFlag = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	local taget_origin = target:GetAbsOrigin()

	-- Finds the current instance of the ability by ensuring both current targets are the same
	local current
	for i=0,ability.instance do
		if ability.target[i] ~= nil then
			if ability.target[i] == target then
				current = i
			end
		end
	end


    ApplyCustomDamage(target, caster, ability.damage[current], 6, ability)

    ability.damage[current] = ability.damage[current] + damage_per_jump
	-- Decrements our jump count for this instance
	ability.jump_count[current] = ability.jump_count[current] - 1

	-- Checks if there are jumps left
	if ability.jump_count[current] > 0 then
		-- Finds units in the radius to jump to
		local units = FindUnitsInRadius(caster:GetTeamNumber(), taget_origin, nil, radius, targetTeam, targetType, targetFlag, FIND_CLOSEST, false)
        local new_target
		for _,unit in ipairs(units) do
			if unit ~= target then
				new_target = unit
				break
			end
        end
		-- Checks if there is a new target
		if new_target ~= nil then
            local info = 
            {
                Target = new_target,
                Source = target,
                Ability = ability,	
                EffectName = "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf",
                iMoveSpeed = 1100,
                vSourceLoc= taget_origin,                -- Optional (HOW)
                bDodgeable = true,                                -- Optional
                bProvidesVision = false,                          -- Optional
            }
            ProjectileManager:CreateTrackingProjectile(info)

			-- Sets the new target as the current target for this instance
			ability.target[current] = new_target
		else
			-- If there are no new targets, we set the current target to nil to indicate this instance is over
			ability.target[current] = nil
		end
	else
		-- If there are no more jumps, we set the current target to nil to indicate this instance is over
		ability.target[current] = nil
	end
end

function NewInstance(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	if target:IsAncient() then return end
	
	-- Keeps track of the total number of instances of the ability (increments on cast)
	if ability.instance == nil then
		ability.instance = 0
		ability.jump_count = {}
		ability.target = {}
		ability.damage = {}
	else
		ability.instance = ability.instance + 1
    end
    ability.damage[ability.instance] = caster:GetAttackDamage()
	
	-- Sets the total number of jumps for this instance (to be decremented later)
	ability.jump_count[ability.instance] = ability:GetLevelSpecialValueFor("jump_count", (ability:GetLevel() -1)) + 1
	-- Sets the first target as the current target for this instance
	ability.target[ability.instance] = target

	local info = 
	{
		Target = target,
		Source = caster,
		Ability = ability,	
		EffectName = "particles/units/heroes/hero_hoodwink/hoodwink_acorn_shot_tracking.vpcf",
		iMoveSpeed = 1100,
		vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)
		bDodgeable = true,                                -- Optional
		bProvidesVision = false,                          -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)
end