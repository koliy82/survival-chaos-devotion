function Explode( events )
	local caster = events.caster
    local target = events.target
    local ability = events.ability

    local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
    local lines = 25

	local line_speed = 700
	local initial_angle_deg = caster:GetAnglesAsVector().y
	local delta_angle = 360/lines
	for i=0,lines-1 do
		local facing_angle_deg = initial_angle_deg + delta_angle * i
		if facing_angle_deg>360 then facing_angle_deg = facing_angle_deg - 360 end
		local facing_angle = math.rad(facing_angle_deg)
		local facing_vector = Vector( math.cos(facing_angle), math.sin(facing_angle), 0 ):Normalized()
		local velocity = facing_vector * line_speed

		ProjectileManager:CreateLinearProjectile( {
			Source = caster,
			Ability = ability,
			EffectName = "particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_line.vpcf",
			vSpawnOrigin = caster:GetAbsOrigin(),
			fDistance = radius,
			vVelocity = velocity,
			fStartRadius = 125,
			fEndRadius = 425,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			bReplaceExisting = false,
			bProvidesVision = false,
		} )

		local effect_line = ParticleManager:CreateParticle(
			"particles/units/heroes/hero_nevermore/nevermore_requiemofsouls_line.vpcf",
			PATTACH_ABSORIGIN,
			caster
		)
		ParticleManager:SetParticleControl(effect_line, 0, caster:GetAbsOrigin())
		ParticleManager:SetParticleControl(effect_line, 1, velocity)
		ParticleManager:SetParticleControl(effect_line, 2, Vector(0, radius / line_speed, 0))
		ParticleManager:ReleaseParticleIndex(effect_line)
	end

	local effect_cast = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_nevermore/nevermore_requiemofsouls.vpcf",
		PATTACH_ABSORIGIN_FOLLOW,
		caster
	)
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( lines, 0, 0 ) )
	ParticleManager:SetParticleControlForward( effect_cast, 2, caster:GetForwardVector() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn("Hero_Nevermore.RequiemOfSouls", caster)
end