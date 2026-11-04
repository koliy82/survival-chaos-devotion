LinkLuaModifier( "modifier_dwarfs_race_bonus", "abilities/dwarfs_race_bonus", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dwarfs_race_bonus_buff", "abilities/dwarfs_race_bonus", LUA_MODIFIER_MOTION_NONE )

dwarfs_race_bonus = class ({})

--------------------------------------------------------------------------------

function dwarfs_race_bonus:GetIntrinsicModifierName()
	return "modifier_dwarfs_race_bonus"
end

--------------------------------------------------------------------------------

modifier_dwarfs_race_bonus = class({})

--------------------------------------------------------------------------------

function modifier_dwarfs_race_bonus:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_dwarfs_race_bonus:IsAura()
	return true
end

function modifier_dwarfs_race_bonus:GetAuraRadius()
	return 999999
end

function modifier_dwarfs_race_bonus:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_dwarfs_race_bonus:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_dwarfs_race_bonus:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_dwarfs_race_bonus:GetModifierAura()
	return "modifier_dwarfs_race_bonus_buff"
end

--function modifier_dwarfs_race_bonus:IsAuraActiveOnDeath(  ) end

--------------------------------------------------------------------------------

modifier_dwarfs_race_bonus_buff = class({})

--------------------------------------------------------------------------------

function modifier_dwarfs_race_bonus_buff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_dwarfs_race_bonus_buff:OnCreated( kv )
	local ability = self:GetAbility()
	if ability then
		self.bonus_armor = ability:GetSpecialValueFor("armor")
	end
	if IsServer() then
		local parent = self:GetParent()
        if not parent:IsCustomHero() then
            self:SetStackCount(ability:GetSpecialValueFor("ats"))
        end
	end
end

--------------------------------------------------------------------------------

function modifier_dwarfs_race_bonus_buff:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_dwarfs_race_bonus_buff:GetModifierPhysicalArmorBonus( params )
    return self.bonus_armor
end

--------------------------------------------------------------------------------

function modifier_dwarfs_race_bonus_buff:GetModifierAttackSpeedBonus_Constant( params )
    return self:GetStackCount()
end