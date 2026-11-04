if not orcs_creeps_mage_purge then
	LinkLuaModifier("modifier_orcs_creeps_mage_purge", "abilities/orcs_creeps_mage_purge", LUA_MODIFIER_MOTION_NONE)
	orcs_creeps_mage_purge = class({})
	function orcs_creeps_mage_purge:OnSpellStart()
		self:GetCursorTarget():Purge(true, false, false, false, false)
		local part = ParticleManager:CreateParticle("particles/neutral_fx/satyr_trickster_projectile_explosion.vpcf", PATTACH_ABSORIGIN, self:GetCursorTarget())
		ParticleManager:ReleaseParticleIndex(part)
		self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_orcs_creeps_mage_purge", {duration = self:GetSpecialValueFor("duration")})
	end
	modifier_orcs_creeps_mage_purge = class({
		IsHidden = function() return false end,
		GetTexture = function() return "satyr_trickster_purge" end,
		DeclareFunctions = function() return {MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT} end,
		GetModifierMoveSpeedBonus_Constant = function(self) return -self.GetAbility(self):GetSpecialValueFor("slow") end,
	})
end