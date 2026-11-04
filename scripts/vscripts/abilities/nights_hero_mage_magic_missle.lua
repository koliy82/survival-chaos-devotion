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

        local units = FindUnitsInLine( caster:GetTeamNumber(), caster:GetOrigin(), caster:GetOrigin() + wave_direction * wave_distance, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS)
        
        for _,unit in pairs(units) do
			local info = {
				Target = unit,
				Source = caster,
				Ability = ability,
				EffectName = "particles/econ/items/vengeful/vs_ti8_immortal_shoulder/vs_ti8_immortal_magic_missle.vpcf",
				iMoveSpeed = wave_speed,
				bDodgeable = false,
				}
			ProjectileManager:CreateTrackingProjectile(info)
        end
        
        local cooldown = ability:GetEffectiveCooldown(level + 1)
	    ability:StartCooldown(cooldown)
		caster:SpendMana(ability:GetManaCost(level), ability)
    end
end