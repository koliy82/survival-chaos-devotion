function WhirlingAxesRanged( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	-- local target_point = keys.target_points[1]
	local target_point = keys.target:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local width_start = ability:GetLevelSpecialValueFor("width_start", ability_level)
	local width_end = ability:GetLevelSpecialValueFor("width_end", ability_level)
	local axe_speed = ability:GetLevelSpecialValueFor("axe_speed", ability_level)
	local axe_range = ability:GetLevelSpecialValueFor("axe_range", ability_level)
	local axe_spread = ability:GetLevelSpecialValueFor("axe_spread", ability_level)
	local axe_count = ability:GetLevelSpecialValueFor("axe_count", ability_level)
	local axe_projectile = keys.axe_projectile
	caster.whirling_axes_ranged_hit_table = {}

	-- Initial angle calculation
	local angle = axe_spread / axe_count -- The angle between the axes
	local direction = (target_point - caster_location):Normalized()
	local axe_angle_count = math.floor(axe_count / 2) -- Number of axes for each direction
	local angle_left = QAngle(0, angle, 0) -- Rotation angle to the left
	local angle_right = QAngle(0, -angle, 0) -- Rotation angle to the right

	-- Check if its an uneven number of axes
	-- If it is then create the middle axe
	if axe_count % 2 ~= 0 then
		local projectileTable =
		{
			EffectName = axe_projectile,
			Ability = ability,
			vSpawnOrigin = caster_location,
			vVelocity = direction * axe_speed,
			fDistance = axe_range,
			fStartRadius = width_start,
			fEndRadius = width_end,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = ability:GetAbilityTargetTeam(),
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			iUnitTargetType = ability:GetAbilityTargetType(),
			bProvidesVision = true,
			iVisionRadius = 100,
			iVisionTeamNumber = caster:GetTeamNumber()
		}
		ProjectileManager:CreateLinearProjectile(projectileTable)
	end

	local new_angle = QAngle(0,0,0) -- Rotation angle

	-- Create axes that spread to the right
	for i = 1, axe_angle_count do
		-- Angle calculation		
		new_angle.y = angle_right.y * i

		-- Calculate the new position after applying the angle and then get the direction of it			
		local position = RotatePosition(caster_location, new_angle, target_point)	
		local position_direction = (position - caster_location):Normalized()

		-- Create the axe projectile
		local projectileTable =
		{
			EffectName = axe_projectile,
			Ability = ability,
			vSpawnOrigin = caster_location,
			vVelocity = position_direction * axe_speed,
			fDistance = axe_range,
			fStartRadius = 0,
			fEndRadius = 0,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = ability:GetAbilityTargetTeam(),
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			iUnitTargetType = ability:GetAbilityTargetType(),
			bProvidesVision = true,
			iVisionRadius = 100,
			iVisionTeamNumber = caster:GetTeamNumber()
		}
		ProjectileManager:CreateLinearProjectile(projectileTable)
	end

	-- Create axes that spread to the left
	for i = 1, axe_angle_count do
		-- Angle calculation
		new_angle.y = angle_left.y * i

		-- Calculate the new position after applying the angle and then get the direction of it	
		local position = RotatePosition(caster_location, new_angle, target_point)	
		local position_direction = (position - caster_location):Normalized()

		-- Create the axe projectile
		local projectileTable =
		{
			EffectName = axe_projectile,
			Ability = ability,
			vSpawnOrigin = caster_location,
			vVelocity = position_direction * axe_speed,
			fDistance = axe_range,
			fStartRadius = 0,
			fEndRadius = 0,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = ability:GetAbilityTargetTeam(),
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			iUnitTargetType = ability:GetAbilityTargetType(),
			bProvidesVision = true,
			iVisionRadius = 100,
			iVisionTeamNumber = caster:GetTeamNumber()
		}
		ProjectileManager:CreateLinearProjectile(projectileTable)
	end
end

function WhirlingAxesRangedHit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local sound = keys.sound

	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)

	-- Check if the target has been hit before
	local hit_check = false

	for _,unit in ipairs(caster.whirling_axes_ranged_hit_table) do
		if unit == target then
			hit_check = true
			break
		end
	end

	-- If the target hasnt been hit before then insert it into the hit table to keep track of it
	if not hit_check then
		table.insert(caster.whirling_axes_ranged_hit_table, target)

		-- Play the sound
		EmitSoundOn(sound, target)
        ApplyCustomDamage(target, caster, damage, 6)
	end
end