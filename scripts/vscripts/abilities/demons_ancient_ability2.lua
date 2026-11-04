function OnSpellStart(event)
    local caster = event.caster
	local ability = event.ability
	local ability_level = ability:GetLevel() - 1
    local owner = caster:GetOwner()
    local id = caster:GetPlayerOwnerID()
	-- Parameters
	local golems = ability:GetLevelSpecialValueFor("golems", ability_level)
    local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local stun_radius = ability:GetLevelSpecialValueFor("stun_radius", ability_level)
    local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", ability_level)

    local forward_direction = caster:GetForwardVector()
    local rots = {
        [1] = {180, -90, 0},
        [2] = {90, 0, -90},
        [3] = {180, 90, 0},
        [4] = {90, 180, -90}
    }
    if _G.duos then
        rots = {
            [1] = {180, -90, 0},
            [2] = {0, 90, 180},
            [3] = {180, -90, 0},
            [4] = {180, 90, 0},
        }
    end
    
    for i=1, #rots[_G.playersinfo[id].base_pos] do
        local spawn_direction = (RotatePosition(Vector(0, 0, 0), QAngle(0, rots[_G.playersinfo[id].base_pos][i], 0), forward_direction)):Normalized()
        local spawn_location = caster:GetAbsOrigin() + (1200 *  spawn_direction)

        if _G.duos then
            if i == 3 then
                spawn_location = caster:GetAbsOrigin() + (1700 *  spawn_direction)
            end
        end

        local part = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(part, 0, spawn_location)
		ParticleManager:SetParticleControl(part, 1, Vector(stun_radius,0,0))

        local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
        local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
        local targetFlag = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
        local units = FindUnitsInRadius( caster:GetTeamNumber(), spawn_location, nil, stun_radius, targetTeam, targetType, targetFlag, FIND_ANY_ORDER, false )
        for k, v in pairs( units ) do
            v:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
            -- ability:ApplyDataDrivenModifier(caster, v, "", {duration = stun_duration})
        end

        for n=1, golems do
            local unit = CreateUnitByName("npc_dota_demons_golem", spawn_location, true, owner, owner, caster:GetTeam())
            FindClearSpaceForUnit( unit, spawn_location, false )
            unit:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
        end
    end
end