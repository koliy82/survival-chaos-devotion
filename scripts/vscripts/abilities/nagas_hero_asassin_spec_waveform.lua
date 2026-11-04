function waveform( event )
	local caster = event.caster
	local ability = event.ability
	local casterLoc = caster:GetAbsOrigin()
	local wave_distance = ability:GetLevelSpecialValueFor( "wave_distance", ability:GetLevel() - 1 )
	local wave_width = ability:GetLevelSpecialValueFor( "wave_width", ability:GetLevel() - 1 )
	local projectile_speed = ability:GetLevelSpecialValueFor( "wave_speed", ability:GetLevel() - 1 )
	local wave_time = wave_distance/projectile_speed

	local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	local targets =  FindUnitsInRadius(caster:GetTeamNumber(), casterLoc, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
    if #targets > 0 then
		local direction = (targets[1]:GetOrigin()-casterLoc):Normalized()
	
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_nagas_hero_asassin_spec_waveform", {Duration = wave_time*2} )
	
		local projectileTable = {
			Ability = ability,
			EffectName = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf",
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
			local projectileTable = {
			Ability = ability,
			EffectName = "particles/units/heroes/hero_morphling/morphling_waveform.vpcf",
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
end

function HideCaster( event )
	event.caster:AddNoDraw()
end

function ShowCaster( event )
	event.caster:RemoveNoDraw()
end