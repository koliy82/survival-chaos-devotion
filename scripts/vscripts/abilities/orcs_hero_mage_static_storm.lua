--[[Author: YOLOSPAGHETTI
    Date: March 30, 2016
    Renders the particles over the radius]]
function RenderParticles(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() -1)
    
    ability.particle = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, caster)
    ParticleManager:SetParticleControl(ability.particle, 0, target:GetAbsOrigin())
    ParticleManager:SetParticleControl(ability.particle, 1, Vector(radius, radius, 0))
    ParticleManager:SetParticleControl(ability.particle, 2, Vector(5, 0, 0))
end

function OnDestroy(keys)
    local ability = keys.ability
    ParticleManager:DestroyParticle(ability.particle, false)
end