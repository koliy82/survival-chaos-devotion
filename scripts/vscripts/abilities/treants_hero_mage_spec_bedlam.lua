function CreateWisp(keys)
	local caster = keys.caster
	local ability = keys.ability
	local position = ability:GetCursorPosition()
	local owner = caster:GetOwner()
	
	caster.bedlam = CreateUnitByName("npc_dota_treants_bedlam_wisp", position, true, owner, owner, caster:GetTeam())
	
	ability:ApplyDataDrivenModifier( caster, caster.bedlam, "modifier_modifier_treants_hero_mage_spec_bedlam_wisp", {} )
end

function OnIntervalThink(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local targetFlag = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	local radius = ability:GetLevelSpecialValueFor("attack_range",( ability:GetLevel() - 1 ) )
	local units = FindUnitsInRadius( caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, targetTeam, targetType, targetFlag, FIND_CLOSEST, false)

	if #units > 0 then
		local info = 
		{
			Target = units[1],
			Source = target,
			Ability = ability,	
			EffectName = "particles/units/heroes/hero_dark_willow/dark_willow_willowisp_base_attack.vpcf",
			iMoveSpeed = 1000,
			vSourceLoc= target:GetAbsOrigin(),
			bDodgeable = false,
			bProvidesVision = false
		}
		ProjectileManager:CreateTrackingProjectile(info)
	end
	if #units > 1 and keys.targets == 2 then
		local info = 
		{
			Target = units[2],
			Source = target,
			Ability = ability,	
			EffectName = "particles/units/heroes/hero_dark_willow/dark_willow_willowisp_base_attack.vpcf",
			iMoveSpeed = 1000,
			vSourceLoc= target:GetAbsOrigin(),
			bDodgeable = false,
			bProvidesVision = false
		}
		ProjectileManager:CreateTrackingProjectile(info)
	end
end

function DestroyWisp(keys)
	local caster = keys.caster
	
	caster.bedlam:ForceKill(false)
	StopSoundEvent(keys.sound, caster)
end