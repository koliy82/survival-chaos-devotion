function OnAttacked(keys)
	local caster = keys.caster
    local ability = keys.ability
    local attacker = keys.attacker

    local damage = ability:GetLevelSpecialValueFor( "damage" , ability:GetLevel() - 1  )
    local damage_taken = keys.DamageTaken

    local particle_cast = "particles/units/heroes/hero_dark_seer/dark_seer_ion_shell_damage.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, attacker )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0),
		true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		attacker,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0),
		true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

    ApplyCustomDamage(attacker, caster, damage_taken * damage / 100, 6)
end