function LaunchTrackingProjectile(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local team = caster:GetTeamNumber()
    local position = target:GetAbsOrigin()
    local target_type = DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
    local radius = ability:GetLevelSpecialValueFor( "radius" , ability:GetLevel() - 1 )
    local targets = FindUnitsInRadius(team, position, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
    for _, heal_target in pairs(targets) do
        local info = {
            Target = heal_target,
            Source = target,
            Ability = ability,
            EffectName = "particles/units/heroes/hero_treant/treant_leech_seed_projectile.vpcf",
            bDodgeable = false,
            bProvidesVision = false,
            iMoveSpeed = 700,
            -- iVisionRadius = 0,
            -- iVisionTeamNumber = caster:GetTeamNumber(),
            -- iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
        }
        ProjectileManager:CreateTrackingProjectile( info )
    end
end