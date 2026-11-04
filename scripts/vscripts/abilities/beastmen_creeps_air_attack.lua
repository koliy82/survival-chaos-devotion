function OnAttackLanded(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
    local level = ability:GetLevel()
		
	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NONE

    local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1  )
    local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1  )
    local building_damage = ability:GetLevelSpecialValueFor( "building_damage" , level - 1  )

    local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)
	
	if #units > 1 then
		if units[2]:IsAncient() then
			damage = damage * building_damage / 100
		end
		local info = 
		{
			Target = units[2],
			Source = target,
			Ability = ability,	
			EffectName = "particles/base_attacks/fountain_attack.vpcf",
			iMoveSpeed = 900,
			vSourceLoc= target:GetAbsOrigin(),                -- Optional (HOW)
			bDodgeable = false,                                -- Optional
			bProvidesVision = false,                          -- Optional
		}
		ProjectileManager:CreateTrackingProjectile(info)
    	ApplyCustomDamage(units[2], caster, caster:GetAttackDamage() * damage / 100, caster.custom_damage_type, ability)
	end
end