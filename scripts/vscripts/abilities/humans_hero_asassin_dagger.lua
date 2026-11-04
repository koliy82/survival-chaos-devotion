if not humans_hero_asassin_dagger then
	LinkLuaModifier("modifier_humans_hero_asassin_dagger", "abilities/humans_hero_asassin_dagger", LUA_MODIFIER_MOTION_NONE)
	humans_hero_asassin_dagger = class({
		OnSpellStart = function(self)
			local caster = self.GetCaster(self)
			local units = FindUnitsInRadius(caster:GetTeam(),
                              self.GetCursorTarget(self):GetOrigin(),
                              nil,
                              self.GetSpecialValueFor(self,"range"),
                              self.GetAbilityTargetTeam(self),
                              self.GetAbilityTargetType(self),
                              self.GetAbilityTargetFlags(self),
                              FIND_CLOSEST,
                              false)
			units[0] = self.GetCursorTarget(self)
			local i = self.GetSpecialValueFor(self,"count")
			for k,v in ipairs(units) do
				if not v:HasAbility("unit_building_core") then
					local projectileTable =
					{
						EffectName = "particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_stifling_dagger_arcana.vpcf",
						Target = v,
						Source = caster,
						iMoveSpeed = 1000,
						Ability = self,	
						vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)
						bDrawsOnMinimap = false,                          -- Optional
				        bDodgeable = true,                                -- Optional
				        bIsAttack = true,                                -- Optional
				        bVisibleToEnemies = true,                         -- Optional
				        bReplaceExisting = false,                         -- Optional
						bProvidesVision = true,                           -- Optional
						iVisionRadius = 100,                              -- Optional
						iVisionTeamNumber = caster:GetTeamNumber()        -- Optional
					}
					ProjectileManager:CreateTrackingProjectile(projectileTable)
					i = i -1
					if i <= 0 then
						return
					end
	    		end
			end
		end,
		OnProjectileHit = function(self,hTarget, vLocation)
			if hTarget and hTarget:IsAlive() then
				local caster = self.GetCaster(self)
				hTarget:AddNewModifier(caster, self, "modifier_humans_hero_asassin_dagger", {duration=self.GetSpecialValueFor(self,"duration")})
				ApplyCustomDamage(hTarget, caster, caster:GetAttackDamage()*self.GetSpecialValueFor(self,"damage")*0.01, caster.custom_damage_type)
			end
		end
	})
	modifier_humans_hero_asassin_dagger = class({
		IsDebuff = function() return true end,
		IsHidden = function() return false end,
		GetTexture = function(self) return "phantom_assassin_stifling_dagger" end,
		DeclareFunctions = function() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end,
		GetModifierMoveSpeedBonus_Percentage = function(self) return self.GetAbility(self):GetSpecialValueFor("slow") end
	})
end