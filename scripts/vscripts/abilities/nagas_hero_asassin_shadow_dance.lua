function Shadow( keys )
	local caster = keys.caster
    local point = caster:GetAbsOrigin()
    local pfx = ParticleManager:CreateParticle("particles/econ/items/slark/slark_fall20_immortal/slark_fall20_shadow_dance.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
    ParticleManager:SetParticleControl( pfx, 0, point )
    ParticleManager:SetParticleControlEnt( pfx, 1, caster, PATTACH_POINT_FOLLOW, 'attach_hitloc', point, true )
    ParticleManager:SetParticleControlEnt( pfx, 2, caster, PATTACH_POINT_FOLLOW, 'attach_hitloc', point, true )
    ParticleManager:SetParticleControlEnt( pfx, 3, caster, PATTACH_POINT_FOLLOW, 'attach_hitloc', point, true )
    ParticleManager:SetParticleControlEnt( pfx, 4, caster, PATTACH_POINT_FOLLOW, 'attach_hitloc', point, true )
end