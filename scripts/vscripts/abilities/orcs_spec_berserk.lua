LinkLuaModifier( "modifier_orcs_spec_berserk_aura" , "abilities/orcs_spec_berserk.lua" , LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_orcs_spec_berserk" , "abilities/orcs_spec_berserk.lua" , LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------

function ApplyLuaModifier( keys )
    local caster = keys.caster
    local ability = keys.ability
    local modifiername = keys.ModifierName

    caster:AddNewModifier(caster, ability, modifiername, {})
end

----------------------------------------------------------------------------------

orcs_spec_berserk_pass = class ({})

--------------------------------------------------------------------------------

function orcs_spec_berserk_pass:GetIntrinsicModifierName()
	return "modifier_orcs_spec_berserk_aura"
end

----------------------------------------------------------------------------------

modifier_orcs_spec_berserk_aura = class({})

function modifier_orcs_spec_berserk_aura:IsHidden()
	return true;
end

function modifier_orcs_spec_berserk_aura:IsAura()
	return true
end

function modifier_orcs_spec_berserk_aura:GetAuraRadius()
	return 9999999
end

function modifier_orcs_spec_berserk_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
end

function modifier_orcs_spec_berserk_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_orcs_spec_berserk_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_orcs_spec_berserk_aura:GetModifierAura()
	return "modifier_orcs_spec_berserk"
end

----------------------------------------------------------------------------------

if modifier_orcs_spec_berserk == nil then
    modifier_orcs_spec_berserk = class({})
end

function modifier_orcs_spec_berserk:OnCreated()
	-- Variables
	self.stack = self:GetAbility():GetSpecialValueFor( "stack" )
	self.damage_per_stack = self:GetAbility():GetSpecialValueFor( "damage_per_stack" )
	self.as_per_stack = self:GetAbility():GetSpecialValueFor( "as_per_stack" )


    if IsServer() then
        self:SetStackCount( 0 )
    end
end

function modifier_orcs_spec_berserk:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_orcs_spec_berserk:GetModifierDamageOutgoing_Percentage( params )
	if IsServer() then
		-- Variables
		local caster = self:GetParent()
		local hp_now = caster:GetHealth()
		local hp_ceiling = caster:GetMaxHealth()
		local stack1 = hp_ceiling / self.stack
		local hp_diff = hp_ceiling - hp_now

	    local newStackCount = math.floor(hp_diff/stack1)

    	self:SetStackCount( newStackCount )
		return newStackCount
	else
		return self:GetStackCount() * self.damage_per_stack
	end
end

function modifier_orcs_spec_berserk:GetModifierAttackSpeedBonus_Constant( params )
		return self:GetStackCount() * self.as_per_stack
end