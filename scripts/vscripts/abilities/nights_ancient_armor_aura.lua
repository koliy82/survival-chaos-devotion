LinkLuaModifier( "modifier_nights_ancient_armor_aura", "abilities/nights_ancient_armor_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_nights_ancient_armor_aura_buff", "abilities/nights_ancient_armor_aura", LUA_MODIFIER_MOTION_NONE )

nights_ancient_armor_aura = class ({})

--------------------------------------------------------------------------------

function nights_ancient_armor_aura:GetIntrinsicModifierName()
	return "modifier_nights_ancient_armor_aura"
end

--------------------------------------------------------------------------------

modifier_nights_ancient_armor_aura = class({})

--------------------------------------------------------------------------------

function modifier_nights_ancient_armor_aura:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_nights_ancient_armor_aura:IsAura()
	return true
end

function modifier_nights_ancient_armor_aura:GetAuraRadius()
    if IsServer() then
        if GameRules:IsDaytime() then
            return 3500
        else
            return 99999
        end
    end
end

function modifier_nights_ancient_armor_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_nights_ancient_armor_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_nights_ancient_armor_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_nights_ancient_armor_aura:GetModifierAura()
	return "modifier_nights_ancient_armor_aura_buff"
end

--------------------------------------------------------------------------------

modifier_nights_ancient_armor_aura_buff = class({})

function modifier_nights_ancient_armor_aura_buff:IsHidden()
	return false
end

function modifier_nights_ancient_armor_aura_buff:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_nights_ancient_armor_aura_buff:GetModifierPhysicalArmorBonus( params )
    return self:GetAbility():GetLevelSpecialValueFor("armor", self:GetCaster():GetModifierStackCount("modifier_nights_ancient_armor_aura", self:GetCaster()))
end

function modifier_nights_ancient_armor_aura_buff:GetModifierConstantHealthRegen( params )
    return self:GetAbility():GetLevelSpecialValueFor("hp_regen", self:GetCaster():GetModifierStackCount("modifier_nights_ancient_armor_aura", self:GetCaster()))
end