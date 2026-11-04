function OnAttackStart(keys)
	local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel() - 1
    if level + 1 > 0 and ability:IsCooldownReady() and caster:GetMana() >= ability:GetManaCost(level) then
        local wave_direction = caster:GetForwardVector()
	    local wave_speed = ability:GetLevelSpecialValueFor("speed", level)
	    local radius = ability:GetLevelSpecialValueFor("radius", level)
	    local wave_distance = ability:GetLevelSpecialValueFor("distance", level)
	    local wave_location = caster:GetAbsOrigin() + (5 *  wave_direction)

        ProjectileManager:CreateLinearProjectile( {
			Ability				= ability,
			EffectName			= "particles/units/heroes/hero_vengeful/vengeful_wave_of_terror.vpcf",
			vSpawnOrigin		= wave_location,
			fDistance			= wave_distance,
			fStartRadius		= radius,
			fEndRadius			= radius,
			Source				= caster,
			bHasFrontalCone		= true,
			bReplaceExisting	= false,
			iUnitTargetTeam		= DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags	= DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			iUnitTargetType		= DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			bDeleteOnHit		= false,
			vVelocity			= wave_direction * wave_speed,
			bProvidesVision		= false,
		})

        local friends_units = FindUnitsInLine( caster:GetTeamNumber(), caster:GetOrigin(), caster:GetOrigin() + wave_direction * wave_distance, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS)
        
        for _,unit in pairs(friends_units) do
        	ability:ApplyDataDrivenModifier(caster, unit, "modifier_diretide_creeps_siege_terrorwave_buff", {})
        end
        
        local cooldown = ability:GetEffectiveCooldown(level + 1)
	    ability:StartCooldown(cooldown)
		caster:SpendMana(ability:GetManaCost(level), ability)
    end
end