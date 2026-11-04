LinkLuaModifier( "modifier_beastmen_creeps_arme_manatohp" , "abilities/beastmen_creeps_arme_manatohp.lua" , LUA_MODIFIER_MOTION_NONE )

----------------------------------------------------------------------------------

function ApplyLuaModifier( keys )
    local caster = keys.caster
    local ability = keys.ability
    local modifiername = keys.ModifierName

    caster:AddNewModifier(caster, ability, modifiername, {})
end

----------------------------------------------------------------------------------

beastmen_creeps_arme_manatohp = class ({})

--------------------------------------------------------------------------------

function beastmen_creeps_arme_manatohp:GetIntrinsicModifierName()
	return "modifier_beastmen_creeps_arme_manatohp"
end

----------------------------------------------------------------------------------

if modifier_beastmen_creeps_arme_manatohp == nil then
    modifier_beastmen_creeps_arme_manatohp = class({})
end

function modifier_beastmen_creeps_arme_manatohp:OnCreated( params )
	
	if IsServer() then
        self:SetStackCount( 0 )
    end
end

function modifier_beastmen_creeps_arme_manatohp:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_beastmen_creeps_arme_manatohp:GetModifierConstantHealthRegen( params )
	if IsServer() then
		if self:GetAbility():GetLevel() > 0 then
			local caster = self:GetParent()
			local mp_now = caster:GetMana()
			local mp_ceiling = caster:GetMaxMana()
			local stack1 = self:GetAbility():GetLevelSpecialValueFor( "stack" , self:GetAbility():GetLevel() - 1 )
			local mp_diff = mp_ceiling - mp_now

	    	local newStackCount = math.floor(mp_diff/stack1)

    		self:SetStackCount( newStackCount )
			return newStackCount
		end
	else
		return self:GetStackCount() * self:GetAbility():GetLevelSpecialValueFor( "hp_regen_per_stack" , self:GetAbility():GetLevel() - 1 )
	end
end