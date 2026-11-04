function OnAttackLanded(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    if level > 0 then
        local need_attack = ability:GetLevelSpecialValueFor( "need_attack" , level - 1 )
        local mod = caster:FindModifierByName("modifier_invaders_creeps_air_aoe")
        mod:SetStackCount(mod:GetStackCount()+1)
        if mod:GetStackCount() >= need_attack then
            mod:SetStackCount(0)
            local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	        local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	        local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS

            local mass_damage = ability:GetLevelSpecialValueFor( "mass_damage" , level - 1 )
            local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1 )

	        local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)

	        for _,unit in ipairs(units) do
                ApplyCustomDamage(unit, caster, mass_damage, 6, nil)
	        end
        end
    end
end