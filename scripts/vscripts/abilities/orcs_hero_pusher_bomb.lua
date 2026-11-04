if not orcs_hero_pusher_bomb then
	LinkLuaModifier("modifier_orcs_hero_pusher_bomb", "abilities/orcs_hero_pusher_bomb", LUA_MODIFIER_MOTION_NONE)
	orcs_hero_pusher_bomb = class({
		OnSpellStart = function(self)
			local caster = self.GetCaster(self)
			local units = FindUnitsInRadius(caster:GetTeam(),
                              self.GetCursorPosition(self),
                              nil,
                              self.GetSpecialValueFor(self,"radius"),
                              self.GetAbilityTargetTeam(self),
                              self.GetAbilityTargetType(self),
                              self.GetAbilityTargetFlags(self),
                              FIND_CLOSEST,
                              false)
			for i=1,self.GetSpecialValueFor(self,"count") do
				if units[i] then
					local origin = units[i]:GetOrigin()
					local particle = ParticleManager:CreateParticle( "particles/econ/items/alchemist/alchemist_smooth_criminal/alchemist_smooth_criminal_unstable_concoction_projectile_explosion.vpcf", PATTACH_POINT_FOLLOW, units[i] )
							
					ParticleManager:SetParticleControlEnt(particle, 0, units[i], PATTACH_POINT_FOLLOW, "attach_hitloc", origin, true)
					ParticleManager:SetParticleControlEnt(particle, 3, units[i], PATTACH_POINT_FOLLOW, "attach_hitloc", origin, true)
	    			units[i]:AddNewModifier(caster, self, "modifier_orcs_hero_pusher_bomb", {duration=self.GetSpecialValueFor(self,"duration")})
	    			ApplyCustomDamage(units[i], caster, self.GetSpecialValueFor(self,"damage"), 6)
	    		end
			end
		end,
		GetAOERadius = function(self)
			return self.GetSpecialValueFor(self,"radius")
		end
	})
	modifier_orcs_hero_pusher_bomb = class({
		IsDebuff = function() return true end,
		IsStunDebuff = function() return true end,
		IsHidden = function() return false end,
		CheckState = function() return {[MODIFIER_STATE_STUNNED]=true} end,
		GetTexture = function(self) return self.GetAbility(self) end,
		GetEffectName = function() return "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_stunned.vpcf" end,
		GetEffectAttachType = function() return PATTACH_OVERHEAD_FOLLOW end,
		DeclareFunctions = function() return {MODIFIER_PROPERTY_OVERRIDE_ANIMATION} end,
		GetOverrideAnimation = function(self) return ACT_DOTA_DISABLED end
	})
end