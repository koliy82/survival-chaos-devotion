function OnIntervalThink(keys)
	local caster = keys.caster
	local ability = keys.ability
    local level = ability:GetLevel()

	local target_teams = DOTA_UNIT_TARGET_TEAM_BOTH
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NONE

	local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1  )

	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)

	local mod = caster:FindModifierByName("modifier_developer_creeps_counter_counter")

	mod:SetStackCount(#units)
end