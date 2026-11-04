function OnDestroy(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() -1))
	local exp_damage = ability:GetLevelSpecialValueFor("exp_damage", (ability:GetLevel() -1))
	local radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() -1))

	if target:IsAlive() and target:IsCustomHero() then 
		ApplyCustomDamage(target, caster, damage, 6, ability)
	else
		local position = target:GetAbsOrigin()
		target:ForceKill(false)

		local particle = ParticleManager:CreateParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf", PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(particle, 0, position)

		local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
		local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

		local units = FindUnitsInRadius(caster:GetTeamNumber(), position, nil, radius, target_teams, target_types, target_flags, 0, false)
	
		for _, unit in pairs( units ) do
			ApplyCustomDamage(unit, caster, exp_damage, 6, ability)
		end
	end
end