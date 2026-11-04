function EchoSlam(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() -1))
	
	local particle2 = ParticleManager:CreateParticle(keys.particle2, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle2, 0, Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))
	ParticleManager:SetParticleControl(particle2, 1, Vector(radius,radius,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))
	ParticleManager:SetParticleControl(particle2, 2, Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))

	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
	for _,unit in ipairs(units) do
        local particle1 = ParticleManager:CreateParticle(keys.particle1, PATTACH_WORLDORIGIN, caster)
        ParticleManager:SetParticleControl(particle1, 1, Vector(caster:GetAbsOrigin().x,caster:GetAbsOrigin().y,caster:GetAbsOrigin().z+100))
        ParticleManager:SetParticleControl(particle1, 0, Vector(unit:GetAbsOrigin().x,unit:GetAbsOrigin().y,unit:GetAbsOrigin().z+300))
        ParticleManager:SetParticleControl(particle1, 2, Vector(300, 0, 0))
        Timers:CreateTimer( 2, function()
            ParticleManager:DestroyParticle( particle1, false )
		end)
    end
end