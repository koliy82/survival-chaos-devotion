LinkLuaModifier( "modifier_primordials_ancient_hero_buff", "abilities/primordials_ancient_hero_buff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_primordials_ancient_hero_buff_buff", "abilities/primordials_ancient_hero_buff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

primordials_ancient_hero_buff = class ({})

function primordials_ancient_hero_buff:GetIntrinsicModifierName()
	return "modifier_primordials_ancient_hero_buff"
end

--------------------------------------------------------------------------------

modifier_primordials_ancient_hero_buff = class({})

function modifier_primordials_ancient_hero_buff:IsHidden()
	return true
end

function modifier_primordials_ancient_hero_buff:IsAura()
	return true
end

function modifier_primordials_ancient_hero_buff:GetAuraRadius()
	return 9999999
end

function modifier_primordials_ancient_hero_buff:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_primordials_ancient_hero_buff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_primordials_ancient_hero_buff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_primordials_ancient_hero_buff:GetModifierAura()
    return "modifier_primordials_ancient_hero_buff_buff"
end

--------------------------------------------------------------------------------

modifier_primordials_ancient_hero_buff_buff = class({})

function modifier_primordials_ancient_hero_buff_buff:IsHidden()
	return false
end

function modifier_primordials_ancient_hero_buff_buff:OnCreated(event)
    local ability = self:GetAbility()
    self.damage = ability:GetLevelSpecialValueFor("damage", 0)
    self.armor = ability:GetLevelSpecialValueFor("armor", 0)
    self.regen = ability:GetLevelSpecialValueFor("regen", 0)
    self.mana_regen = ability:GetLevelSpecialValueFor("mana_regen", 0)
    self.ats = ability:GetLevelSpecialValueFor("ats", 0)
    self.cdr = ability:GetLevelSpecialValueFor("cdr", 0)
    if IsServer() then
        local parent = self:GetParent()
        if parent:IsCustomHero() then
            self:SetStackCount(1)
        end
    end
end

function modifier_primordials_ancient_hero_buff_buff:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
	}

	return funcs
end

function modifier_primordials_ancient_hero_buff_buff:GetModifierDamageOutgoing_Percentage( params )
    return self:GetStackCount()*self.damage
end

function modifier_primordials_ancient_hero_buff_buff:GetModifierPhysicalArmorBonus( params )
    return self:GetStackCount()*self.armor
end

function modifier_primordials_ancient_hero_buff_buff:GetModifierConstantHealthRegen( params )
    return self:GetStackCount()*self.regen
end

function modifier_primordials_ancient_hero_buff_buff:GetModifierConstantManaRegen( params )
    return self:GetStackCount()*self.mana_regen
end

function modifier_primordials_ancient_hero_buff_buff:GetModifierAttackSpeedBonus_Constant( params )
    return self:GetStackCount()*self.ats
end

function modifier_primordials_ancient_hero_buff_buff:GetModifierPercentageCooldown( params )
    return self:GetStackCount()*self.cdr
end
