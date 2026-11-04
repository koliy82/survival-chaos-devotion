function OnSpellStart( event )
    local caster = event.caster
    local ability = event.ability
    local target = event.target
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)

    local CasterPos = caster:GetAbsOrigin()

    local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", CasterPos, true)
	ParticleManager:SetParticleControlEnt(pfx, 2, caster, PATTACH_POINT_FOLLOW, "attach_attack2", CasterPos, true)
	ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    ParticleManager:ReleaseParticleIndex(pfx)

    ability:ApplyDataDrivenModifier(caster, target, "modifier_invaders_hero_mage_flux", {Duration = duration})
end

function OnIntervalThink( event )
    local ability = event.ability

    local level = ability:GetLevel()
    local full_duration = ability:GetLevelSpecialValueFor("duration", level -1)

    if not ability.timer or ability.timer > full_duration then ability.timer = 0 end
    ability.timer = ability.timer + 1
end

function OnDeath( event )
    local caster = event.caster
    local ability = event.ability
    local unit = event.unit

    local level = ability:GetLevel()
    local full_duration = ability:GetLevelSpecialValueFor("duration", level -1)

    --if caster then
        if ability.timer and ability.timer <= full_duration then
            local jump_radius = ability:GetLevelSpecialValueFor("jump_radius", level -1)
            local team = caster:GetTeamNumber()
            local position = unit:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, jump_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
                local target = targets[1]
                local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_arc_warden/arc_warden_flux_cast.vpcf", PATTACH_CUSTOMORIGIN, caster)
	            ParticleManager:SetParticleControlEnt(pfx, 0, unit, PATTACH_POINT_FOLLOW, "attach_attack1", position, true)
	            ParticleManager:SetParticleControlEnt(pfx, 2, unit, PATTACH_POINT_FOLLOW, "attach_attack2", position, true)
	            ParticleManager:SetParticleControlEnt(pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
                ParticleManager:ReleaseParticleIndex(pfx)

                ability:ApplyDataDrivenModifier(caster, target, "modifier_invaders_hero_mage_flux", {Duration = full_duration - ability.timer})
            end
        end
    --end
end