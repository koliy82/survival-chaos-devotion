function OnIntervalThink(keys)
    local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    
    local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1 )

    local part = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_lightning_bolt.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
    ParticleManager:SetParticleControl(part, 0, target:GetAbsOrigin() + Vector( 0, 0, 800 ))
    ParticleManager:SetParticleControlEnt( part, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetOrigin(), true )

    ApplyCustomDamage(target, caster, damage, 6, nil)
end