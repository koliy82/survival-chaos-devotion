LinkLuaModifier( "modifier_dwarfs_creeps_mage_aura", "abilities/dwarfs_creeps_mage_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dwarfs_creeps_mage_aura_buff", "abilities/dwarfs_creeps_mage_aura", LUA_MODIFIER_MOTION_NONE )

dwarfs_creeps_mage_aura = class ({})

--------------------------------------------------------------------------------

function dwarfs_creeps_mage_aura:GetIntrinsicModifierName()
	return "modifier_dwarfs_creeps_mage_aura"
end

--------------------------------------------------------------------------------

modifier_dwarfs_creeps_mage_aura = class({})

--------------------------------------------------------------------------------

function modifier_dwarfs_creeps_mage_aura:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_dwarfs_creeps_mage_aura:IsAura()
	return true
end

function modifier_dwarfs_creeps_mage_aura:GetAuraRadius()
	return 500
end

function modifier_dwarfs_creeps_mage_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_dwarfs_creeps_mage_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_dwarfs_creeps_mage_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_dwarfs_creeps_mage_aura:GetModifierAura()
    if IsServer() then return "modifier_dwarfs_creeps_mage_aura_buff" end
end

--------------------------------------------------------------------------------

modifier_dwarfs_creeps_mage_aura_buff = class({})

function modifier_dwarfs_creeps_mage_aura_buff:IsHidden()
	if self:GetParent():GetUnitName() == "npc_dota_dwarfs_hero_tank" or self:GetParent():GetUnitName() == "npc_dota_dwarfs_hero_mage" or self:GetParent():GetUnitName() == "npc_dota_dwarfs_hero_mage_spec" or self:GetParent():GetUnitName() == "npc_dota_dwarfs_hero_pusher" or self:GetParent():GetUnitName() == "npc_dota_dwarfs_clock" or self:GetParent():GetUnitName() == "npc_dota_dwarfs_timber" or self:GetParent():GetUnitName() == "npc_dota_dwarfs_siege" or self:GetParent():GetUnitName() == "npc_dota_dwarfs_air" or self:GetParent():GetUnitName() == "npc_dota_dwarfs_mage" or self:GetParent():GetUnitName() == "npc_dota_dwarfs_melee" then
		return false
	else
		return true
    end
end

function modifier_dwarfs_creeps_mage_aura_buff:OnCreated( params ) --kv
	self.hp_regen = self:GetAbility():GetSpecialValueFor( "hp_regen" )

	if IsServer() and (self:GetParent():GetUnitName() == "npc_dota_dwarfs_hero_tank" or self:GetParent():GetUnitName() == "npc_dota_dwarfs_hero_mage" or self:GetParent():GetUnitName() == "npc_dota_dwarfs_hero_mage_spec" or self:GetParent():GetUnitName() == "npc_dota_dwarfs_hero_pusher" or self:GetParent():GetUnitName() == "npc_dota_dwarfs_clock" or self:GetParent():GetUnitName() == "npc_dota_dwarfs_timber" or self:GetParent():GetUnitName() == "npc_dota_dwarfs_siege" or self:GetParent():GetUnitName() == "npc_dota_dwarfs_air" or self:GetParent():GetUnitName() == "npc_dota_dwarfs_mage" or self:GetParent():GetUnitName() == "npc_dota_dwarfs_melee") then
        self:SetStackCount(1)
    end

end

function modifier_dwarfs_creeps_mage_aura_buff:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_dwarfs_creeps_mage_aura_buff:GetModifierConstantHealthRegen( params )
    return self.hp_regen * self:GetStackCount()
end