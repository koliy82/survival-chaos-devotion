function SplitShotLaunch( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	if ability_level < 0 then return end
	local attack_target = caster:GetAttackTarget()

	local team = caster:GetTeamNumber()
	local position = caster:GetAbsOrigin()
	local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
	local max_targets = ability:GetLevelSpecialValueFor("arrow_count", ability_level)
	
	if caster:HasModifier("modifier_elementals_creeps_range_strong_shot_buff") then
		max_targets = ability:GetLevelSpecialValueFor("arrow_count_trigger", ability_level)
	end

	local split_shot_projectile = caster:GetRangedProjectileName()
	local split_shot_projectile_speed = caster:GetProjectileSpeed()
	local split_shot_projectile_range = caster:Script_GetAttackRange() + 450

	local split_shot_targets = FindUnitsInRadius(team, position, nil, split_shot_projectile_range, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)

	for _,v in pairs(split_shot_targets) do
		if v ~= attack_target then
			local projectile_info = 
			{
				EffectName = split_shot_projectile,
				Ability = ability,
				vSpawnOrigin = caster_location,
				Target = v,
				Source = caster,
				bHasFrontalCone = false,
				iMoveSpeed = split_shot_projectile_speed,
				bReplaceExisting = false,
				bProvidesVision = false
			}
			ProjectileManager:CreateTrackingProjectile(projectile_info)
			max_targets = max_targets - 1
		end
		if max_targets <= 0 then break end
	end
end

function SplitShotDamage( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local arrow_damage = ability:GetLevelSpecialValueFor("arrow_damage", ability_level)

	-- if caster:HasModifier("modifier_elementals_creeps_range_strong_shot_buff") then
	-- 	arrow_damage = ability:GetLevelSpecialValueFor("arrow_damage_trigger", ability_level)
	-- end
	ApplyCustomDamage(target, caster, caster:GetAttackDamage() * arrow_damage / 100, caster.custom_damage_type, ability)
end