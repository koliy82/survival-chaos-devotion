function OnSpellStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target
	local particle_name = "particles/units/heroes/hero_hoodwink/hoodwink_boomerang.vpcf"

	--local wave_direction = caster:GetForwardVector()
	local distance = ability:GetLevelSpecialValueFor("distance", ability_level)
	local speed = ability:GetLevelSpecialValueFor("speed", ability_level)

	local casterPos = caster:GetAbsOrigin()
	local dir = (target:GetOrigin()-casterPos):Normalized()
	local startPos = casterPos + dir * 75 
	local endPos = startPos + (dir * distance)

	local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle, 1, startPos)
    ParticleManager:SetParticleControl(particle, 1, endPos)
    ParticleManager:SetParticleControl(particle, 2, Vector( speed, 0, 0))

	Timers:CreateTimer( distance / speed, function()
		ParticleManager:DestroyParticle(particle, false)
		end)
end