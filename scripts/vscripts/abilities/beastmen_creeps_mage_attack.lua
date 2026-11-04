function OnAttackLanded(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
    local level = ability:GetLevel()

	if level > 0 and ability:IsCooldownReady() and caster:GetMana() >= ability:GetManaCost(level - 1) then
		ability:StartCooldown(ability:GetEffectiveCooldown(level))
		caster:SpendMana(ability:GetManaCost(level - 1), ability)
		
		local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
		local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

    	local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1  )
    	local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1  )

    	local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)
		
		if #units > 1 then
			local info = 
			{
				Target = units[2],
				Source = target,
				Ability = ability,	
				EffectName = caster:GetRangedProjectileName(),
				iMoveSpeed = caster:GetProjectileSpeed(),
				vSourceLoc= target:GetAbsOrigin(),                -- Optional (HOW)
				bDodgeable = false,                                -- Optional
				bProvidesVision = false,                          -- Optional
			}
			ProjectileManager:CreateTrackingProjectile(info)
    		ApplyCustomDamage(units[2], caster, damage, 6, ability)
		end

		if #units > 2 then
			local info = 
			{
				Target = units[3],
				Source = target,
				Ability = ability,	
				EffectName = caster:GetRangedProjectileName(),
				iMoveSpeed = caster:GetProjectileSpeed(),
				vSourceLoc= target:GetAbsOrigin(),                -- Optional (HOW)
				bDodgeable = false,                                -- Optional
				bProvidesVision = false,                          -- Optional
			}
			ProjectileManager:CreateTrackingProjectile(info)
    		ApplyCustomDamage(units[3], caster, damage, 6, ability)
		end
	end
end