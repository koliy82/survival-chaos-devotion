LinkLuaModifier( "modifier_neutrals_buids_3_debuff", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_4_buff", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_5_buff", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_6_buff", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_7_buff", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_8_buff", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_9_buff", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_10_buff", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_11_buff", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_12_buff", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_13_buff", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_14_debuff", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_15_buff", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_16_buff", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

modifier_neutrals_buids_2_buff = class({})

function modifier_neutrals_buids_2_buff:OnStackCountChanged(stacks)
	self.mana_regen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
end

function modifier_neutrals_buids_2_buff:OnCreated( kv )
	self.mana_regen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
end

function modifier_neutrals_buids_2_buff:IsHidden()
	return true
end

function modifier_neutrals_buids_2_buff:IsBuff()
	return true
end

function modifier_neutrals_buids_2_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_neutrals_buids_2_buff:GetModifierConstantManaRegen( params )
	return self.mana_regen
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_3 = class({})
modifier_neutrals_buids_3.OnCustomRefresh = {}

function modifier_neutrals_buids_3:OnCreated( kv )
	self:GetAbility():GetCaster().neutral_mod = self
end

function modifier_neutrals_buids_3:OnRefresh(table)
	if IsServer() then
		for v, _ in pairs(self.OnCustomRefresh) do
			v:ForceRefresh()
		end
	end
end

function modifier_neutrals_buids_3:IsHidden()
	return true
end

function modifier_neutrals_buids_3:IsAura()
	return true
end

function modifier_neutrals_buids_3:GetAuraRadius()
	return 99999--3000
end

function modifier_neutrals_buids_3:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_neutrals_buids_3:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_neutrals_buids_3:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_neutrals_buids_3:GetModifierAura()
	return "modifier_neutrals_buids_3_debuff"
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_3_debuff = class({})

function modifier_neutrals_buids_3_debuff:IsHidden()
	return true
end

function modifier_neutrals_buids_3_debuff:IsBuff()
	return true
end

function modifier_neutrals_buids_3_debuff:OnRefresh(table)
	self.damage_red = self:GetAbility():GetSpecialValueFor( "damage_red" )
end

function modifier_neutrals_buids_3_debuff:OnCreated( kv )
	self.damage_red = self:GetAbility():GetSpecialValueFor( "damage_red" )

	if IsServer() and not self:GetParent():IsCustomHero() and not self:GetParent():IsAncient() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = 1
        self:SetStackCount(1)
    end
end

function modifier_neutrals_buids_3_debuff:OnDestroy()
	if IsServer() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = nil
    end
end

function modifier_neutrals_buids_3_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_neutrals_buids_3_debuff:GetModifierDamageOutgoing_Percentage( params )
	return self.damage_red * self:GetStackCount()
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_4 = class({})
modifier_neutrals_buids_4.OnCustomRefresh = {}

function modifier_neutrals_buids_4:OnCreated( kv )
	self:GetAbility():GetCaster().neutral_mod = self
end

function modifier_neutrals_buids_4:OnRefresh(table)
	if IsServer() then
		for v, _ in pairs(self.OnCustomRefresh) do
			v:ForceRefresh()
		end
	end
end

function modifier_neutrals_buids_4:IsHidden()
	return true
end

function modifier_neutrals_buids_4:IsAura()
	return true
end

function modifier_neutrals_buids_4:GetAuraRadius()
	return 9999999
end

function modifier_neutrals_buids_4:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_neutrals_buids_4:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_neutrals_buids_4:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_neutrals_buids_4:GetModifierAura()
	return "modifier_neutrals_buids_4_buff"
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_4_buff = class({})

function modifier_neutrals_buids_4_buff:IsHidden()
	return true
end

function modifier_neutrals_buids_4_buff:IsBuff()
	return true
end

function modifier_neutrals_buids_4_buff:OnRefresh(table)
	self.health_regen = self:GetAbility():GetSpecialValueFor( "health_regen" )
end

function modifier_neutrals_buids_4_buff:OnCreated( kv )
	self.health_regen = self:GetAbility():GetSpecialValueFor( "health_regen" )

    if IsServer() and self:GetParent():IsAncient() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = 1
        self:SetStackCount(1)
    end
end

function modifier_neutrals_buids_4_buff:OnDestroy()
	if IsServer() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = nil
    end
end

function modifier_neutrals_buids_4_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_neutrals_buids_4_buff:GetModifierConstantHealthRegen( params )
	return self.health_regen * self:GetStackCount()
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_5 = class({})
modifier_neutrals_buids_5.OnCustomRefresh = {}

function modifier_neutrals_buids_5:OnCreated( kv )
	self:GetAbility():GetCaster().neutral_mod = self
end

function modifier_neutrals_buids_5:OnRefresh(table)
	if IsServer() then
		for v, _ in pairs(self.OnCustomRefresh) do
			v:ForceRefresh()
		end
	end
end

function modifier_neutrals_buids_5:IsHidden()
	return true
end

function modifier_neutrals_buids_5:IsAura()
	return true
end

function modifier_neutrals_buids_5:GetAuraRadius()
	return 99999--3000
end

function modifier_neutrals_buids_5:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_neutrals_buids_5:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_neutrals_buids_5:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_neutrals_buids_5:GetModifierAura()
	return "modifier_neutrals_buids_5_buff"
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_5_buff = class({})

function modifier_neutrals_buids_5_buff:IsHidden()
	return true
end

function modifier_neutrals_buids_5_buff:IsBuff()
	return true
end

function modifier_neutrals_buids_5_buff:OnRefresh(table)
	self.ats = self:GetAbility():GetSpecialValueFor( "ats" )
end

function modifier_neutrals_buids_5_buff:OnCreated( kv )
	self.ats = self:GetAbility():GetSpecialValueFor( "ats" )

	if IsServer() and not self:GetParent():IsCustomHero() and not self:GetParent():IsAncient() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = 1
        self:SetStackCount(1)
    end
end

function modifier_neutrals_buids_5_buff:OnDestroy()
	if IsServer() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = nil
    end
end

function modifier_neutrals_buids_5_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_neutrals_buids_5_buff:GetModifierAttackSpeedBonus_Constant( params )
	return self.ats * self:GetStackCount()
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_6 = class({})
modifier_neutrals_buids_6.OnCustomRefresh = {}

function modifier_neutrals_buids_6:OnCreated( kv )
	self:GetAbility():GetCaster().neutral_mod = self
end

function modifier_neutrals_buids_6:OnRefresh(table)
	if IsServer() then
		for v, _ in pairs(self.OnCustomRefresh) do
			v:ForceRefresh()
		end
	end
end

function modifier_neutrals_buids_6:IsHidden()
	return true
end

function modifier_neutrals_buids_6:IsAura()
	return true
end

function modifier_neutrals_buids_6:GetAuraRadius()
	return 99999--3000
end

function modifier_neutrals_buids_6:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_neutrals_buids_6:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_neutrals_buids_6:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_neutrals_buids_6:GetModifierAura()
	return "modifier_neutrals_buids_6_buff"
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_6_buff = class({})

function modifier_neutrals_buids_6_buff:IsHidden()
	return true
end

function modifier_neutrals_buids_6_buff:IsBuff()
	return true
end

function modifier_neutrals_buids_6_buff:OnRefresh(table)
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.health_regen = self:GetAbility():GetSpecialValueFor( "health_regen" )
	self.mana_regen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
	self.cd_red = self:GetAbility():GetSpecialValueFor( "cd_red" )
end

function modifier_neutrals_buids_6_buff:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.health_regen = self:GetAbility():GetSpecialValueFor( "health_regen" )
	self.mana_regen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
	self.cd_red = self:GetAbility():GetSpecialValueFor( "cd_red" )

	if IsServer() and self:GetParent():IsCustomHero() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = 1
        self:SetStackCount(1)
    end
end

function modifier_neutrals_buids_6_buff:OnDestroy()
	if IsServer() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = nil
    end
end

function modifier_neutrals_buids_6_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}

	return funcs
end

function modifier_neutrals_buids_6_buff:GetModifierDamageOutgoing_Percentage( params )
	return self:GetStackCount()*self.damage
end

function modifier_neutrals_buids_6_buff:GetModifierPhysicalArmorBonus( params )
	return self:GetStackCount()*self.armor
end

function modifier_neutrals_buids_6_buff:GetModifierConstantManaRegen( params )
	return self:GetStackCount()*self.mana_regen
end

function modifier_neutrals_buids_6_buff:GetModifierConstantHealthRegen( params )
	return self:GetStackCount()*self.health_regen
end

function modifier_neutrals_buids_6_buff:GetModifierPercentageCooldown( params )
	return self:GetStackCount()*self.cd_red
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_7 = class({})
modifier_neutrals_buids_7.OnCustomRefresh = {}

function modifier_neutrals_buids_7:OnCreated( kv )
	self:GetAbility():GetCaster().neutral_mod = self
end

function modifier_neutrals_buids_7:OnRefresh(table)
	if IsServer() then
		for v, _ in pairs(self.OnCustomRefresh) do
			v:ForceRefresh()
		end
	end
end

function modifier_neutrals_buids_7:IsHidden()
	return true
end

function modifier_neutrals_buids_7:IsAura()
	return true
end

function modifier_neutrals_buids_7:GetAuraRadius()
	return 99999--3000
end

function modifier_neutrals_buids_7:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_neutrals_buids_7:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_neutrals_buids_7:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_neutrals_buids_7:GetModifierAura()
	return "modifier_neutrals_buids_7_buff"
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_7_buff = class({})

function modifier_neutrals_buids_7_buff:IsHidden()
	return true
end

function modifier_neutrals_buids_7_buff:IsBuff()
	return true
end

function modifier_neutrals_buids_7_buff:OnRefresh(table)
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
end

function modifier_neutrals_buids_7_buff:OnCreated( kv )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )

	if IsServer() and not self:GetParent():IsCustomHero() and not self:GetParent():IsAncient() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = 1
        self:SetStackCount(1)
    end
end

function modifier_neutrals_buids_7_buff:OnDestroy()
	if IsServer() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = nil
    end
end

function modifier_neutrals_buids_7_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_neutrals_buids_7_buff:GetModifierPhysicalArmorBonus( params )
	return self.armor * self:GetStackCount()
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_8 = class({})
modifier_neutrals_buids_8.OnCustomRefresh = {}

function modifier_neutrals_buids_8:OnCreated( kv )
	self:GetAbility():GetCaster().neutral_mod = self
end

function modifier_neutrals_buids_8:OnRefresh(table)
	if IsServer() then
		for v, _ in pairs(self.OnCustomRefresh) do
			v:ForceRefresh()
		end
	end
end

function modifier_neutrals_buids_8:IsHidden()
	return true
end

function modifier_neutrals_buids_8:IsAura()
	return true
end

function modifier_neutrals_buids_8:GetAuraRadius()
	return 9999999
end

function modifier_neutrals_buids_8:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_neutrals_buids_8:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_neutrals_buids_8:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_neutrals_buids_8:GetModifierAura()
	return "modifier_neutrals_buids_8_buff"
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_8_buff = class({})

function modifier_neutrals_buids_8_buff:IsHidden()
	return true
end

function modifier_neutrals_buids_8_buff:IsBuff()
	return true
end

function modifier_neutrals_buids_8_buff:OnRefresh(table)
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
end

function modifier_neutrals_buids_8_buff:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if IsServer() and not self:GetParent():IsCustomHero() and not self:GetParent():IsAncient() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = 1
        self:SetStackCount(1)
    end
end

function modifier_neutrals_buids_8_buff:OnDestroy()
	if IsServer() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = nil
    end
end

function modifier_neutrals_buids_8_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_neutrals_buids_8_buff:GetModifierDamageOutgoing_Percentage( params )
	return self.damage * self:GetStackCount()
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_9 = class({})
modifier_neutrals_buids_9.OnCustomRefresh = {}

function modifier_neutrals_buids_9:OnCreated( kv )
	self:GetAbility():GetCaster().neutral_mod = self
end

function modifier_neutrals_buids_9:OnRefresh(table)
	if IsServer() then
		for v, _ in pairs(self.OnCustomRefresh) do
			v:ForceRefresh()
		end
	end
end

function modifier_neutrals_buids_9:IsHidden()
	return true
end

function modifier_neutrals_buids_9:IsAura()
	return true
end

function modifier_neutrals_buids_9:GetAuraRadius()
	return 9999999
end

function modifier_neutrals_buids_9:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_neutrals_buids_9:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_neutrals_buids_9:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_neutrals_buids_9:GetModifierAura()
	return "modifier_neutrals_buids_9_buff"
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_9_buff = class({})

function modifier_neutrals_buids_9_buff:IsHidden()
	return true
end

function modifier_neutrals_buids_9_buff:IsBuff()
	return true
end

function modifier_neutrals_buids_9_buff:OnRefresh(table)
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )
end

function modifier_neutrals_buids_9_buff:OnCreated( kv )
	self.evasion = self:GetAbility():GetSpecialValueFor( "evasion" )

	if IsServer() and not self:GetParent():IsCustomHero() and not self:GetParent():IsAncient() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = 1
        self:SetStackCount(1)
    end
end

function modifier_neutrals_buids_9_buff:OnDestroy()
	if IsServer() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = nil
    end
end

function modifier_neutrals_buids_9_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}

	return funcs
end

function modifier_neutrals_buids_9_buff:GetModifierEvasion_Constant( params )
	return self.evasion * self:GetStackCount()
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_10 = class({})
modifier_neutrals_buids_10.OnCustomRefresh = {}

function modifier_neutrals_buids_10:OnCreated( kv )
	self:GetAbility():GetCaster().neutral_mod = self
end

function modifier_neutrals_buids_10:OnRefresh(table)
	if IsServer() then
		for v, _ in pairs(self.OnCustomRefresh) do
			v:ForceRefresh()
		end
	end
end

function modifier_neutrals_buids_10:IsHidden()
	return true
end

function modifier_neutrals_buids_10:IsAura()
	return true
end

function modifier_neutrals_buids_10:GetAuraRadius()
	return 9999999
end

function modifier_neutrals_buids_10:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_neutrals_buids_10:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_neutrals_buids_10:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_neutrals_buids_10:GetModifierAura()
	return "modifier_neutrals_buids_10_buff"
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_10_buff = class({})

function modifier_neutrals_buids_10_buff:IsHidden()
	return true
end

function modifier_neutrals_buids_10_buff:IsBuff()
	return true
end

function modifier_neutrals_buids_10_buff:OnRefresh(table)
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.health_regen = self:GetAbility():GetSpecialValueFor( "health_regen" )
end

function modifier_neutrals_buids_10_buff:OnCreated( kv )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
	self.health_regen = self:GetAbility():GetSpecialValueFor( "health_regen" )

    if IsServer() and self:GetParent():IsAncient() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = 1
        self:SetStackCount(1)
    end
end

function modifier_neutrals_buids_10_buff:OnDestroy()
	if IsServer() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = nil
    end
end

function modifier_neutrals_buids_10_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_neutrals_buids_10_buff:GetModifierPhysicalArmorBonus( params )
	return self:GetStackCount()*self.armor
end

function modifier_neutrals_buids_10_buff:GetModifierConstantHealthRegen( params )
	return self:GetStackCount()*self.health_regen
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_11 = class({})
modifier_neutrals_buids_11.OnCustomRefresh = {}

function modifier_neutrals_buids_11:OnCreated( kv )
	self:GetAbility():GetCaster().neutral_mod = self
end

function modifier_neutrals_buids_11:OnRefresh(table)
	if IsServer() then
		for v, _ in pairs(self.OnCustomRefresh) do
			v:ForceRefresh()
		end
	end
end

function modifier_neutrals_buids_11:IsHidden()
	return true
end

function modifier_neutrals_buids_11:IsAura()
	return true
end

function modifier_neutrals_buids_11:GetAuraRadius()
	return 99999--3000
end

function modifier_neutrals_buids_11:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_neutrals_buids_11:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_neutrals_buids_11:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_neutrals_buids_11:GetModifierAura()
	return "modifier_neutrals_buids_11_buff"
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_11_buff = class({})

function modifier_neutrals_buids_11_buff:IsHidden()
	return true
end

function modifier_neutrals_buids_11_buff:IsBuff()
	return true
end

function modifier_neutrals_buids_11_buff:OnRefresh(table)
	self.health_regen = self:GetAbility():GetSpecialValueFor( "health_regen" )
	self.mana_regen = self:GetAbility():GetSpecialValueFor( "mana_regen" )
end

function modifier_neutrals_buids_11_buff:OnCreated( kv )
	self.health_regen = self:GetAbility():GetSpecialValueFor( "health_regen" )
	self.mana_regen = self:GetAbility():GetSpecialValueFor( "mana_regen" )

	if IsServer() and self:GetParent():IsCustomHero() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = 1
        self:SetStackCount(1)
    end
end

function modifier_neutrals_buids_11_buff:OnDestroy()
	if IsServer() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = nil
    end
end

function modifier_neutrals_buids_11_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_neutrals_buids_11_buff:GetModifierConstantManaRegen( params )
	return self:GetStackCount()*self.mana_regen
end

function modifier_neutrals_buids_11_buff:GetModifierConstantHealthRegen( params )
	return self:GetStackCount()*self.health_regen
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_12 = class({})
modifier_neutrals_buids_12.OnCustomRefresh = {}

function modifier_neutrals_buids_12:OnCreated( kv )
	self:GetAbility():GetCaster().neutral_mod = self
end

function modifier_neutrals_buids_12:OnRefresh(table)
	if IsServer() then
		for v, _ in pairs(self.OnCustomRefresh) do
			v:ForceRefresh()
		end
	end
end

function modifier_neutrals_buids_12:IsHidden()
	return true
end

function modifier_neutrals_buids_12:IsAura()
	return true
end

function modifier_neutrals_buids_12:GetAuraRadius()
	return 9999999
end

function modifier_neutrals_buids_12:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_neutrals_buids_12:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_neutrals_buids_12:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_neutrals_buids_12:GetModifierAura()
	return "modifier_neutrals_buids_12_buff"
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_12_buff = class({})

function modifier_neutrals_buids_12_buff:IsHidden()
	return true
end

function modifier_neutrals_buids_12_buff:IsBuff()
	return true
end

function modifier_neutrals_buids_12_buff:OnRefresh(table)
	self.health_regen = self:GetAbility():GetSpecialValueFor( "health_regen" )
end

function modifier_neutrals_buids_12_buff:OnCreated( kv )
	self.health_regen = self:GetAbility():GetSpecialValueFor( "health_regen" )

	if IsServer() and not self:GetParent():IsCustomHero() and not self:GetParent():IsAncient() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = 1
        self:SetStackCount(1)
    end
end

function modifier_neutrals_buids_12_buff:OnDestroy()
	if IsServer() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = nil
    end
end

function modifier_neutrals_buids_12_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_neutrals_buids_12_buff:GetModifierConstantHealthRegen( params )
	return self.health_regen * self:GetStackCount()
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_13 = class({})
modifier_neutrals_buids_13.OnCustomRefresh = {}

function modifier_neutrals_buids_13:OnCreated( kv )
	self:GetAbility():GetCaster().neutral_mod = self
end

function modifier_neutrals_buids_13:OnRefresh(table)
	if IsServer() then
		for v, _ in pairs(self.OnCustomRefresh) do
			v:ForceRefresh()
		end
	end
end

function modifier_neutrals_buids_13:IsHidden()
	return true
end

function modifier_neutrals_buids_13:IsAura()
	return true
end

function modifier_neutrals_buids_13:GetAuraRadius()
	return 9999999
end

function modifier_neutrals_buids_13:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_neutrals_buids_13:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_neutrals_buids_13:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_neutrals_buids_13:GetModifierAura()
	return "modifier_neutrals_buids_13_buff"
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_13_buff = class({})

function modifier_neutrals_buids_13_buff:IsHidden()
	return true
end

function modifier_neutrals_buids_13_buff:IsBuff()
	return true
end

function modifier_neutrals_buids_13_buff:OnRefresh(table)
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
	self.ats = self:GetAbility():GetSpecialValueFor( "ats" )
	self:OnStackCountChanged(nil)
end

function modifier_neutrals_buids_13_buff:OnCreated( kv )
	self.movespeed = self:GetAbility():GetSpecialValueFor( "movespeed" )
	self.ats = self:GetAbility():GetSpecialValueFor( "ats" )

	if IsServer() and not self:GetParent():IsAncient() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = 1
        self:SetStackCount(1)
    end
	self:OnStackCountChanged(nil)
end

function modifier_neutrals_buids_13_buff:OnDestroy()
	if IsServer() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = nil
    end
end

function modifier_neutrals_buids_13_buff:OnStackCountChanged(old_stacks)
	self.movespeed_buff = self:GetStackCount() * self.movespeed
	self.ats_buff = self:GetStackCount() * self.ats
end

function modifier_neutrals_buids_13_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_neutrals_buids_13_buff:GetModifierMoveSpeedBonus_Percentage( params )
	return self.movespeed_buff
end

function modifier_neutrals_buids_13_buff:GetModifierAttackSpeedBonus_Constant( params )
	return self.ats_buff
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_14 = class({})
modifier_neutrals_buids_14.OnCustomRefresh = {}

function modifier_neutrals_buids_14:OnCreated( kv )
	self:GetAbility():GetCaster().neutral_mod = self
end

function modifier_neutrals_buids_14:OnRefresh(table)
	if IsServer() then
		for v, _ in pairs(self.OnCustomRefresh) do
			v:ForceRefresh()
		end
	end
end

function modifier_neutrals_buids_14:IsHidden()
	return true
end

function modifier_neutrals_buids_14:IsAura()
	return true
end

function modifier_neutrals_buids_14:GetAuraRadius()
	return 99999--3000
end

function modifier_neutrals_buids_14:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_neutrals_buids_14:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_neutrals_buids_14:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_neutrals_buids_14:GetModifierAura()
	return "modifier_neutrals_buids_14_debuff"
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_14_debuff = class({})

function modifier_neutrals_buids_14_debuff:IsHidden()
	return true
end

function modifier_neutrals_buids_14_debuff:IsBuff()
	return true
end

function modifier_neutrals_buids_14_debuff:OnRefresh(table)
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
end

function modifier_neutrals_buids_14_debuff:OnCreated( kv )
	self.armor = self:GetAbility():GetSpecialValueFor( "armor" )

    if IsServer() and not self:GetParent():IsCustomHero() and not self:GetParent():IsAncient() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = 1
        self:SetStackCount(1)
    end
end

function modifier_neutrals_buids_14_debuff:OnDestroy()
	if IsServer() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = nil
    end
end

function modifier_neutrals_buids_14_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_neutrals_buids_14_debuff:GetModifierPhysicalArmorBonus( params )
	return self.armor*self:GetStackCount()
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_15 = class({})
modifier_neutrals_buids_15.OnCustomRefresh = {}

function modifier_neutrals_buids_15:OnCreated( kv )
	self:GetAbility():GetCaster().neutral_mod = self
end

function modifier_neutrals_buids_15:OnRefresh(table)
	if IsServer() then
		for v, _ in pairs(self.OnCustomRefresh) do
			v:ForceRefresh()
		end
	end
end

function modifier_neutrals_buids_15:IsHidden()
	return true
end

function modifier_neutrals_buids_15:IsAura()
	return true
end

function modifier_neutrals_buids_15:GetAuraRadius()
	return 9999999
end

function modifier_neutrals_buids_15:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_neutrals_buids_15:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_neutrals_buids_15:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_neutrals_buids_15:GetModifierAura()
	return "modifier_neutrals_buids_15_buff"
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_15_buff = class({})

function modifier_neutrals_buids_15_buff:IsHidden()
	return true
end

function modifier_neutrals_buids_15_buff:IsBuff()
	return true
end

function modifier_neutrals_buids_15_buff:OnRefresh(table)
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
end

function modifier_neutrals_buids_15_buff:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

    if IsServer() and self:GetParent():IsAncient() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = 1
        self:SetStackCount(1)
    end
end

function modifier_neutrals_buids_15_buff:OnDestroy()
	if IsServer() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = nil
    end
end

function modifier_neutrals_buids_15_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_neutrals_buids_15_buff:GetModifierDamageOutgoing_Percentage( params )
	return self.damage*self:GetStackCount()
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_16 = class({})
modifier_neutrals_buids_16.OnCustomRefresh = {}

function modifier_neutrals_buids_16:OnCreated( kv )
	self:GetAbility():GetCaster().neutral_mod = self
end

function modifier_neutrals_buids_16:OnRefresh(table)
	if IsServer() then
		for v, _ in pairs(self.OnCustomRefresh) do
			v:ForceRefresh()
		end
	end
end

function modifier_neutrals_buids_16:IsHidden()
	return true
end

function modifier_neutrals_buids_16:IsAura()
	return true
end

function modifier_neutrals_buids_16:GetAuraRadius()
	return 99999--3000
end

function modifier_neutrals_buids_16:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_neutrals_buids_16:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_neutrals_buids_16:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_neutrals_buids_16:GetModifierAura()
	return "modifier_neutrals_buids_16_buff"
end

--------------------------------------------------------------------------------

modifier_neutrals_buids_16_buff = class({})

function modifier_neutrals_buids_16_buff:IsHidden()
	if string.find(self:GetParent():GetUnitName(), "barrack") ~= nil then
		return false
	else
		return true
    end
end

function modifier_neutrals_buids_16_buff:IsBuff()
	return true
end

function modifier_neutrals_buids_16_buff:OnRefresh(table)
	self.cd_red = self:GetAbility():GetSpecialValueFor( "cd_red" )
end

function modifier_neutrals_buids_16_buff:OnCreated( kv )
	self.cd_red = self:GetAbility():GetSpecialValueFor( "cd_red" )

    if IsServer() and string.find(self:GetParent():GetUnitName(), "barrack") ~= nil then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = 1
        self:SetStackCount(self.cd_red)
    end
end

function modifier_neutrals_buids_16_buff:OnDestroy()
	if IsServer() then
		self:GetAbility():GetCaster().neutral_mod.OnCustomRefresh[self] = nil
    end
end

--------------------------------------------------------------------------------
