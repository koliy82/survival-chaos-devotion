function OnCreated( keys )
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel()
    local vCaster = caster:GetAbsOrigin()

	local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1  )
	local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1  )
	local stun_duration = ability:GetLevelSpecialValueFor( "pull_duration" , level - 1  )

	if not GameRules:IsDaytime() then
		damage = damage + ability:GetLevelSpecialValueFor( "night_damage" , level - 1  )
		radius = radius + ability:GetLevelSpecialValueFor( "night_radius" , level - 1  )
		stun_duration = stun_duration + ability:GetLevelSpecialValueFor( "night_stun" , level - 1  )
	end

	local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_reverse_polarity.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ))
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( 1, 0, 0 ))
	ParticleManager:SetParticleControl( effect_cast, 60, Vector( 0, 0, 255 ))
	ParticleManager:SetParticleControl( effect_cast, 61, Vector( 1, 0, 0 ))
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		caster,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0),
		true
	)
	ParticleManager:SetParticleControlForward( effect_cast, 3, caster:GetForwardVector() )

	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
												caster:GetAbsOrigin(),
												nil,
												radius,
												DOTA_UNIT_TARGET_TEAM_ENEMY,
												DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
												DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
												FIND_ANY_ORDER,
												false)

	for k, target in pairs(targets) do
		local vTarget = target:GetAbsOrigin()
	
		local len = -(math.abs( ( vTarget - vCaster ):Length2D() ) * 0.9 )
	
		local knockbackModifierTable =
		{
			should_stun = 1,
			knockback_duration = 0.2,
			duration = stun_duration,
			knockback_distance = len,
			knockback_height = 0,
			center_x = vCaster.x,
			center_y = vCaster.y,
			center_z = vCaster.z
		}
		target:AddNewModifier( caster, nil, "modifier_knockback", knockbackModifierTable )
		ApplyCustomDamage(target, caster, damage, 6, ability)
	end
end