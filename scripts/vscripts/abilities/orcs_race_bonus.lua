LinkLuaModifier( "modifier_orcs_race_bonus", "abilities/orcs_race_bonus", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_orcs_race_bonus_buff", "abilities/orcs_race_bonus", LUA_MODIFIER_MOTION_NONE )

orcs_race_bonus = class ({})

--------------------------------------------------------------------------------

function orcs_race_bonus:GetIntrinsicModifierName()
	return "modifier_orcs_race_bonus"
end

--------------------------------------------------------------------------------


modifier_orcs_race_bonus = class({})

--------------------------------------------------------------------------------

function modifier_orcs_race_bonus:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_orcs_race_bonus:IsAura()
	return true
end

function modifier_orcs_race_bonus:GetAuraRadius()
	return 9999999
end

function modifier_orcs_race_bonus:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_orcs_race_bonus:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_orcs_race_bonus:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_orcs_race_bonus:GetModifierAura()
	return "modifier_orcs_race_bonus_buff"
end

--function modifier_orcs_race_bonus:IsAuraActiveOnDeath(  ) end

--------------------------------------------------------------------------------

modifier_orcs_race_bonus_buff = class({})

--------------------------------------------------------------------------------

function modifier_orcs_race_bonus_buff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_orcs_race_bonus_buff:IsBuff()
	return true
end

--------------------------------------------------------------------------------

-- function modifier_orcs_race_bonus_buff:OnCreated( kv )
-- 	if IsServer() then
-- 		local ability = self:GetAbility()
-- 		local level = ability:GetLevel()
-- 		self.damage = ability:GetLevelSpecialValueFor( "damage" , level - 1  )
-- 		self:SetStackCount(ability:GetLevelSpecialValueFor( "min_armor" , level - 1  ))
-- 		self:StartIntervalThink(0.5)
-- 	end
-- end

--------------------------------------------------------------------------------

function modifier_orcs_race_bonus_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_orcs_race_bonus_buff:GetModifierPreAttack_BonusDamage( params )
	if IsServer() then
		local par = self:GetParent()
		if par:IsAncient() then
        	if par:GetUnitName() == "npc_dota_custom_tower" then
				self:SetStackCount(par:GetBaseDamageMax() * 0.25)
			end
		else
			self:SetStackCount(par:GetBaseDamageMax() * 0.12)
		end
	end
    return self:GetStackCount()
end