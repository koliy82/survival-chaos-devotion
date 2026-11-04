function burrowstrike( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local casterLoc = caster:GetAbsOrigin()
	local wave_distance = ability:GetLevelSpecialValueFor( "tooltip_range", ability:GetLevel() - 1 )
	local wave_width = ability:GetLevelSpecialValueFor( "burrow_width", ability:GetLevel() - 1 )
	local projectile_speed = ability:GetLevelSpecialValueFor( "burrow_speed", ability:GetLevel() - 1 )
	local wave_time = wave_distance/projectile_speed
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_spiders_hero_tank_burrowstrike_caster", {Duration = wave_time*2} )
	
	local direction = (target:GetOrigin()-casterLoc):Normalized()

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_burrowstrike.vpcf", PATTACH_CUSTOMORIGIN, target)
	ParticleManager:SetParticleControl(particle, 0, casterLoc)
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())

	local projectileTable = {
		Ability = ability,
		EffectName = "",
		vSpawnOrigin = casterLoc,
		fDistance = wave_distance,
		fStartRadius = wave_width,
		fEndRadius = wave_width,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		bProvidesVision = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		vVelocity = direction * projectile_speed
		}
	ProjectileManager:CreateLinearProjectile( projectileTable )

	Timers:CreateTimer( wave_time, function()
		local particle1 = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_burrowstrike.vpcf", PATTACH_CUSTOMORIGIN, caster)
		ParticleManager:SetParticleControl(particle1, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(particle1, 1, casterLoc)

		local projectileTable = {
		Ability = ability,
		EffectName = "",
		vSpawnOrigin = casterLoc + (wave_distance *  direction),
		fDistance = wave_distance,
		fStartRadius = wave_width,
		fEndRadius = wave_width,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		bProvidesVision = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		vVelocity = -(direction) * projectile_speed
		}
		ProjectileManager:CreateLinearProjectile( projectileTable )
	end)
end

function HideCaster( event )
	event.caster:AddNoDraw()
end

function ShowCaster( event )
	event.caster:RemoveNoDraw()
end