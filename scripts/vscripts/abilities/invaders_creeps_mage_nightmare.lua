function OnSpellStart( event )
	local caster	= event.caster
	local ability	= event.ability
	local modifier_name	= event.modifier
	
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local max_targets = ability:GetLevelSpecialValueFor("max_targets", ability:GetLevel() - 1)
	
	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO

	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, FIND_FARTHEST, false)
	
	for i,unit in ipairs(units) do
		if not unit:FindModifierByName(modifier_name) then
			ability:ApplyDataDrivenModifier( caster, unit, modifier_name, {})
			if i >= max_targets then break end
		end
	end
end