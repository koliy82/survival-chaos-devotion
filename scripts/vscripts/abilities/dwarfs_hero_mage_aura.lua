LinkLuaModifier( "modifier_dwarfs_hero_mage_aura", "abilities/dwarfs_hero_mage_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dwarfs_hero_mage_aura_stack", "abilities/dwarfs_hero_mage_aura", LUA_MODIFIER_MOTION_NONE )

dwarfs_hero_mage_aura = class ({})

--------------------------------------------------------------------------------

function dwarfs_hero_mage_aura:GetIntrinsicModifierName()
	return "modifier_dwarfs_hero_mage_aura"
end

--------------------------------------------------------------------------------

modifier_dwarfs_hero_mage_aura = class({})

--------------------------------------------------------------------------------

function modifier_dwarfs_hero_mage_aura:OnCreated( kv )
	local ability = self:GetAbility()
	if ability then
		self.radius = ability:GetSpecialValueFor("radius")
	end
	if IsServer() then
		self.buff_mods = {}
        self:SetStackCount(0)
	end
end

function modifier_dwarfs_hero_mage_aura:IsHidden()
	return true
end

function modifier_dwarfs_hero_mage_aura:IsAura()
	return true
end

function modifier_dwarfs_hero_mage_aura:GetAuraRadius()
	return self.radius
end

function modifier_dwarfs_hero_mage_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_dwarfs_hero_mage_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_dwarfs_hero_mage_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_dwarfs_hero_mage_aura:GetModifierAura()
	return "modifier_dwarfs_hero_mage_aura_stack"
end

--------------------------------------------------------------------------------

modifier_dwarfs_hero_mage_aura_stack = class({})

function modifier_dwarfs_hero_mage_aura_stack:IsHidden()
	return false
end

function modifier_dwarfs_hero_mage_aura_stack:OnCreated( kv )
	local ability = self:GetAbility()
	if ability then
		self.armor = ability:GetSpecialValueFor("armor")
		self.hp_regen = ability:GetSpecialValueFor("hp_regen")
	end
	if IsServer() then
		self.aura_owner_mod = self:GetAuraOwner():FindModifierByName("modifier_dwarfs_hero_mage_aura")
		self:SetStackCount(self.aura_owner_mod:GetStackCount())
		table.insert( self.aura_owner_mod.buff_mods, self )
	end
end

function modifier_dwarfs_hero_mage_aura_stack:OnDestroy()
	if IsServer() then
		for k, v in pairs(self.aura_owner_mod.buff_mods) do
			if v == self then
				table.remove(self.aura_owner_mod.buff_mods, k )
			end
		end
	end
end

function modifier_dwarfs_hero_mage_aura_stack:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_EVENT_ON_DEATH
	}

	return funcs
end

function modifier_dwarfs_hero_mage_aura_stack:OnDeath( params )
	if IsServer() then
		if params.unit == self:GetParent() then
			local ability = self:GetAbility()
			local max_stacks = ability:GetSpecialValueFor("max_stacks")
			local stacks = self.aura_owner_mod:GetStackCount()
			if stacks < max_stacks then
				self.aura_owner_mod:SetStackCount(stacks+1)
				for _, v in pairs(self.aura_owner_mod.buff_mods) do
					v:StackCountChanged()
				end
				local stack_duration = ability:GetSpecialValueFor("duration")
				Timers:CreateTimer( stack_duration, function()
					local stacks = self.aura_owner_mod:GetStackCount()
					self.aura_owner_mod:SetStackCount(stacks-1)
					for _, v in pairs(self.aura_owner_mod.buff_mods) do
						v:StackCountChanged()
					end
				end)
			end
		end
	end
	return 0 
end

function modifier_dwarfs_hero_mage_aura_stack:StackCountChanged()
	self:SetStackCount(self.aura_owner_mod:GetStackCount())
end

function modifier_dwarfs_hero_mage_aura_stack:GetModifierPhysicalArmorBonus( params )
    return self.armor * self:GetStackCount()
end

function modifier_dwarfs_hero_mage_aura_stack:GetModifierConstantHealthRegen( params )
    return self.hp_regen * self:GetStackCount()
end