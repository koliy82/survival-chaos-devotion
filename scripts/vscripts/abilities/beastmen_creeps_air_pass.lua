LinkLuaModifier( "modifier_beastmen_creeps_air_pass" , "abilities/beastmen_creeps_air_pass.lua" , LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------

function ApplyLuaModifier( keys )
    local caster = keys.caster
    local ability = keys.ability
    local modifiername = keys.ModifierName

    caster:AddNewModifier(caster, ability, modifiername, {})
end

----------------------------------------------------------------------------------

beastmen_creeps_air_pass = class ({})

--------------------------------------------------------------------------------

function beastmen_creeps_air_pass:GetIntrinsicModifierName()
	return "modifier_beastmen_creeps_air_pass"
end

----------------------------------------------------------------------------------

if modifier_beastmen_creeps_air_pass == nil then
    modifier_beastmen_creeps_air_pass = class({})
end

function modifier_beastmen_creeps_air_pass:OnCreated( params )
	
	if IsServer() then
        self:SetStackCount( 0 )
    end
end

function modifier_beastmen_creeps_air_pass:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_beastmen_creeps_air_pass:GetModifierDamageOutgoing_Percentage( params )
	if IsServer() then
		if self:GetAbility():GetLevel() > 0 then
			local caster = self:GetParent()
			local hp_now = caster:GetHealth()
			local hp_ceiling = caster:GetMaxHealth()
			local stack1 = self:GetAbility():GetLevelSpecialValueFor( "stack" , self:GetAbility():GetLevel() - 1 )
			local hp_diff = hp_ceiling - hp_now

	    	local newStackCount = math.floor(hp_diff/stack1)

    		self:SetStackCount( newStackCount )
			return newStackCount
		end
	else
		return self:GetStackCount() * self:GetAbility():GetLevelSpecialValueFor( "damage_per_stack" , self:GetAbility():GetLevel() - 1 )
	end
end