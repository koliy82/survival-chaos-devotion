function MoveUnits( keys )
	local caster = keys.caster
	local target = keys.target
	local target_location = target:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	ability.point_entity = target
	
	local speed = ability:GetLevelSpecialValueFor("pull_speed", ability_level)/10
	local radius = ability:GetLevelSpecialValueFor("far_radius", ability_level)

	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS 

	local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, radius, target_teams, target_types, target_flags, 0, false)

	for i,unit in ipairs(units) do
		local unit_location = unit:GetAbsOrigin()
		local vector_distance = target_location - unit_location
		local distance = (vector_distance):Length2D()
		local direction = (vector_distance):Normalized()

		if distance >= 40 then
			unit:SetAbsOrigin(unit_location + direction * speed)
		else
			unit:SetAbsOrigin(unit_location + direction * distance)
		end
	end
end

function ChannelEnd(keys)
	local ability = keys.ability
	local caster = keys.caster
	
	if ability.point_entity:IsNull() == false then
		ability.point_entity:RemoveModifierByName("modifier_elementals_hero_mage_black_hole")
		StopSoundOn("survival_chaos.BlackHole", caster)
	end
end