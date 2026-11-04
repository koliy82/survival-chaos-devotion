function Start( event )
	local caster = event.caster
	local ability = event.ability
	local point = ability:GetCursorPosition()
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local heal = ability:GetLevelSpecialValueFor( "heal", ability:GetLevel() - 1 )
	
	local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local targetFlag = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	
	local particle = "particles/econ/items/undying/undying_pale_augur/undying_pale_augur_decay.vpcf"

	local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, point)
    ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, 0))

	local units = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, radius, targetTeam, targetType, targetFlag, FIND_ANY_ORDER, false )
	for k, v in pairs( units ) do
        if v:IsCustomHero() then
			caster:Heal( heal * 12, ability )
		else
			caster:Heal( heal, ability )
		end
        ApplyCustomDamage(v, caster, damage, 6, ability)
	end
end