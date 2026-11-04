function OnCreated( keys )
    local caster = keys.caster
    local ability = keys.ability

    if not caster:FindModifierByName("modifier_spiders_creeps_pusher_explosion_timer") then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_spiders_creeps_pusher_explosion_timer", {})
    end
end

function OnDestroy( keys )
    local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel()
    local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1  )
    local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1  )

    local nFXIndex2 = ParticleManager:CreateParticle( "particles/econ/items/sand_king/sandking_ti7_arms/sandking_ti7_caustic_finale_explode.vpcf", PATTACH_CUSTOMORIGIN, nil )
    ParticleManager:SetParticleControlEnt( nFXIndex2, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetOrigin(), true )
    ParticleManager:SetParticleControl( nFXIndex2, 2, Vector( radius, radius, radius ) )
    ParticleManager:ReleaseParticleIndex( nFXIndex2 )

    EmitSoundOn( "Burrower.Explosion", caster )

    local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
    for _,hEnemy in pairs( enemies ) do
        if hEnemy ~= nil and hEnemy:IsAlive() and hEnemy:IsInvulnerable() == false then
            ApplyCustomDamage( hEnemy, caster, damage, 6, ability )
        end
    end

    caster:ForceKill( false )
end