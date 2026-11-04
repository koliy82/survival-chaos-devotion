modifier_custom_turbo_unit = class( {} )

function modifier_custom_turbo_unit:IsHidden()
	return true
end

-- function modifier_custom_turbo_unit:RemoveOnDeath()
--     return false
-- end

--------------------------------------------------------------------------------

function modifier_custom_turbo_unit:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_custom_turbo_unit:GetModifierMoveSpeedBonus_Percentage( params )
    return 30
end