function OnSpellStart(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()
    local id = caster:GetPlayerOwnerID()
    if not (_G.playersinfo[id].ancient and _G.playersinfo[id].ancient:GetLevel() > level) then
        caster:Stop()
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#need_ancient_level_"..(level+1) })
    end
end

function OnChannelSucceeded(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()

    ability:SetLevel(level + 1)
    if level == 2 then
        ability:SetActivated(false)
    end
end

function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    local owner = caster:GetOwner()
    local id = caster:GetPlayerOwnerID()

    function ability:OnSpawnUnit(data)
        local unit = EntIndexToHScript(data.unit)
        if id == unit:GetPlayerOwnerID() and unit:IsCustomHero() then
            unit.xp_mult = 1.08
        end
    end

    function ability:OnEntityKilled(data)
        local killedUnit = EntIndexToHScript( data.entindex_killed )
        local killerEntity = nil
        if data.entindex_attacker ~= nil then
            killerEntity = EntIndexToHScript( data.entindex_attacker )
        end
        if killerEntity and killedUnit:IsCustomHero() and caster:GetTeamNumber() ~= killedUnit:GetTeamNumber() and caster:GetTeamNumber() == killerEntity:GetTeamNumber() then
            local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel()-1)
            local banner = CreateUnitByName("npc_dota_primordials_banner", killedUnit:GetAbsOrigin(), true, owner, owner, caster:GetTeam())
            banner:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
            ability:ApplyDataDrivenModifier(caster, banner, "modifiers_primordials_race_bonus_banner_aura", {})

            local explosion_ability = caster:FindAbilityByName("primordials_castle_explosion_pass")
            if explosion_ability and explosion_ability:GetLevel() > 0 then
                local radius = explosion_ability:GetLevelSpecialValueFor( "radius" , explosion_ability:GetLevel() - 1 )
                local damage = explosion_ability:GetLevelSpecialValueFor( "damage" , explosion_ability:GetLevel() - 1 )
                local stun_duration = explosion_ability:GetLevelSpecialValueFor( "stun_duration" , explosion_ability:GetLevel() - 1 )

                local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_CUSTOMORIGIN, killedUnit)
	            ParticleManager:SetParticleControlEnt(pfx, 0, killedUnit, PATTACH_POINT, "attach_hitloc", killedUnit:GetAbsOrigin(), true)
                ParticleManager:SetParticleControl( pfx, 1, Vector(radius, radius, 1) )
                ParticleManager:SetParticleControl( pfx, 60, Vector(255, 255, 0) )
                ParticleManager:SetParticleControl( pfx, 61, Vector(1, 0, 0) )
                
                local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	            local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	            local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

	            local units = FindUnitsInRadius(caster:GetTeamNumber(), killedUnit:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
                
	            for _, enemy in pairs( units ) do
                    enemy:AddNewModifier(caster, explosion_ability, "modifier_stunned", {duration = stun_duration})
	            	ApplyCustomDamage(enemy, caster, damage, 6, explosion_ability)
	            end
            end
        end
    end

    ListenToGameEvent('custom_spawn_unit', ability.OnSpawnUnit, ability)
    ListenToGameEvent('entity_killed', ability.OnEntityKilled, ability)
end

function OnDestroy(event)
    local caster = event.caster
    local ability = event.ability
    StopListeningToAllGameEvents(ability)
end