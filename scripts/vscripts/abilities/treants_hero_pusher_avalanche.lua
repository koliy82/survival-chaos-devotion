if not treants_hero_pusher_avalanche then
	treants_hero_pusher_avalanche= class({})
	function treants_hero_pusher_avalanche:OnSpellStart()
		local point = self:GetCursorPosition()
		local caster = self:GetCaster()
		local part = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_avalanche.vpcf", PATTACH_ABSORIGIN, self:GetCaster())
	    ParticleManager:SetParticleControl( part, 0, point )
	    ParticleManager:SetParticleControl( part, 1, Vector(self:GetSpecialValueFor("radius"),200,200) )
	    local stun_dur = self:GetSpecialValueFor("stun")
	    local dur = self:GetSpecialValueFor("duration")
	    local interval = self:GetSpecialValueFor("interval")
	    local radius = self:GetSpecialValueFor("radius")
	    local dmg = self:GetAbilityDamage()/(dur/interval)
	    local time = 0
	    Timers:CreateTimer(0, function()
			local units = FindUnitsInRadius(caster:GetTeam(), point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false)
			for k,v in pairs(units) do
	    		v:AddNewModifier(caster, self, "modifier_stunned", {duration=stun_dur})
				ApplyCustomDamage(v, caster, dmg, 6, self)
			end
			time = time + interval
			if time <= dur then
	    		return interval
	    	else
	    		ParticleManager:DestroyParticle(part, false)
	    		return nil
	    	end
	    end)
	end
end