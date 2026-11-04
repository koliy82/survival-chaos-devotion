function Effect(keys)
	local target = keys.target
	local caster = keys.caster
    
    local particleName = "particles/units/heroes/hero_primal_beast/primal_beast_rock_throw_impact.vpcf" 
    local particle = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, caster )
    ParticleManager:SetParticleControl( particle, 3, target:GetAbsOrigin() )
end