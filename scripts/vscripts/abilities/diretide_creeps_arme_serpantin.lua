function OnSpellStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target
	local particle_name = "particles/units/heroes/hero_broodmother/broodmother_scepter_sticky_snare.vpcf"

	local wave_direction = caster:GetForwardVector()
	local strike_damage = ability:GetLevelSpecialValueFor("strike_damage", ability_level)
	local wave_distance = ability:GetLevelSpecialValueFor("distance", ability_level)
	local radius = ability:GetLevelSpecialValueFor("radius", ability_level)

	local particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, caster)
    ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin() + caster:GetForwardVector() * wave_distance)

	units = FindUnitsInLine( caster:GetTeamNumber(), caster:GetOrigin(), caster:GetOrigin() + wave_direction * wave_distance, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS)
        
    for _,unit in pairs(units) do
    	ApplyCustomDamage(unit, caster, strike_damage, 6, ability)
    end

	Timers:CreateTimer( 1, function()
		ParticleManager:DestroyParticle(particle, false)
		end)
end