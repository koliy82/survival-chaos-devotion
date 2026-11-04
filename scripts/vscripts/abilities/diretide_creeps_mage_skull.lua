function NewInstance(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	if target:IsAncient() then return end

	local info = 
	{
		Target = target,
		Source = caster,
		Ability = ability,	
		EffectName = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_enemy.vpcf",
		iMoveSpeed = 900,
		vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)
		bDodgeable = false,                                -- Optional
		bProvidesVision = false,                          -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)

	local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local targetFlag = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() -1)

	local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, targetTeam, targetType, targetFlag, FIND_CLOSEST, false)
    local new_target

    if #units > 0 then
        new_target = units[2]
    end

	if new_target then
        local info2 = 
        {
            Target = new_target,
            Source = target,
            Ability = ability,	
            EffectName = "particles/units/heroes/hero_necrolyte/necrolyte_pulse_enemy.vpcf",
            iMoveSpeed = 900,
            vSourceLoc= target:GetAbsOrigin(),                -- Optional (HOW)
            bDodgeable = false,                                -- Optional
            bProvidesVision = false,                          -- Optional
        }
        ProjectileManager:CreateTrackingProjectile(info2)
	end
end