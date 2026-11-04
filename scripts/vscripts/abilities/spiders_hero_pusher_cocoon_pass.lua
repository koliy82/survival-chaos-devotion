function OnCreated(event)
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    target.damage = ability:GetLevelSpecialValueFor( "explode_damage" , level - 1  )
    target.explode_radius = ability:GetLevelSpecialValueFor( "explode_radius" , level - 1  )
end

function OnIntervalThink(event)
    local caster = event.caster
    local ability = event.ability
	local unitname = event.UnitName
	local unitcount = event.UnitCount or 1
	local spawnradius = event.SpawnRadius or 150
	local duration = event.Duration
	local addmodifier = event.AddModifier
    local owner = caster:GetOwner()
    local level = ability:GetLevel()
    
    if level > 0 then
        local interval = ability:GetLevelSpecialValueFor( "interval" , level - 1  )
        local timer = ability:GetLevelSpecialValueFor( "timer" , level - 1  )
        local ultmod = caster:FindModifierByName("modifier_spiders_hero_pusher_rage")
        if ultmod then
            interval = interval / 2
            timer = timer / 2
        end
        local mod = caster:FindModifierByName("modifier_spiders_hero_pusher_cocoon_pass")
        mod:SetStackCount(mod:GetStackCount()+1)
        if mod:GetStackCount() >= interval-1 then
            mod:SetStackCount(0)
            for i=1, unitcount do
                local unit = CreateUnitByName(unitname, caster:GetAbsOrigin(), true, owner, owner, caster:GetTeam())
                unit.previous_point = caster.previous_point
                unit.to_point = caster.to_point
                FindClearSpaceForUnit( unit, caster:GetAbsOrigin()+RandomVector( spawnradius ), false )
                if duration then
                    unit:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
                end
                if addmodifier then
                    ability:ApplyDataDrivenModifier( caster, unit, addmodifier, {duration = timer} )
                end
            end
        end
    end
end

function OnDestroy(event)
    local target = event.target
    if target:IsAlive() then
        local ability = event.ability
        local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
        local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
        local targetFlag = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
        local unitOrder = FIND_ANY_ORDER
		
		local particle = ParticleManager:CreateParticle("particles/econ/items/venomancer/veno_ti8_immortal_head/veno_ti8_immortal_gale_explosion.vpcf", PATTACH_WORLDORIGIN, target)
		ParticleManager:SetParticleControl(particle, 3, target:GetAbsOrigin())

        local units = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, target.explode_radius, targetTeam, targetType, targetFlag, unitOrder, false)
	
        for _, unit in pairs( units ) do
            ApplyCustomDamage(unit, target, target.damage, 6, ability)
        end
    end
end