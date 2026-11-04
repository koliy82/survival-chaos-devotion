modifier_heroes_phase = class({})

function modifier_heroes_phase:IsHidden()
    return true
end

function modifier_heroes_phase:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end