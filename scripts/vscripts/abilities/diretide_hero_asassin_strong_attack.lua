function OnAttackLanded(keys)
	--local ability = keys.ability
	local target = keys.target
	local caster = keys.caster
	--local cooldown = ability:GetCooldown(ability:GetLevel())
	--ability:StartCooldown(cooldown)

    local particle = ParticleManager:CreateParticle("particles/econ/items/sand_king/sandking_barren_crown/sandking_rubyspire_cracks.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin() + caster:GetForwardVector() * 500)

end