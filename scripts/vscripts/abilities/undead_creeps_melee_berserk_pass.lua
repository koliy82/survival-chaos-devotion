LinkLuaModifier( "modifier_undead_creeps_melee_berserk_pass" , "abilities/undead_creeps_melee_berserk_pass.lua" , LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------

function ApplyLuaModifier( keys )
    local caster = keys.caster
    local ability = keys.ability
    local modifiername = keys.ModifierName

    caster:AddNewModifier(caster, ability, modifiername, {})
end

----------------------------------------------------------------------------------

undead_creeps_melee_berserk_pass = class ({})

--------------------------------------------------------------------------------

function undead_creeps_melee_berserk_pass:GetIntrinsicModifierName()
	return "modifier_undead_creeps_melee_berserk_pass"
end

----------------------------------------------------------------------------------

if modifier_undead_creeps_melee_berserk_pass == nil then
    modifier_undead_creeps_melee_berserk_pass = class({})
end

function modifier_undead_creeps_melee_berserk_pass:OnCreated( params )
	
	if IsServer() then
        self:SetStackCount( 0 )
    end
end

function modifier_undead_creeps_melee_berserk_pass:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_undead_creeps_melee_berserk_pass:GetModifierAttackSpeedBonus_Constant( params )
	if IsServer() then
		if self:GetAbility():GetLevel() > 0 then
			local caster = self:GetParent()
			local hp_now = caster:GetHealth()
			local hp_ceiling = caster:GetMaxHealth()
			local stack1 = hp_ceiling / self:GetAbility():GetLevelSpecialValueFor( "stack" , self:GetAbility():GetLevel() - 1 )
			local hp_diff = hp_ceiling - hp_now

	    	local newStackCount = math.floor(hp_diff/stack1)

    		self:SetStackCount( newStackCount )
			return newStackCount
		end
	else
		return self:GetStackCount() * self:GetAbility():GetLevelSpecialValueFor( "as_per_stack" , self:GetAbility():GetLevel() - 1 )
	end
end