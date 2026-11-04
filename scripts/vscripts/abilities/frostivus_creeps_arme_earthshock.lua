function OnAttacked(keys)
	local caster = keys.caster
	local ability = keys.ability
    local level = ability:GetLevel()

	if level > 0 and ability:IsCooldownReady() then
		local chance = ability:GetLevelSpecialValueFor( "chance", ( ability:GetLevel() - 1) )
		
		local rand = math.random(1,100)
		if rand <= chance then
			StartSoundEvent("Hero_EarthShaker.Death", caster)
			local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	        local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	        local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

            local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1  )
            local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1  )

            local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
	        for _,unit in ipairs(units) do
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_frostivus_creeps_arme_earthshock_debuff", {})
                ApplyCustomDamage(unit, caster, damage, 6)
            end
			
			local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_ursa/ursa_earthshock.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 1, Vector(100,100,100))
			ParticleManager:SetParticleControl(particle, 60, Vector(130,195,255))
			ParticleManager:SetParticleControl(particle, 61, Vector(1,0,0))

			local cooldown = ability:GetEffectiveCooldown(level)
	    	ability:StartCooldown(cooldown)
		end
	end
end