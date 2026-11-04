modifier_extra_health_bonus = class({})

function modifier_extra_health_bonus:IsHidden()
	return true
end

function modifier_extra_health_bonus:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
	}

	return funcs
end

function modifier_extra_health_bonus:GetModifierExtraHealthPercentage( params )
	return self:GetStackCount()
end