function OnDeath( event )
	local caster	= event.caster
	local ability	= event.ability
	local modifier_name	= event.modifier
	
	local radius = event.radius
	
	local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO

	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)

	for _,unit in ipairs(units) do
		if not unit:FindModifierByName(modifier_name) then
			ability:ApplyDataDrivenModifier( caster, unit, modifier_name, {})
			break
		end
	end
end

function Explosion( event )
	local caster	= event.unit
	local ability	= event.ability
	local radius  = event.radius
	local damage  = event.damage

	local pfx = ParticleManager:CreateParticle("particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest_radial_burst_blood.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT, "attach_hitloc", caster:GetAbsOrigin(), true)

	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
	
	for _, unit in pairs( units ) do
		ApplyCustomDamage(unit, caster, damage, 6, ability)
	end
end