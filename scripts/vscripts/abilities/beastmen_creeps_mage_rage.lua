function CastShield( event )
	local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel() - 1

    local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO

    local radius = ability:GetLevelSpecialValueFor( "radius" , level  )
    local max_targets = ability:GetLevelSpecialValueFor( "max_targets" , level  )

    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
	for i = 1, max_targets do
        for _,unit in ipairs(units) do
            if unit:GetLevel() < 3 and not unit:FindModifierByName("modifier_beastmen_creeps_mage_rage") then
	    	    ability:ApplyDataDrivenModifier(caster, unit, "modifier_beastmen_creeps_mage_rage", {})
                break
            end
        end
    end
end