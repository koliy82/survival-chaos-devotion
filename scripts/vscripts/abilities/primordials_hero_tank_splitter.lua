function OnSpellStart( event )
	local caster = event.caster
	local ability = event.ability
	
    local casterPos = caster:GetAbsOrigin()
	local distance  = event.distance
	local radius  = event.radius
	local damage  = event.damage
	local crack_time  = event.crack_time

	local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	local targets =  FindUnitsInRadius(caster:GetTeamNumber(), casterPos, nil, distance, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
    if #targets > 0 then
		local dir = (targets[1]:GetOrigin()-casterPos):Normalized()

		local startPos = casterPos + dir * 5 
		local endPos = startPos + (dir * distance) * (3.14/crack_time)

    	EmitSoundOnLocationWithCaster(startPos, "Hero_ElderTitan.EarthSplitter.Cast", caster)
    	EmitSoundOnLocationWithCaster(endPos, "Hero_ElderTitan.EarthSplitter.Projectile", caster)

		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf", PATTACH_WORLDORIGIN, caster)
					ParticleManager:SetParticleControl(particle, 0, casterPos)
					ParticleManager:SetParticleControl(particle, 1, endPos)
					ParticleManager:SetParticleControl(particle, 3, Vector(0,crack_time,0))
					ParticleManager:ReleaseParticleIndex(particle)

		Timers:CreateTimer( crack_time, function()
			EmitSoundOnLocationWithCaster(endPos, "Hero_ElderTitan.EarthSplitter.Destroy", caster)
			local units = FindUnitsInLine(caster:GetTeam(), casterPos, endPos, caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags)
	
			for _,unit in pairs(units) do
			    ability:ApplyDataDrivenModifier(caster, unit, "modifier_primordials_hero_tank_splitter_debuff", {})
			    ApplyCustomDamage(unit, caster, damage, 6, ability)
			end
		end)
	end
end