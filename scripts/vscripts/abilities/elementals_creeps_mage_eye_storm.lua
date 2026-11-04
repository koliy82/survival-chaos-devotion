if not elementals_creeps_mage_eye_storm then
	elementals_creeps_mage_eye_storm= class({})
	function elementals_creeps_mage_eye_storm:OnSpellStart()
		local caster = self:GetCaster()
		local target = self:GetCursorTarget()
		local dmg = self:GetSpecialValueFor("damage")
		local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf", PATTACH_WORLDORIGIN, target)
	    ParticleManager:SetParticleControl(particle, 0, target:GetOrigin() + Vector(0, 0, 1000))
	    ParticleManager:SetParticleControl(particle, 1, target:GetOrigin())
	    ParticleManager:SetParticleControl(particle, 2, target:GetOrigin())
		ParticleManager:ReleaseParticleIndex(particle)
		local units = FindUnitsInRadius(caster:GetTeam(), target:GetOrigin(), nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false)
		ApplyCustomDamage(target, caster, dmg, 6, self)
		if #units > 1 then
			target = units[2]
			particle = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf", PATTACH_WORLDORIGIN, target)
			ParticleManager:SetParticleControl(particle, 0, target:GetOrigin() + Vector(0, 0, 1000))
			ParticleManager:SetParticleControl(particle, 1, target:GetOrigin())
			ParticleManager:SetParticleControl(particle, 2, target:GetOrigin())
			ParticleManager:ReleaseParticleIndex(particle)
			ApplyCustomDamage(target, caster, dmg, 6, self)
		end
	end
end