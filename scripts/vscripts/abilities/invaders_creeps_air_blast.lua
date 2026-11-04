function OnSpellStart( event )
	local caster	= event.caster
	local ability	= event.ability
	
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local max_targets = ability:GetLevelSpecialValueFor("max_targets", ability:GetLevel() - 1)
	
	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, FIND_FARTHEST, false)
	
	for i,unit in ipairs(units) do
		
		local projectile_info = 
		{
			EffectName = "particles/econ/items/queen_of_pain/qop_2022_immortal/queen_2022_scream_of_pain_projectile_blue.vpcf",
			Ability = ability,
			vSpawnOrigin = caster:GetAbsOrigin(),
			Target = unit,
			Source = caster,
			bHasFrontalCone = false,
			iMoveSpeed = 700,
			bReplaceExisting = false,
			bProvidesVision = false
		}
		ProjectileManager:CreateTrackingProjectile(projectile_info)

		if i >= max_targets then break end
	end
end