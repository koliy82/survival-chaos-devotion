LinkLuaModifier( "modifier_orcs_hero_pusher_pass_buff", "abilities/orcs_hero_pusher_pass", LUA_MODIFIER_MOTION_NONE )

orcs_hero_pusher_pass = class ({})

--------------------------------------------------------------------------------

function orcs_hero_pusher_pass:GetIntrinsicModifierName()
	return "modifier_orcs_hero_pusher_pass_buff"
end

--------------------------------------------------------------------------------

modifier_orcs_hero_pusher_pass_buff = class({})

--------------------------------------------------------------------------------

function modifier_orcs_hero_pusher_pass_buff:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_orcs_hero_pusher_pass_buff:IsBuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_orcs_hero_pusher_pass_buff:OnCreated( kv )
	if IsServer() then
		local ability = self:GetAbility()
		self.regen = {
			ability:GetLevelSpecialValueFor( "regen" , 0  ),
			ability:GetLevelSpecialValueFor( "regen" , 1  ),
			ability:GetLevelSpecialValueFor( "regen" , 2  ),
			ability:GetLevelSpecialValueFor( "regen" , 3  )
		}
	end
end

--------------------------------------------------------------------------------

function modifier_orcs_hero_pusher_pass_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_orcs_hero_pusher_pass_buff:GetModifierConstantHealthRegen( params )
	if IsServer() then
		local ability = self:GetAbility()
		local level = ability:GetLevel()
		if level > 0 then
			self:SetStackCount((100 - self:GetParent():GetHealthPercent())/11*self.regen[level])
		end
	end
    return self:GetStackCount()
end