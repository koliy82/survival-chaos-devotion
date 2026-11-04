function Start( keys )
	local ability = keys.ability
	local point = ability:GetCursorPosition()
	local caster = keys.caster
	local effect_cast1 = ParticleManager:CreateParticle(
		"particles/items4_fx/meteor_hammer_aoe.vpcf",
		PATTACH_WORLDORIGIN,
		nil
	)
	ParticleManager:SetParticleControl( effect_cast1, 0, point )

	local effect_cast2 = ParticleManager:CreateParticle(
		"particles/items4_fx/meteor_hammer_spell.vpcf",
		PATTACH_WORLDORIGIN,
		nil
	)
	ParticleManager:SetParticleControl( effect_cast2, 0, Vector(point.x, point.y, 4000) )
	ParticleManager:SetParticleControl( effect_cast2, 1, point )
	ParticleManager:SetParticleControl( effect_cast2, 2, Vector( 0.5, 0, 0 ) )

	StartSoundEvent("DOTA_Item.MeteorHammer.Impact", caster)

end