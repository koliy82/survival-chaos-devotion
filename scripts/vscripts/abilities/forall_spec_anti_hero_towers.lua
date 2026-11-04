LinkLuaModifier( "modifier_forall_spec_anti_hero_towers_pass", "abilities/forall_spec_anti_hero_towers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_forall_spec_anti_hero_towers_pass_loc", "abilities/forall_spec_anti_hero_towers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_forall_spec_anti_hero_towers_pass_debuff", "abilities/forall_spec_anti_hero_towers", LUA_MODIFIER_MOTION_NONE )

forall_spec_anti_hero_towers_pass = class ({})

--------------------------------------------------------------------------------

function forall_spec_anti_hero_towers_pass:GetIntrinsicModifierName()
	return "modifier_forall_spec_anti_hero_towers_pass_loc"
end

function forall_spec_anti_hero_towers_pass:GetBehavior()
	if self:GetLevel() >= 3 then
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	else
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
end

function forall_spec_anti_hero_towers_pass:CastFilterResult()
	if not IsServer() then return end
	local id = self:GetCaster():GetPlayerOwnerID()
	if self:GetLevel() >= 3 then
		return UF_FAIL_CUSTOM
	elseif _G.playersinfo[id].ancient and _G.playersinfo[id].ancient:GetLevel() > self:GetLevel() then
		return UF_SUCCESS 
	end
	return UF_FAIL_CUSTOM
end

function forall_spec_anti_hero_towers_pass:GetCustomCastError()
	if self:GetLevel() == 1 then
		return "need_ancient_level_2"
	elseif self:GetLevel() == 2 then
		return "need_ancient_level_3"
	elseif self:GetLevel() >= 3 then
		return "Max level"
	end
end

function forall_spec_anti_hero_towers_pass:OnChannelFinish(bInterrupted)
	if not bInterrupted then
		if self:GetLevel() < 3 then
			self:SetLevel(self:GetLevel()+1)
		end
	else
        self:ReturnGold()
	end
end

--------------------------------------------------------------------------------

modifier_forall_spec_anti_hero_towers_pass_loc = class({})

--------------------------------------------------------------------------------

function modifier_forall_spec_anti_hero_towers_pass_loc:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_forall_spec_anti_hero_towers_pass_loc:OnCreated( kv )
	if IsServer() then
		local parent = self:GetParent()
		local id = parent:GetPlayerOwnerID()
		for _, v in pairs(_G.playersinfo[id].towers) do
			v:AddNewModifier(parent, self:GetAbility(), "modifier_forall_spec_anti_hero_towers_pass", {})
		end
	end
end

--------------------------------------------------------------------------------

modifier_forall_spec_anti_hero_towers_pass = class({})

--------------------------------------------------------------------------------

function modifier_forall_spec_anti_hero_towers_pass:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_forall_spec_anti_hero_towers_pass:OnCreated( kv )
	if IsServer() then
		local parent = self:GetParent()
        parent.custom_damage_armor_multiplier[5] = parent.custom_damage_armor_multiplier[5] + 3 --4
	end
end

--------------------------------------------------------------------------------

function modifier_forall_spec_anti_hero_towers_pass:IsAura()
	return true
end

function modifier_forall_spec_anti_hero_towers_pass:GetAuraRadius()
	return 1800
end

function modifier_forall_spec_anti_hero_towers_pass:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_forall_spec_anti_hero_towers_pass:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_forall_spec_anti_hero_towers_pass:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_forall_spec_anti_hero_towers_pass:GetModifierAura()
	return "modifier_forall_spec_anti_hero_towers_pass_debuff"
end

--function modifier_forall_spec_anti_hero_towers_pass:IsAuraActiveOnDeath(  ) end

--------------------------------------------------------------------------------

modifier_forall_spec_anti_hero_towers_pass_debuff = class({})

--------------------------------------------------------------------------------

function modifier_forall_spec_anti_hero_towers_pass_debuff:IsHidden()
	return self:GetStackCount() == 0
end

--------------------------------------------------------------------------------

function modifier_forall_spec_anti_hero_towers_pass_debuff:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_forall_spec_anti_hero_towers_pass_debuff:OnCreated( kv )
	if IsServer() then
		local parent = self:GetParent()
        if parent:IsCustomHero() then
			self:SetStackCount(-self:GetAbility():GetSpecialValueFor("armor"))
			self:StartIntervalThink(2)
        end
	end
end

--------------------------------------------------------------------------------

function modifier_forall_spec_anti_hero_towers_pass_debuff:OnIntervalThink()
	if IsServer() then
		local parent = self:GetParent()
        if self:GetAbility() and parent:IsCustomHero() then
			self:SetStackCount(-self:GetAbility():GetSpecialValueFor("armor"))
        end
	end
end

--------------------------------------------------------------------------------

function modifier_forall_spec_anti_hero_towers_pass_debuff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_forall_spec_anti_hero_towers_pass_debuff:GetModifierPhysicalArmorBonus( params )
    return self:GetStackCount()
end