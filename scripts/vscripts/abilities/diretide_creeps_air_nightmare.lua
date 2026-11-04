function OnSpellStart( event )
	local caster	= event.caster
	local ability	= event.ability
	local modifier_name	= event.modifier
	
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	
	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO

	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
	
	for i,unit in ipairs(units) do
		if unit:HasFlyMovementCapability() and not unit:FindModifierByName(modifier_name) then
			ability:ApplyDataDrivenModifier( caster, unit, modifier_name, {})
			break
		end
	end
end