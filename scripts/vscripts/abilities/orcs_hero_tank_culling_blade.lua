function CullingBlade( keys )
    local caster = keys.caster
    local target = keys.target
    local caster_location = caster:GetAbsOrigin()
    local target_location = target:GetAbsOrigin() 
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1

    -- Sound variables
    local sound_success = keys.sound_success

    -- Particle
    local particle_kill = keys.particle_kill

    -- Ability variables
    -- local kill_threshold = ability:GetLevelSpecialValueFor("kill_threshold", ability_level)

     -- Check if the target HP is equal or below the threshold
    -- if target:GetHealth() <= kill_threshold then
        -- Play the kill particle
        local culling_kill_particle = ParticleManager:CreateParticle(particle_kill, PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControlEnt(culling_kill_particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
        ParticleManager:SetParticleControlEnt(culling_kill_particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
        ParticleManager:SetParticleControlEnt(culling_kill_particle, 2, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
        ParticleManager:SetParticleControlEnt(culling_kill_particle, 4, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
        ParticleManager:SetParticleControlEnt(culling_kill_particle, 8, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
        ParticleManager:ReleaseParticleIndex(culling_kill_particle)

        -- Play the sound
        caster:EmitSound(sound_success)
        target:Kill(ability,caster)
    -- end
end