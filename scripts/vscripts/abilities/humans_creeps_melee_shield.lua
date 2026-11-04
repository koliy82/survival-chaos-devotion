function AphoticShield( event )
	local target = event.target
	local ability = event.ability
	local max_damage_absorb = ability:GetLevelSpecialValueFor("damage_absorb", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )
	local shield_size = 75 -- could be adjusted to model scale

	-- Strong Dispel
	local RemovePositiveBuffs = false
	local RemoveDebuffs = true
	local BuffsCreatedThisFrameOnly = false
	local RemoveStuns = true
	local RemoveExceptions = false
	target:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)

	-- Reset the shield
	local mod = target:AddBarrier(max_damage_absorb, 0, duration, target, ability)

	-- Particle. Need to wait one frame for the older particle to be destroyed
	Timers:CreateTimer(0.01, function() 
		local shieldParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControl(shieldParticle, 1, Vector(shield_size,0,shield_size))
		ParticleManager:SetParticleControl(shieldParticle, 2, Vector(shield_size,0,shield_size))
		ParticleManager:SetParticleControl(shieldParticle, 4, Vector(shield_size,0,shield_size))
		ParticleManager:SetParticleControl(shieldParticle, 5, Vector(shield_size,0,0))

		-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
		ParticleManager:SetParticleControlEnt(shieldParticle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
		mod:AddParticle(shieldParticle, false, false, 0, false, false)
	end)
end