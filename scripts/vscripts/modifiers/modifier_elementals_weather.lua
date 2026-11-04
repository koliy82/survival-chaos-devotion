modifier_elementals_weather = class({})

function modifier_elementals_weather:IsHidden()
    return true
end

function modifier_elementals_weather:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
end