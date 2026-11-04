LinkLuaModifier( "modifier_beastmen_creeps_melee_berserk_pass" , "abilities/beastmen_creeps_melee_berserk_pass.lua" , LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------

function ApplyLuaModifier( keys )
    local caster = keys.caster
    local ability = keys.ability
    local modifiername = keys.ModifierName

    caster:AddNewModifier(caster, ability, modifiername, {})
end

----------------------------------------------------------------------------------

beastmen_creeps_melee_berserk_pass = class ({})

--------------------------------------------------------------------------------

function beastmen_creeps_melee_berserk_pass:GetIntrinsicModifierName()
	return "modifier_beastmen_creeps_melee_berserk_pass"
end

----------------------------------------------------------------------------------

if modifier_beastmen_creeps_melee_berserk_pass == nil then
    modifier_beastmen_creeps_melee_berserk_pass = class({})
end

function modifier_beastmen_creeps_melee_berserk_pass:OnCreated( params )
	
	if IsServer() then
        self:SetStackCount( 0 )
    end
end

function modifier_beastmen_creeps_melee_berserk_pass:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT
	}

	return funcs
end

function modifier_beastmen_creeps_melee_berserk_pass:GetModifierPreAttack_BonusDamage( params )
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
		return self:GetStackCount() * self:GetAbility():GetLevelSpecialValueFor( "damage_per_stack" , self:GetAbility():GetLevel() - 1 )
	end
end

function modifier_beastmen_creeps_melee_berserk_pass:GetModifierConstantHealthRegen( params )
	if self:GetAbility():GetLevel() > 0 then
		return self:GetAbility():GetLevelSpecialValueFor( "hp_regen" , self:GetAbility():GetLevel() - 1 ) + self:GetStackCount() * self:GetAbility():GetLevelSpecialValueFor( "hp_regen_per_stack" , self:GetAbility():GetLevel() - 1 )
	end
end