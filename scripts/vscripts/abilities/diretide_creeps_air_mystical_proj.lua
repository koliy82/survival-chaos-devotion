function OnSuccess( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target
	local particle_name = "particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf"

	if target:IsAncient() then return end

	local wave_speed = 800

	ProjectileManager:CreateTrackingProjectile( {
		Target = target,
		Source = caster,
		Ability = ability,	
		
		EffectName = particle_name,
		iMoveSpeed = wave_speed,
		bDodgeable = false,
	} )
end