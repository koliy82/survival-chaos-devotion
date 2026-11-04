if not spiders_hero_asassin_armor_red_pass then
	LinkLuaModifier("modifier_spiders_hero_asassin_armor_red_pass", "abilities/spiders_hero_asassin_armor_red_pass", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_spiders_hero_asassin_armor_red_pass_debuff", "abilities/spiders_hero_asassin_armor_red_pass", LUA_MODIFIER_MOTION_NONE)
	spiders_hero_asassin_armor_red_pass = class({
		GetIntrinsicModifierName = function(self)
			return "modifier_spiders_hero_asassin_armor_red_pass"
		end
	})
	modifier_spiders_hero_asassin_armor_red_pass_debuff = class({
		GetTexture = function() return "spiders_hero_asassin_armor_red_pass" end,
		IsHidden = function() return false end,
		IsDebuff = function() return true end,
		DeclareFunctions = function() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end,
		GetModifierPhysicalArmorBonus = function(self) return -self.GetStackCount(self) end,
	})
	modifier_spiders_hero_asassin_armor_red_pass = class({
		IsHidden = function() return true end,
		DeclareFunctions = function() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end,
		OnAttackLanded = function(self,t) 
			if IsServer() then
				if self.GetParent(self) ~= t.attacker then
					return 0
				end
				if t.target:IsAlive() then
					local mod = t.target:FindModifierByName("modifier_spiders_hero_asassin_armor_red_pass_debuff")
					if mod then
						local stacks = mod:GetStackCount()
						if stacks < self.GetAbility(self):GetSpecialValueFor("max") then
							mod:SetStackCount(math.min(stacks + self.GetAbility(self):GetSpecialValueFor("armor_red"),self.GetAbility(self):GetSpecialValueFor("max")))
						end
						mod:SetDuration(self.GetAbility(self):GetSpecialValueFor("duration"), true)
					else
						t.target:AddNewModifier(t.attacker, self.GetAbility(self), "modifier_spiders_hero_asassin_armor_red_pass_debuff", {duration = self.GetAbility(self):GetSpecialValueFor("duration")}):SetStackCount(self.GetAbility(self):GetSpecialValueFor("armor_red"))
					end
				end
			end
		end
	})
end