function OnIntervalThink( event )
	local ability = event.ability

	if ability:IsCooldownReady() then
		local caster = event.caster
    	local casterPos = caster:GetAbsOrigin()
		local radius  = event.radius
		
		local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    	local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
		local targets =  FindUnitsInRadius(caster:GetTeamNumber(), casterPos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
    	if #targets > 0 then
    		local targetPos = targets[1]:GetAbsOrigin()
			local damage  = event.damage

			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_shard.vpcf", PATTACH_WORLDORIGIN, caster)
						ParticleManager:SetParticleControl(particle, 0, casterPos + Vector(0, 0, 300))
						ParticleManager:SetParticleControl(particle, 1, targetPos + Vector(0, 0, 150))
						ParticleManager:SetParticleControl(particle, 2, targetPos)
						ParticleManager:ReleaseParticleIndex(particle)

			ApplyCustomDamage(targets[1], caster, damage, 6, ability)
			local cooldown = ability:GetEffectiveCooldown(ability:GetLevel())
			ability:StartCooldown(cooldown)
		end
	end
end