function CastShield( event )
	local caster = event.caster
    local ability = event.ability
    
    local hex_duration

    local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

    local radius = event.radius
    local max_targets = event.max_targets

    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
	for i = 1, max_targets do
        if units[i] then
            if units[i]:IsCustomHero() then
                hex_duration = event.hero_duration
            else
                hex_duration = event.creep_duration
            end
            units[i]:AddNewModifier(caster, ability, "modifier_sheepstick_debuff", {duration = hex_duration})
        end
    end
end