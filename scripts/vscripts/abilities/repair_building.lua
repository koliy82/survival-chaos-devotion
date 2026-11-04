function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    local mod = caster:FindModifierByName("modifier_repair_building")
    
    local particle = ParticleManager:CreateParticle( "particles/items5_fx/repair_kit.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
    ParticleManager:SetParticleControlEnt( particle, 0, caster, PATTACH_POINT_FOLLOW, "attach_part" , caster:GetOrigin(), true )
    ParticleManager:SetParticleControlEnt( particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_part" , caster:GetOrigin(), true )
    mod:AddParticle(particle, false, false, 0, false, false)

    if ability.particle then
        ParticleManager:DestroyParticle(ability.particle, false)
        ability.particle = nil
    end

	Timers:CreateTimer( ability:GetCooldown(ability:GetLevel()), function()
        local heal = ability:GetLevelSpecialValueFor( "heal", ( ability:GetLevel() - 1 ) )
        if caster:GetHealth() + heal <= caster:GetMaxHealth() then
            ability.particle = ParticleManager:CreateParticle( "particles/customgames/capturepoints/cp_allied_wood.vpcf", PATTACH_OVERHEAD_FOLLOW, caster )
            ParticleManager:SetParticleControl( ability.particle, 0,  caster:GetOrigin() )
        end
    end)
end

function OnAttacked(event)
    local caster = event.caster
    local ability = event.ability
    
    if not ability.particle and ability:IsCooldownReady() then
        local heal = ability:GetLevelSpecialValueFor( "heal", ( ability:GetLevel() - 1 ) )
        if caster:GetHealth() + heal <= caster:GetMaxHealth() then
            ability.particle = ParticleManager:CreateParticle( "particles/customgames/capturepoints/cp_allied_wood.vpcf", PATTACH_OVERHEAD_FOLLOW, caster )
            ParticleManager:SetParticleControl( ability.particle, 0,  caster:GetOrigin() )
        end
    end
end