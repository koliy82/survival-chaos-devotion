function OnSpellStart( event )
	local caster	= event.caster
	local ability	= event.ability
	local modifier_name	= event.modifier
	
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	
	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO

	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
	local first_unit
	
	for i,unit in ipairs(units) do
		if unit:HasFlyMovementCapability() then
			ability:ApplyDataDrivenModifier( caster, unit, modifier_name, {})
			first_unit = unit
			break
		end
	end

	ProjectileManager:CreateTrackingProjectile( {
		Target = first_unit,
		Source = caster,
		Ability = ability,	
		EffectName = "particles/units/heroes/hero_windrunner/windrunner_shackleshot.vpcf",
        iMoveSpeed = 600,
		vSourceLoc= caster:GetAbsOrigin(),                -- Optional (HOW)
		bDrawsOnMinimap = false,                          -- Optional
        bDodgeable = false,                                -- Optional
        bIsAttack = false,                                -- Optional
        bVisibleToEnemies = true,                         -- Optional
        bReplaceExisting = false,                         -- Optional
        --flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
		bProvidesVision = true,                           -- Optional
		iVisionRadius = 400,                              -- Optional
		iVisionTeamNumber = caster:GetTeamNumber(),        -- Optional
	} )

	if first_unit then
		local second_units = FindUnitsInRadius(caster:GetTeamNumber(), first_unit:GetAbsOrigin(), nil, 500, target_teams, target_types, target_flags, 0, false)
		local second_unit
		
		for _,unit in ipairs(second_units) do
			if not unit:FindModifierByName(modifier_name) then
				ability:ApplyDataDrivenModifier( caster, unit, modifier_name, {})
				second_unit = unit
				break
			end
		end
	end
	
	if first_unit and second_unit then
		-- Create particle FX
		latch = ParticleManager:CreateParticle("particles/units/heroes/hero_windrunner/windrunner_shackleshot_pair.vpcf", PATTACH_CUSTOMORIGIN, caster)

		ParticleManager:SetParticleControlEnt(latch, 0, first_unit, PATTACH_POINT, "attach_hitloc", first_unit:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(latch, 1, second_unit, PATTACH_POINT, "attach_hitloc", second_unit:GetAbsOrigin(), true)
        ParticleManager:SetParticleControl(latch, 2, Vector(duration,0,0))

		ability:ApplyDataDrivenModifier(caster, first_unit, "modifier_shackle_stun_datadriven", {})
        ability:ApplyDataDrivenModifier(caster, second_unit, "modifier_shackle_stun_datadriven", {})

		EmitSoundOn("Hero_Windrunner.ShackleshotBind", first_unit)
	end
end