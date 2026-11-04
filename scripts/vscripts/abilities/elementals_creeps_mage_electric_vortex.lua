function OnSpellStart( event )
	local ability = event.ability
	local caster = event.caster
    local level = ability:GetLevel()

    local max_targets = ability:GetLevelSpecialValueFor( "max_targets", level - 1 )
    if caster:HasModifier("modifier_elementals_ice_buff") then
        max_targets = ability:GetLevelSpecialValueFor( "bonus_targets", level - 1 )
    end
    local radius = ability:GetLevelSpecialValueFor( "radius", level - 1 )
	
    local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
    local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
    local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
    
    
    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
        
    for i,unit in pairs(units) do
        ability:ApplyDataDrivenModifier(caster, unit, "modifier_elementals_creeps_mage_electric_vortex_damage", {})
        if i >= max_targets then break end
    end
end