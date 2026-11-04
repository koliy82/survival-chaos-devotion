LinkLuaModifier( "modifier_treants_range_death_pass_debuff", "modifiers/modifier_treants_range_death_pass", LUA_MODIFIER_MOTION_NONE )

modifier_treants_range_death_pass = class({})

--------------------------------------------------------------------------------

function modifier_treants_range_death_pass:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_treants_range_death_pass:OnCreated( kv )
	if IsServer() then
		self.radius = kv.radius
		local parent = self:GetParent()
		parent.damage = kv.damage
		parent.min_armor = kv.min_armor
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, parent:GetAbsOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.radius,1,1) )
		self:AddParticle( nFXIndex, false, false, -1, false, false )
	end
end

--------------------------------------------------------------------------------

function modifier_treants_range_death_pass:IsAura()
	return true
end

function modifier_treants_range_death_pass:GetAuraRadius()
	return self.radius
end

function modifier_treants_range_death_pass:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_treants_range_death_pass:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_treants_range_death_pass:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_treants_range_death_pass:GetModifierAura()
	return "modifier_treants_range_death_pass_debuff"
end

--function modifier_treants_range_death_pass:IsAuraActiveOnDeath(  ) end

--------------------------------------------------------------------------------

modifier_treants_range_death_pass_debuff = class({})

--------------------------------------------------------------------------------

function modifier_treants_range_death_pass_debuff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_treants_range_death_pass_debuff:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_treants_range_death_pass_debuff:OnCreated( kv )
	if IsServer() then
		local auraOwner = self:GetAuraOwner()
		self.damage = auraOwner.damage
		self:SetStackCount(auraOwner.min_armor)
		-- self.damage = ability:GetLevelSpecialValueFor( "damage" , level - 1  )
		-- self:SetStackCount(ability:GetLevelSpecialValueFor( "min_armor" , level - 1  ))
		self:StartIntervalThink(0.5)
	end
end

--------------------------------------------------------------------------------

function modifier_treants_range_death_pass_debuff:OnIntervalThink()
	if IsServer() then
		ApplyCustomDamage(self:GetParent(), self:GetCaster(), self.damage, 6, nil)
	end
end

--------------------------------------------------------------------------------

function modifier_treants_range_death_pass_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_treants_range_death_pass_debuff:GetModifierPhysicalArmorBonus( params )
    return self:GetStackCount()
end