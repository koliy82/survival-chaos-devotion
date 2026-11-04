function OnDeath( event )
	local ability = event.ability
	local caster = event.caster
    local level = ability:GetLevel()

    if caster:HasModifier("modifier_elementals_fire_buff") then
	    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ability:GetLevelSpecialValueFor( "fire_radius" , level - 1 ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false)
	    for k, v in pairs(units) do
	    	ApplyCustomDamage(v, caster, ability:GetLevelSpecialValueFor( "fire_damage" , level - 1 ), 6, ability)
	    end
    elseif caster:HasModifier("modifier_elementals_water_buff") then
	    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ability:GetLevelSpecialValueFor( "water_radius" , level - 1 ), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false)
	    for k, v in pairs(units) do
	    	v:Heal( ability:GetLevelSpecialValueFor( "water_heal" , level - 1 ), ability )
	    end
    elseif caster:HasModifier("modifier_elementals_air_buff") then
	    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ability:GetLevelSpecialValueFor( "air_radius" , level - 1 ), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false)
	    for k, v in pairs(units) do
            ability:ApplyDataDrivenModifier(caster, v, "modifier_elementals_creeps_death_pass_air", {})
	    end
    elseif caster:HasModifier("modifier_elementals_earth_buff") then
	    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ability:GetLevelSpecialValueFor( "earth_radius" , level - 1 ), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false)
	    for k, v in pairs(units) do
            ability:ApplyDataDrivenModifier(caster, v, "modifier_elementals_creeps_death_pass_earth", {})
	    end
    elseif caster:HasModifier("modifier_elementals_storm_buff") then
	    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ability:GetLevelSpecialValueFor( "storm_radius" , level - 1 ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false)
	    for k, v in pairs(units) do
            v:Purge(true, false, false, false, false)
            v:AddNewModifier(caster, ability, "modifier_stunned", {duration = ability:GetLevelSpecialValueFor( "storm_duration" , level - 1 )})
	    end
    elseif caster:HasModifier("modifier_elementals_void_buff") then
	    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, ability:GetLevelSpecialValueFor( "void_radius" , level - 1 ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false)
	    for k, v in pairs(units) do
            ability:ApplyDataDrivenModifier(caster, v, "modifier_elementals_creeps_death_pass_void", {})
	    end
    end
end