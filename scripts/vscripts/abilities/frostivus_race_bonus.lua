LinkLuaModifier( "modifier_frostivus_race_bonus", "abilities/frostivus_race_bonus", LUA_MODIFIER_MOTION_NONE )

frostivus_race_bonus = class ({})

--------------------------------------------------------------------------------

function frostivus_race_bonus:GetIntrinsicModifierName()
	return "modifier_frostivus_race_bonus"
end

function frostivus_race_bonus:OnUpgrade()
	Timers:CreateTimer(0, function()
		local new_level = self.gift_tier or 1
		if self:GetLevel() ~= new_level then
			self:SetLevel(new_level)
		end
	end)
end

--------------------------------------------------------------------------------


modifier_frostivus_race_bonus = class({})

--------------------------------------------------------------------------------

function modifier_frostivus_race_bonus:IsHidden()
	return false
end