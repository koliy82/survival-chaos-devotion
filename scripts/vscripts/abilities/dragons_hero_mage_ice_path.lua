function FireEffect_IcePath( event )
	local caster		= event.caster
	local ability		= event.ability

	local pathLength	= event.cast_range
	local pathRadius	= event.path_radius
	local duration		= event.duration
	local damage		= event.damage

	local startPos = caster:GetAbsOrigin()
	local endPos = startPos + caster:GetForwardVector() * pathLength

	-- Create ice_path
	local particleName = "particles/units/heroes/hero_jakiro/jakiro_ice_path.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, startPos )
	ParticleManager:SetParticleControl( pfx, 1, endPos )
	ParticleManager:SetParticleControl( pfx, 2, startPos )

	-- Create ice_path_b
	particleName = "particles/units/heroes/hero_jakiro/jakiro_ice_path_b.vpcf"
	pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, startPos )
	ParticleManager:SetParticleControl( pfx, 1, endPos )
	ParticleManager:SetParticleControl( pfx, 2, Vector( duration, 0, 0 ) )
	ParticleManager:SetParticleControl( pfx, 9, startPos )
	
	local units = FindUnitsInLine( caster:GetTeamNumber(), startPos, endPos, nil, pathRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS)
	for _,unit in pairs(units) do
		unit:AddNewModifier(caster, ability, "modifier_stunned", {Duration = duration})
		ApplyCustomDamage(unit, caster, damage, 6)
	end
end