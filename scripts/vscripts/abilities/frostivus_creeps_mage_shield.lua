function CastShield( event )
	local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel() - 1
    
    local duration

    local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

    local radius = ability:GetLevelSpecialValueFor( "radius" , level  )
    local max_targets = ability:GetLevelSpecialValueFor( "max_targets" , level  )

    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, FIND_FARTHEST, false)
	for i = 1, max_targets do
        for _,unit in ipairs(units) do
            if not unit:FindModifierByName("modifier_frostivus_creeps_mage_shield") then
                if unit:IsCustomHero() then
                    duration = ability:GetLevelSpecialValueFor("duration_on_hero", level )
                else
                    duration = ability:GetLevelSpecialValueFor("duration", level )
                end
	    	    ability:ApplyDataDrivenModifier(caster, unit, "modifier_frostivus_creeps_mage_shield", {Duration = duration})
                break
            end
        end
    end
end