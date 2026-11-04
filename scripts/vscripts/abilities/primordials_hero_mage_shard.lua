function ActOnTargets( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	
    local casterPos = caster:GetAbsOrigin()
    local targetPos = target:GetAbsOrigin()
	local damage  = event.damage

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_shard.vpcf", PATTACH_WORLDORIGIN, caster)
				ParticleManager:SetParticleControl(particle, 0, casterPos + Vector(0, 0, 200))
				ParticleManager:SetParticleControl(particle, 1, targetPos + Vector(0, 0, 100))
				ParticleManager:SetParticleControl(particle, 2, targetPos)
				ParticleManager:ReleaseParticleIndex(particle)

	ApplyCustomDamage(target, caster, damage, 6, ability)
end