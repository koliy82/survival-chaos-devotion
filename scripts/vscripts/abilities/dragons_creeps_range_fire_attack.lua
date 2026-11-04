function OnAttackLanded(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    local chance = ability:GetLevelSpecialValueFor( "chance" , level - 1 )
    if target:HasModifier("modifier_dragons_race_bonus_burning") then
        chance = chance + ability:GetLevelSpecialValueFor( "bonus_chance" , level - 1 )
    end
    if level > 0 and RollPercentage(chance) then
        local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	    local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	    local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO

        local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1 )

	    local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)

	    for _,unit in ipairs(units) do
            ability:ApplyDataDrivenModifier(caster, unit, "modifier_dragons_creeps_range_fire_attack_debuff", {})
	    end
    end
end