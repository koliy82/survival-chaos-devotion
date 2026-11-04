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

	local split_shot_projectile = caster:GetRangedProjectileName()
	local split_shot_projectile_speed = caster:GetProjectileSpeed()
	local split_shot_projectile_range = caster:Script_GetAttackRange() + 100

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

	ApplyCustomDamage(target, caster, caster:GetAttackDamage() * arrow_damage / 100, caster.custom_damage_type, ability)
end

function SpecDebuff( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = caster:FindAbilityByName("nights_creeps_range_spec")
    if not ability then return end

	local ability_level = ability:GetLevel() - 1
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

    local caster_mod_name = "modifier_nights_creeps_range_spec_buff"
    local ModifierCount = 0
	for i=0,caster:GetModifierCount() do
		if caster_mod_name==caster:GetModifierNameByIndex(i) then
			ModifierCount = ModifierCount + 1
		end
	end
    if ModifierCount >= max_stacks then return end

    local target_mod_name = "modifier_nights_creeps_range_spec_debuff"
    ModifierCount = 0
	for i=0,target:GetModifierCount() do
		if caster_mod_name==target:GetModifierNameByIndex(i) then
			ModifierCount = ModifierCount + 1
		end
	end
    if ModifierCount >= max_stacks then return end

    --ability:ApplyDataDrivenModifier(caster, caster, caster_mod_name, {})
    ability:ApplyDataDrivenModifier(caster, target, target_mod_name, {})
end