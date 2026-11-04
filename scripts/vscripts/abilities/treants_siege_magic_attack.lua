function OnAttackLanded(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
	local level = ability:GetLevel()
    
	local radius = ability:GetLevelSpecialValueFor("radius", level - 1)
	local damage = ability:GetLevelSpecialValueFor("damage", level - 1)
	local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local targetFlag = DOTA_UNIT_TARGET_FLAG_NONE

    local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, targetTeam, targetType, targetFlag, FIND_ANY_ORDER, false)
    for k,v in pairs(units) do
        ability:ApplyDataDrivenModifier(caster, v, "modifier_magic_attack_debuff_ats", {})
        if string.find(v:GetUnitName(), "barrack") ~= nil then
            ability:ApplyDataDrivenModifier(caster, v, "modifier_magic_attack_debuff", {})
        else
            ApplyCustomDamage( v, caster, damage, 6, ability )
        end
    end
end

function OnCreated(event)
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    local min_eff = ability:GetLevelSpecialValueFor( "min_eff" , level - 1  )
    target.barrack_timer = target.barrack_timer + min_eff
    target.min_eff = min_eff
end

function OnDestroy(event)
    local target = event.target
    local ability = event.ability
    if not target:HasModifier("unit_destroyed_barrack_mod") then
        target.barrack_timer = target.barrack_timer - target.min_eff
        target.min_eff = nil
    end
end