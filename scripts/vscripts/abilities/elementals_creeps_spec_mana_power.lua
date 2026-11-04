LinkLuaModifier( "modifier_elementals_creeps_spec_mana_power_aura" , "abilities/elementals_creeps_spec_mana_power.lua" , LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_elementals_creeps_spec_mana_power" , "abilities/elementals_creeps_spec_mana_power.lua" , LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------

function ApplyLuaModifier( keys )
    local caster = keys.caster
    local ability = keys.ability
    local modifiername = keys.ModifierName

    caster:AddNewModifier(caster, ability, modifiername, {})
end

----------------------------------------------------------------------------------

elementals_spec_mana_power_pass = class ({})

--------------------------------------------------------------------------------

function elementals_spec_mana_power_pass:GetIntrinsicModifierName()
	return "modifier_elementals_creeps_spec_mana_power_aura"
end

----------------------------------------------------------------------------------

modifier_elementals_creeps_spec_mana_power_aura = class({})

function modifier_elementals_creeps_spec_mana_power_aura:IsHidden()
	return true;
end

function modifier_elementals_creeps_spec_mana_power_aura:IsAura()
	return true
end

function modifier_elementals_creeps_spec_mana_power_aura:GetAuraRadius()
	return 9999999
end

function modifier_elementals_creeps_spec_mana_power_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

function modifier_elementals_creeps_spec_mana_power_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_elementals_creeps_spec_mana_power_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_elementals_creeps_spec_mana_power_aura:GetModifierAura()
	return "modifier_elementals_creeps_spec_mana_power"
end

----------------------------------------------------------------------------------

if modifier_elementals_creeps_spec_mana_power == nil then
    modifier_elementals_creeps_spec_mana_power = class({})
end

function modifier_elementals_creeps_spec_mana_power:OnCreated()
	-- Variables
	self.stack = self:GetAbility():GetSpecialValueFor( "stack" )


    if IsServer() then
        self:SetStackCount( 0 )
    end
end

function modifier_elementals_creeps_spec_mana_power:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_elementals_creeps_spec_mana_power:GetModifierPreAttack_BonusDamage( params )
	if IsServer() and not self:GetParent():IsCustomHero() then
		-- Variables
		local caster = self:GetParent()
		local mana_now = caster:GetMana()
		local mana_ceiling = caster:GetMaxMana()
		local mana_diff = mana_ceiling - mana_now

	    local newStackCount = math.floor(mana_diff/self.stack)

    	self:SetStackCount( newStackCount )
		return newStackCount
	else
		return self:GetStackCount()
	end
end

function modifier_elementals_creeps_spec_mana_power:GetModifierAttackSpeedBonus_Constant( params )
	return 12
end