--[[
	Author: Noya
	Date: 18.1.2015.
	Plays the lich_frost_armor particle and destroys it later
]]
function FrostArmorParticle( event )
	local target = event.target
	local location = target:GetAbsOrigin()
	local particleName = "particles/units/heroes/hero_lich/lich_frost_armor.vpcf"

	-- Particle. Need to wait one frame for the older particle to be destroyed
	Timers:CreateTimer(0.01, function()
		target.FrostArmorParticle = ParticleManager:CreateParticle(particleName, PATTACH_OVERHEAD_FOLLOW, target)
		ParticleManager:SetParticleControl(target.FrostArmorParticle, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(target.FrostArmorParticle, 1, Vector(1,0,0))

		ParticleManager:SetParticleControlEnt(target.FrostArmorParticle, 2, target, PATTACH_ABSORIGIN_FOLLOW, "attach_origin", target:GetAbsOrigin(), true)
	end)
end

-- Destroys the particle when the modifier is destroyed
function EndFrostArmorParticle( event )
	local target = event.target
	if target and target.FrostArmorParticle then
		ParticleManager:DestroyParticle(target.FrostArmorParticle,false)
	end
end