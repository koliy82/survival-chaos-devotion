function OnSpellStart( event )
	local caster = event.caster
    local ability = event.ability
    local point = ability:GetCursorPosition()
    ability.point = point
end

function OnIntervalThink( event )
	local caster = event.caster
    local ability = event.ability
    local point = ability.point
    local caster_location = caster:GetAbsOrigin()
    local dif = point - caster_location
    local range = dif:Length2D()
	local forwardVec = dif:Normalized()
	local speed = ability:GetLevelSpecialValueFor("speed", (ability:GetLevel() - 1))

	local projectileTable =
	{
		EffectName = "particles/econ/items/tiny/tiny_frozen_stonehenge/tiny_stonehenge_tree_linear_proj.vpcf",
		Ability = ability,
		vSpawnOrigin = caster_location,
		vVelocity = Vector( forwardVec.x * speed, forwardVec.y * speed, 0 ),
		fDistance = range,
		fStartRadius = 0,
		fEndRadius = 0,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false
	}
	ProjectileManager:CreateLinearProjectile( projectileTable )
end