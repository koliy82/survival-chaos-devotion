function OnSpellStart(keys)
	local caster = keys.caster
	local ability = keys.ability
    local level = ability:GetLevel()
		
	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

    local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1  )
    local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1  )

    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
	for _,unit in ipairs(units) do
        ApplyCustomDamage(unit, caster, damage, 6, ability)
		if not unit:IsAlive() then
			ability:EndCooldown()
		end
    end
end