LinkLuaModifier( "modifier_elementals_race_bonus", "abilities/elementals_race_bonus", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_elementals_race_bonus_buff", "abilities/elementals_race_bonus", LUA_MODIFIER_MOTION_NONE )

elementals_race_bonus = class ({})

--------------------------------------------------------------------------------

function elementals_race_bonus:GetIntrinsicModifierName()
	return "modifier_elementals_race_bonus"
end

--------------------------------------------------------------------------------


modifier_elementals_race_bonus = class({})

--------------------------------------------------------------------------------

function modifier_elementals_race_bonus:IsHidden()
	return true;
end

--------------------------------------------------------------------------------

function modifier_elementals_race_bonus:IsAura()
	return true
end

function modifier_elementals_race_bonus:GetAuraRadius()
	return 9999999
end

function modifier_elementals_race_bonus:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_elementals_race_bonus:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_elementals_race_bonus:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_elementals_race_bonus:GetModifierAura()
	return "modifier_elementals_race_bonus_buff"
end

--function modifier_elementals_race_bonus:IsAuraActiveOnDeath(  ) end

--------------------------------------------------------------------------------

modifier_elementals_race_bonus_buff = class({})

--------------------------------------------------------------------------------

function modifier_elementals_race_bonus_buff:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_elementals_race_bonus_buff:IsBuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_elementals_race_bonus_buff:OnCreated( kv )
	if IsServer() then
		-- local ability = self:GetAbility()
		-- local level = ability:GetLevel()
		local par = self:GetParent()
        -- self.damage = ability:GetLevelSpecialValueFor( "damage" , level - 1  )
        if par:IsAncient() then
            self:SetStackCount(-1)
        end
	end
end

--------------------------------------------------------------------------------

function modifier_elementals_race_bonus_buff:DeclareFunctions()
    local par = self:GetParent()
    local unit_name = par:GetUnitName()
	local funcs = 
	{
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
    if unit_name == "npc_dota_custom_barrack" then
        funcs = 
		{
			MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
			MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
			MODIFIER_EVENT_ON_ATTACK_LANDED
		}
	end

	return funcs
end

--------------------------------------------------------------------------------

function modifier_elementals_race_bonus_buff:GetModifierPreAttack_BonusDamage( params )
	if IsServer() then
		local par = self:GetParent()
		if not par:IsAncient() and RandomInt(1, 100) <= 12 then
			return RandomInt(par:GetBaseDamageMin(), par:GetBaseDamageMax())
		end
	end
    -- return self:GetStackCount()
end

function modifier_elementals_race_bonus_buff:GetModifierPhysicalArmorBonus( params )
    return self:GetStackCount() * -1
end

function modifier_elementals_race_bonus_buff:OnAttackLanded( params )
	if IsServer() then
		local par = self:GetParent()
        local target = params.target
        if par:GetUnitName() == "npc_dota_custom_barrack" and par == target and RandomInt(1, 100) <= 10 then
            params.attacker:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 1})
        end
    end
end