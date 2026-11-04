function OnSpellStart(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel() - 1
    local speed = ability:GetLevelSpecialValueFor("speed", level)
	local duration = ability:GetLevelSpecialValueFor("duration", level)

	local vCaster = caster:GetAbsOrigin()
	local vTarget = target:GetAbsOrigin()
	local len = -(math.abs( ( vTarget - vCaster ):Length2D() ) / 2)
	local knockbackModifierTable =
	{
		should_stun = 1,
		knockback_duration = duration,
		duration = duration,
		knockback_distance = len,
		knockback_height = 0,
		center_x = vCaster.x,
		center_y = vCaster.y,
		center_z = vCaster.z
	}
	target:AddNewModifier( caster, nil, "modifier_knockback", knockbackModifierTable )
end