function OnIntervalThink( event )
	local caster = event.caster
	local ability = event.ability
	local ability_level = ability:GetLevel() - 1

	local particle_name = "particles/items2_fx/paintball.vpcf"
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )
	
	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
	for _,unit in ipairs(units) do
        local info = 
		{
			Target = unit,
			Source = caster,
			Ability = ability,	
			EffectName = particle_name,
		    iMoveSpeed = 500,
			vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW) поднять
			bDrawsOnMinimap = false,                          -- Optional
		    bDodgeable = false,                                -- Optional
		    bIsAttack = false,                                -- Optional
		    bVisibleToEnemies = true,                         -- Optional
		    bReplaceExisting = false,                         -- Optional
		    --flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
			bProvidesVision = true,                           -- Optional
			iVisionRadius = 100,                              -- Optional
			iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
		}
		projectile = ProjectileManager:CreateTrackingProjectile(info)
		break
	end
end