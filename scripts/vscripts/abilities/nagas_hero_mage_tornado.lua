--[[Author: YOLOSPAGHETTI
    Date: March 30, 2016
    Renders the particles over the radius]]

function RenderParticles(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() -1)
    
    target.particle = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(target.particle, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(target.particle, 1, Vector(radius, radius, 0))
    ParticleManager:SetParticleControl(target.particle, 2, Vector(5, 0, 0))
    StartSoundEvent("n_creep_Wildkin.Tornado", target)
end

function OnDestroy(keys)
    local target = keys.target
    ParticleManager:DestroyParticle(target.particle, false)
    StopSoundEvent("n_creep_Wildkin.Tornado", target)
end