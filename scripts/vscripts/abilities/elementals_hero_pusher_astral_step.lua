function OnSpellStart( keys )
	local caster 			= keys.caster
	local ability 			= keys.ability
	local particle_name 	= "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf"
	local particle_debuff_name 	= "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_debuff.vpcf"

	caster_location = caster:GetAbsOrigin()
	ability_level = ability:GetLevel()

	local radius 				= ability:GetLevelSpecialValueFor("radius", ability_level - 1)
	local travel_distance		= ability:GetLevelSpecialValueFor("travel_distance", ability_level - 1)
	local damage				= ability:GetLevelSpecialValueFor("damage", ability_level - 1)
	local delay 				= ability:GetLevelSpecialValueFor("delay", ability_level - 1)

	local target_point 			= caster_location + ( travel_distance * caster:GetForwardVector())
	
	particle = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, caster_location)
	ParticleManager:SetParticleControl(particle, 1, target_point)

	local units = FindUnitsInLine(caster:GetTeamNumber(), caster_location, target_point, caster, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS)

	ability.particles = {}
	
	for _, unit in ipairs(units) do
		local pfx = ParticleManager:CreateParticle(particle_debuff_name, PATTACH_ABSORIGIN_FOLLOW, unit )
		table.insert( ability.particles, pfx )
	end
	
	Timers:CreateTimer( 1.5, function()
		for i, unit in ipairs(units) do
			ParticleManager:DestroyParticle(ability.particles[i] , false)
			ability.particles[i] = nil
			
			ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_dmg_burst.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit )
			
			ApplyCustomDamage(unit, caster, damage, 6, ability)
		end
		
	end)
end