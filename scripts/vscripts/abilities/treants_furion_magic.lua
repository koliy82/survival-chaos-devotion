if not treants_furion_magic then 
	LinkLuaModifier("modifier_treants_furion_magic", "abilities/treants_furion_magic", LUA_MODIFIER_MOTION_NONE)
	treants_furion_magic = class({
		GetIntrinsicModifierName = function() return "modifier_treants_furion_magic" end
	})
	modifier_treants_furion_magic = class({
		IsHidden = function() return true end,
		DeclareFunctions = function() return {MODIFIER_EVENT_ON_ATTACK_LANDED} end,
		OnAttackLanded = function(self,t) 
			if IsServer() then
				if self.GetParent(self) ~= t.attacker then
					return 0
				end
				if RollPercentage(self.GetSpecialValueFor(self,"double")) then
					t.attacker:PerformAttack(t.target, true, true, true, false, true, false, false)
				elseif RollPercentage(self.GetSpecialValueFor(self,"triple")) then
					t.attacker:PerformAttack(t.target, true, true, true, false, true, false, false)
				end
			end
		end
	})
end