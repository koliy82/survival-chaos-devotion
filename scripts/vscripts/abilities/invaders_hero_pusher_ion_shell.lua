function IonShell( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	-- Ability variables
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level) 
	local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
	local ion_particle = keys.ion_particle

	-- Targeting variables
	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

	-- Find all the valid units in radius
	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster_location, nil, radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)

	for _,unit in ipairs(units) do

		local effect_cast = ParticleManager:CreateParticle( ion_particle, PATTACH_POINT_FOLLOW, unit )
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
			unit,
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			Vector(0,0,0),
			true
		)
		ParticleManager:ReleaseParticleIndex( effect_cast )

        ApplyCustomDamage(unit, caster, damage, 6, nil)
	end
end