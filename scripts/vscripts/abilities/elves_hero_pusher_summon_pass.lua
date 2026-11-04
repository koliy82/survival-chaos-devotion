function OnCreated(event)
    local caster = event.caster
    local target = event.target

    target.spirit_pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_wisp/wisp_guardian_.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
end

function OnDestroy(event)
    local caster = event.caster
    local target = event.target

    if target and target.spirit_pfx then
        ParticleManager:DestroyParticle( target.spirit_pfx, false )
    end
end