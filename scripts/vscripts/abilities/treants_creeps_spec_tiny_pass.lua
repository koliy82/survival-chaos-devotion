function OnAllyDeath(event)
    local caster = event.caster
    local ability = event.ability
    --local level = ability:GetLevel()
    if ability then
        local radius = event.radius
	
	    local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	    local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
	    local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO

	    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)

	    for _,unit in ipairs(units) do
	    	if unit:FindModifierByName("modifier_treants_creeps_spec_tiny_pass") then
	    		ability:ApplyDataDrivenModifier( caster, unit, "modifier_treants_creeps_spec_tiny_pass_buff", {})
	    	end
	    end
    end
end