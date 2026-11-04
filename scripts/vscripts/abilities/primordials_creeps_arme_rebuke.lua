function OnAttackLanded(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
    local level = ability:GetLevel()
		
	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

    local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1  )
    local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1  )
    local heal = ability:GetLevelSpecialValueFor( "heal" , level - 1  )
    local max_heal_targets = ability:GetLevelSpecialValueFor( "max_heal_targets" , level - 1  )

    local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)
		
	for k, v in pairs( units ) do
		ApplyCustomDamage(v, caster, damage, 6, ability)
		if k <= max_heal_targets then
			caster:Heal( heal, ability )
		end
	end
end