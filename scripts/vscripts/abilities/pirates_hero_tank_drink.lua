function OnSpellStart( event )
	local caster = event.caster
    local ability = event.ability
    
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )

    local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
	
    for _,unit in ipairs(units) do
        if unit:IsCustomHero() then
            ability:ApplyDataDrivenModifier(caster, unit, "modifier_pirates_hero_tank_drink_heroes", {Duration = duration})
        else
            ability:ApplyDataDrivenModifier(caster, unit, "modifier_pirates_hero_tank_drink_units", {Duration = duration})
        end
    end

	local debuff_ability = caster:FindAbilityByName("pirates_hero_tank_hangover")
    if debuff_ability and debuff_ability:GetLevel() > 0 then
        local max_stack = debuff_ability:GetLevelSpecialValueFor( "max_stack" , debuff_ability:GetLevel() - 1 )
        local stun_duration = debuff_ability:GetLevelSpecialValueFor( "duration" , debuff_ability:GetLevel() - 1 )
        local mod = caster:FindModifierByName("modifier_pirates_hero_tank_hangover")
        mod:SetStackCount(mod:GetStackCount()+1)
        if mod:GetStackCount() >= max_stack then
            mod:SetStackCount(0)
            caster:Purge(true, true, false, true, false)
            caster:RemoveModifierByName("modifier_pirates_hero_tank_drink_heroes")
            debuff_ability:ApplyDataDrivenModifier(caster, caster, "modifier_pirates_hero_tank_hangover_debuff", {})
            caster:AddNewModifier( caster, nil, "modifier_stunned", { Duration = stun_duration } )
        end
    end
end