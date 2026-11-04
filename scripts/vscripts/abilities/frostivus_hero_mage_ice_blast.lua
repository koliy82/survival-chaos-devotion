function OnSpellStart( event )
	local caster = event.caster
    local ability = event.ability
	local delay = ability:GetLevelSpecialValueFor("delay", ability:GetLevel() - 1 )

    local pfx1 = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_final_grid_b_ti5.vpcf", PATTACH_OVERHEAD_FOLLOW, caster )
    ParticleManager:SetParticleControlEnt(pfx1, 3, caster, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", caster:GetAbsOrigin() + Vector(0, 0, 300), true)
    Timers:CreateTimer(delay,function()
		ParticleManager:DestroyParticle(pfx1, false)
        local pfx2 = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_explode_ti5.vpcf", PATTACH_OVERHEAD_FOLLOW, caster )
        ParticleManager:SetParticleControl(pfx2, 0, caster:GetAbsOrigin() + Vector(0, 0, 300))
        ParticleManager:SetParticleControl(pfx2, 3, caster:GetAbsOrigin() + Vector(0, 0, 300))
    end)
end