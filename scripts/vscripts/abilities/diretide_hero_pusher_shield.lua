function OnSpellStart( event )
	local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()
    local absorb_tick = ability:GetLevelSpecialValueFor("absorb_tick", level - 1 )
    local damage_absorb = ability:GetLevelSpecialValueFor("damage_absorb", level - 1 )
    local duration = ability:GetLevelSpecialValueFor("duration", level - 1 )
    local mod = caster:AddBarrier(damage_absorb, 0, duration, caster, ability)
    mod:AddParticle(ParticleManager:CreateParticle('particles/units/heroes/hero_ogre_magi/ogre_magi_fire_shield.vpcf', PATTACH_ABSORIGIN_FOLLOW, caster), false, false, 0, false, false)

    local radius = ability:GetLevelSpecialValueFor("radius", level - 1 )
    local team = caster:GetTeamNumber()
    local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
    local target_types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
    local target_flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
    
    ability.absorb = 0
    local onDamage = function(params)
        ability.absorb = ability.absorb + params.absorb
        while ability.absorb >= absorb_tick do
            ability.absorb = ability.absorb - absorb_tick
            
            local units = FindUnitsInRadius(team, caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
            if #units > 0 then
                local info = 
                {
                    Target = units[1],
                    Source = caster,
                    Ability = ability,	
                    EffectName = "particles/units/heroes/hero_ogre_magi/ogre_magi_fire_shield_projectile.vpcf",
                    iMoveSpeed = 400,
                    bDrawsOnMinimap = false,                          -- Optional
                    bDodgeable = true,                                -- Optional
                    bIsAttack = false,                                -- Optional
                    bProvidesVision = false,                           -- Optional
                }
                ProjectileManager:CreateTrackingProjectile(info)
            end
        end
    end
    table.insert( mod.OnDamageBarrier, onDamage )
end