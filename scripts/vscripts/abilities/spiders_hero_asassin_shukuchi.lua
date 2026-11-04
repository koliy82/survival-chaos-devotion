if not spiders_hero_asassin_shukuchi then
	LinkLuaModifier("modifier_spiders_hero_asassin_shukuchi", "abilities/spiders_hero_asassin_shukuchi", LUA_MODIFIER_MOTION_NONE)
	spiders_hero_asassin_shukuchi = class({
		OnSpellStart = function(self)
			self.GetCaster(self):AddNewModifier(self.GetCaster(self), self, "modifier_spiders_hero_asassin_shukuchi", {duration = self.GetSpecialValueFor(self,"duration")})
		end,
	})
	modifier_spiders_hero_asassin_shukuchi = class({
		OnCreated = function(self,t)
			if IsServer() then
				self.StartIntervalThink(self,.5)
				self.units = {}
			end
		end,
		OnRefresh = function(self)
			if IsServer() then
				self.units = {}
			end
		end,
		OnIntervalThink = function(self)
			if IsServer() then
				local units = FindUnitsInRadius(self.GetCaster(self):GetTeam(), self.GetCaster(self):GetOrigin(), nil, self.GetAbility(self):GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
				for k,v in ipairs(units) do
					if not self.units[v:entindex()] and not v:HasAbility("unit_building_core") then
						self.units[v:entindex()] = true
    					ApplyCustomDamage(v, self.GetCaster(self), self.GetAbility(self):GetSpecialValueFor("damage"), 6)
					end
				end
				return .5
			end
		end,
		IsHidden = function() return true end,
		DeclareFunctions = function() return {MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE} end,
		GetModifierMoveSpeed_Absolute = function(self) return self.GetAbility(self):GetSpecialValueFor("ms") end,
		CheckState = function() return {[MODIFIER_STATE_INVISIBLE]=true,[MODIFIER_STATE_NO_UNIT_COLLISION] = true,[MODIFIER_STATE_MAGIC_IMMUNE] = true} end,
	})
end