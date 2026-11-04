function FireWelcomeHell( event )
	local caster		= event.caster
	local ability		= event.ability

	local pathLength	= event.cast_range
	local pathRadius	= event.path_radius
	local duration		= event.duration
	local damage		= event.damage

	local startPos = caster:GetAbsOrigin()
	local endPos = startPos + caster:GetForwardVector() * pathLength

	local particleName = "particles/units/heroes/hero_jakiro/jakiro_Macropyre.vpcf"
	local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( pfx, 0, startPos )
	ParticleManager:SetParticleControl( pfx, 1, endPos )
	ParticleManager:SetParticleControl( pfx, 2, Vector( duration, 0, 0 ) )
	ParticleManager:SetParticleControl( pfx, 3, startPos )
	
	for i = 1, duration do
		Timers:CreateTimer( i-1, function()
			local units = FindUnitsInLine( caster:GetTeamNumber(), startPos, endPos, nil, pathRadius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS)
			for _,unit in pairs(units) do
				ApplyCustomDamage(unit, caster, damage, 6)
			end
		end)
	end
end