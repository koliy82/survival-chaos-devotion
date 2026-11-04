function OnCreated(event)
    local target = event.target
	local ability = event.ability
end

function OnDestroy(event)
    local target = event.target
    if target:IsAlive() then
        local caster = event.caster
        local spawnradius = 50
        local nowOwner = caster:GetOwner()
        local owner = caster.FirstOwner or nowOwner
        
        local unit = CreateUnitByName("npc_dota_spiders_melee", target:GetAbsOrigin(), true, owner, owner, caster:GetTeam())
        unit:SetDeathXP(0)
        unit:SetMinimumGoldBounty(0)
        unit:SetMaximumGoldBounty(0)
        unit.previous_point = caster.previous_point
        unit.to_point = caster.to_point
        FindClearSpaceForUnit( unit, target:GetAbsOrigin()+RandomVector( spawnradius ), false )
        if owner ~= nowOwner then unit:SetOwner(nowOwner) end

        unit = CreateUnitByName("npc_dota_spiders_range", target:GetAbsOrigin(), true, owner, owner, caster:GetTeam())
        unit:SetDeathXP(0)
        unit:SetMinimumGoldBounty(0)
        unit:SetMaximumGoldBounty(0)
        unit.previous_point = caster.previous_point
        unit.to_point = caster.to_point
        FindClearSpaceForUnit( unit, target:GetAbsOrigin()+RandomVector( spawnradius ), false )
        if owner ~= nowOwner then unit:SetOwner(nowOwner) end

        unit = CreateUnitByName("npc_dota_spiders_arme", target:GetAbsOrigin(), true, owner, owner, caster:GetTeam())
        unit:SetDeathXP(0)
        unit:SetMinimumGoldBounty(0)
        unit:SetMaximumGoldBounty(0)
        unit.previous_point = caster.previous_point
        unit.to_point = caster.to_point
        FindClearSpaceForUnit( unit, target:GetAbsOrigin()+RandomVector( spawnradius ), false )
        if owner ~= nowOwner then unit:SetOwner(nowOwner) end
    end
end