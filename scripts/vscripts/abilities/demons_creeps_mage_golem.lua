LinkLuaModifier( "agr_mod", "modifiers/agr_mod.lua", LUA_MODIFIER_MOTION_NONE )
function OnCreated(keys)
	local ability = keys.ability
	local target = keys.target
	local radius  = keys.radius

	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO

	local units = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
	
	for _, unit in pairs( units ) do
		unit:AddNewModifier(target, ability, "agr_mod", {duration = 1})
	end
end