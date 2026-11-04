function OnCreated(event)
    local caster = event.caster
    local target = event.target
	local ability = event.ability
    local level = ability:GetLevel()
    local radius = ability:GetLevelSpecialValueFor( "agr_radius" , level - 1 )
        
    local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
    local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

    local units = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
    for _,unit in ipairs(units) do
        unit:AddNewModifier(target, ability, "agr_mod", {duration = 2})
    end
end

function OnDestroy(event)
    local target = event.target
    if target:IsAlive() then
        local caster = event.caster
        local spawnradius = 50
        local nowOwner = caster:GetOwner()
        local owner = caster.FirstOwner or nowOwner
        local ability = event.ability
        local level = ability:GetLevel()
        local hp = ability:GetLevelSpecialValueFor( "hp" , level - 1 )
        local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1 ) / 100
        local id = caster:GetPlayerOwnerID()
        
        local unit = CreateUnitByName("npc_dota_treants_siege", target:GetAbsOrigin(), true, owner, owner, caster:GetTeam())
        unit.previous_point = caster.previous_point
        unit.to_point = caster.to_point
        unit:SetHealth(unit:GetMaxHealth()*(hp/100))
        unit:SetBaseDamageMax(_G.playersinfo[id].unitsinfo["npc_dota_treants_siege"].max_damage * damage)
        unit:SetBaseDamageMin(_G.playersinfo[id].unitsinfo["npc_dota_treants_siege"].min_damage * damage)
        FindClearSpaceForUnit( unit, target:GetAbsOrigin()+RandomVector( spawnradius ), false )
        if owner ~= nowOwner then unit:SetOwner(nowOwner) end
		Timers:CreateTimer( 0.5, function()
            unit:RemoveAbility("treants_creeps_siege_bush_pass")
		end)
    end
end