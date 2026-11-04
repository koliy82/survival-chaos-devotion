LinkLuaModifier( "modifier_invaders_race_bonus_neutrals", "abilities/invaders_race_bonus", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invaders_race_bonus_neutrals_buff", "abilities/invaders_race_bonus", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invaders_race_bonus_debuff_aura", "abilities/invaders_race_bonus", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_invaders_race_bonus_debuff", "abilities/invaders_race_bonus", LUA_MODIFIER_MOTION_NONE )

function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()
    --ability:ApplyDataDrivenModifier(caster, _G.playersinfo[id].spec, "modifier_invaders_race_bonus_buff_aura", {})
    caster:AddNewModifier(caster, ability, "modifier_invaders_race_bonus_debuff_aura", {})
    caster:AddNewModifier(caster, ability, "modifier_invaders_race_bonus_neutrals", {})
end

--------------------------------------------------------------------------------

modifier_invaders_race_bonus_neutrals = class({})

function modifier_invaders_race_bonus_neutrals:OnCreated( params )
    if IsServer() then
        self.team = self:GetCaster():GetTeam()
        self.max_neutrals = self:GetAbility():GetSpecialValueFor( "max_neutrals" )
        self.neutrals = 0
        ListenToGameEvent('capture_neutral', self.OnCaptureNeutral, self)
    end
end

function modifier_invaders_race_bonus_neutrals:OnDestroy()
    if IsServer() then
        StopListeningToAllGameEvents(self)
    end
end

function modifier_invaders_race_bonus_neutrals:OnCaptureNeutral(event)
    if self.team == event.old_team then
        self.neutrals = self.neutrals - 1
        self:SetStackCount(math.min(self.neutrals, self.max_neutrals))
    end
    if self.team == event.new_team then
        self.neutrals = self.neutrals + 1
        self:SetStackCount(math.min(self.neutrals, self.max_neutrals))
    end
end

function modifier_invaders_race_bonus_neutrals:IsHidden()
    return true
end

function modifier_invaders_race_bonus_neutrals:RemoveOnDeath()
    return false
end

function modifier_invaders_race_bonus_neutrals:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_invaders_race_bonus_neutrals:IsAura()
	return true
end

function modifier_invaders_race_bonus_neutrals:GetAuraRadius()
	return 9999999
end

function modifier_invaders_race_bonus_neutrals:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_invaders_race_bonus_neutrals:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_invaders_race_bonus_neutrals:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_invaders_race_bonus_neutrals:GetModifierAura()
    return "modifier_invaders_race_bonus_neutrals_buff"
end

--------------------------------------------------------------------------------

modifier_invaders_race_bonus_neutrals_buff = class({})

function modifier_invaders_race_bonus_neutrals_buff:IsHidden()
	return false
end

function modifier_invaders_race_bonus_neutrals_buff:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_invaders_race_bonus_neutrals_buff:GetModifierDamageOutgoing_Percentage( params )
    local aura = 0
    if self:GetCaster():HasModifier("modifier_invaders_ancient_race_aura") then
        aura = 3
    end
    return self:GetCaster():GetModifierStackCount("modifier_invaders_race_bonus_neutrals", self:GetCaster()) * (self:GetAbility():GetSpecialValueFor( "damage_per_neutral" ) + aura)
end

function modifier_invaders_race_bonus_neutrals_buff:GetModifierAttackSpeedBonus_Constant( params )
    local aura = 0
    if self:GetCaster():HasModifier("modifier_invaders_ancient_race_aura") then
        aura = 3
    end
    return self:GetCaster():GetModifierStackCount("modifier_invaders_race_bonus_neutrals", self:GetCaster()) * (self:GetAbility():GetSpecialValueFor( "ats_per_neutral" ) + aura)
end

--------------------------------------------------------------------------------

modifier_invaders_race_bonus_debuff_aura = class({})

function modifier_invaders_race_bonus_debuff_aura:OnCreated( params )
    if IsServer() then
        self:SetStackCount(self:GetAbility():GetSpecialValueFor( "radius" ))
    end
end

function modifier_invaders_race_bonus_debuff_aura:IsHidden()
    return true
end

function modifier_invaders_race_bonus_debuff_aura:RemoveOnDeath()
    return false
end

function modifier_invaders_race_bonus_debuff_aura:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_invaders_race_bonus_debuff_aura:IsAura()
	return true
end

function modifier_invaders_race_bonus_debuff_aura:GetAuraRadius()
	return self:GetStackCount()
end

function modifier_invaders_race_bonus_debuff_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_invaders_race_bonus_debuff_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_invaders_race_bonus_debuff_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_invaders_race_bonus_debuff_aura:GetModifierAura()
    return "modifier_invaders_race_bonus_debuff"
end

--------------------------------------------------------------------------------

modifier_invaders_race_bonus_debuff = class({})

function modifier_invaders_race_bonus_debuff:IsHidden()
	return false
end

function modifier_invaders_race_bonus_debuff:IsDebuff()
	return true
end

function modifier_invaders_race_bonus_debuff:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}

	return funcs
end

function modifier_invaders_race_bonus_debuff:GetModifierDamageOutgoing_Percentage( params )
    local aura = 0
    if self:GetCaster():HasModifier("modifier_invaders_ancient_race_aura") then
        aura = 3
    end
    return -self:GetCaster():GetModifierStackCount("modifier_invaders_race_bonus_neutrals", self:GetCaster()) * (self:GetAbility():GetSpecialValueFor( "damage_per_neutral" ) + aura)
end

function modifier_invaders_race_bonus_debuff:GetModifierAttackSpeedBonus_Constant( params )
    local aura = 0
    if self:GetCaster():HasModifier("modifier_invaders_ancient_race_aura") then
        aura = 3
    end
    return -self:GetCaster():GetModifierStackCount("modifier_invaders_race_bonus_neutrals", self:GetCaster()) * (self:GetAbility():GetSpecialValueFor( "ats_per_neutral" ) + aura)
end

function modifier_invaders_race_bonus_debuff:GetModifierPhysicalArmorBonus( params )
    return -self:GetAbility():GetSpecialValueFor( "armor" )
end