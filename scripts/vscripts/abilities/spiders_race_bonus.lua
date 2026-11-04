LinkLuaModifier( "modifier_spiders_race_bonus", "abilities/spiders_race_bonus", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spiders_race_bonus_debuff", "abilities/spiders_race_bonus", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spiders_race_bonus_buff", "abilities/spiders_race_bonus", LUA_MODIFIER_MOTION_NONE )

spiders_race_bonus = class ({})

--------------------------------------------------------------------------------

function spiders_race_bonus:GetIntrinsicModifierName()
	return "modifier_spiders_race_bonus"
end

--------------------------------------------------------------------------------

modifier_spiders_race_bonus = class({})

--------------------------------------------------------------------------------

function modifier_spiders_race_bonus:IsHidden()
	return true
end

--------------------------------------------------------------------------------

-- function modifier_spiders_race_bonus:DeclareFunctions()
-- 	local funcs = 
-- 	{
-- 		MODIFIER_EVENT_ON_ATTACK_LANDED,
-- 	}

-- 	return funcs
-- end

--------------------------------------------------------------------------------

function modifier_spiders_race_bonus:IsAura()
	return true
end

function modifier_spiders_race_bonus:GetAuraRadius()
	return 9999999
end

function modifier_spiders_race_bonus:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_spiders_race_bonus:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_spiders_race_bonus:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_spiders_race_bonus:GetModifierAura()
    if IsServer() then
        if GameRules:IsDaytime() then
            return "modifier_spiders_race_bonus_debuff"
        else
            return "modifier_spiders_race_bonus_buff"
        end
    end
end

--------------------------------------------------------------------------------

modifier_spiders_race_bonus_debuff = class({})

function modifier_spiders_race_bonus_debuff:IsHidden()
	return false
end

function modifier_spiders_race_bonus_debuff:IsDebuff()
	return true
end

function modifier_spiders_race_bonus_debuff:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_MISS_PERCENTAGE,
	}

	return funcs
end

function modifier_spiders_race_bonus_debuff:GetModifierMiss_Percentage( params )
    return self:GetAbility():GetLevelSpecialValueFor("miss", 0)
end

--------------------------------------------------------------------------------

modifier_spiders_race_bonus_buff = class({})

function modifier_spiders_race_bonus_buff:IsHidden()
	return false
end

function modifier_spiders_race_bonus_buff:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_EVASION_CONSTANT,
	}

	return funcs
end

function modifier_spiders_race_bonus_buff:GetModifierMoveSpeedBonus_Percentage( params )
    return self:GetAbility():GetLevelSpecialValueFor("speed", self:GetCaster():GetModifierStackCount("modifier_spiders_race_bonus", self:GetCaster()))
end

function modifier_spiders_race_bonus_buff:GetModifierAttackSpeedBonus_Constant( params )
    return self:GetAbility():GetLevelSpecialValueFor("ats", self:GetCaster():GetModifierStackCount("modifier_spiders_race_bonus", self:GetCaster()))
end

function modifier_spiders_race_bonus_buff:GetModifierPreAttack_BonusDamage( params )
    return self:GetAbility():GetLevelSpecialValueFor("damage", self:GetCaster():GetModifierStackCount("modifier_spiders_race_bonus", self:GetCaster()))
end

function modifier_spiders_race_bonus_buff:GetModifierEvasion_Constant( params )
    return self:GetAbility():GetLevelSpecialValueFor("evasion", self:GetCaster():GetModifierStackCount("modifier_spiders_race_bonus", self:GetCaster()))
end