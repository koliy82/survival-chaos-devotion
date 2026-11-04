function OnIntervalThink( event )
	local caster = event.caster
	local ability = event.ability
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor( "radius", level )
	local damage = ability:GetLevelSpecialValueFor( "damage", level )
	local heal = ability:GetLevelSpecialValueFor( "heal", level )

	if caster:HasModifier("modifier_cultists_creeps_air_fly") then
		radius = radius + ability:GetLevelSpecialValueFor( "bonus_radius", level )
	end
	
	local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local targetFlag = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	
	local particle = "particles/units/heroes/hero_night_stalker/nightstalker_crippling_fear_aura.vpcf"

	local pfx = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pfx, 2, Vector(radius, radius, radius))

	Timers:CreateTimer( 1, function()
		ParticleManager:DestroyParticle(pfx, false)
	end)

	local units = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, targetTeam, targetType, targetFlag, FIND_ANY_ORDER, false )
	for _, v in pairs( units ) do
		caster:Heal( heal, ability )
        ApplyCustomDamage(v, caster, damage, 6, ability)
	end
end