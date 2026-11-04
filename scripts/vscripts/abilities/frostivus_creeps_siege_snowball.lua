function OnSpellStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target
	local particle_name = "particles/econ/events/snowball/snowball_projectile.vpcf"

	--local wave_direction = caster:GetForwardVector()
	local wave_distance = ability:GetLevelSpecialValueFor("distance", ability_level)

	local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin() + caster:GetForwardVector() * wave_distance)

	Timers:CreateTimer( 2, function()
		ParticleManager:DestroyParticle(particle, false)
		end)
end