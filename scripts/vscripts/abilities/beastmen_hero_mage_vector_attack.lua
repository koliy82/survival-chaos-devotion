function OnAttackLanded(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
    local level = ability:GetLevel()

	if level > 0 and ability:IsCooldownReady() and caster:GetMana() >= ability:GetManaCost(level - 1) then
		ability:StartCooldown(ability:GetEffectiveCooldown(level))
		caster:SpendMana(ability:GetManaCost(level - 1), ability)

		caster:StartGesture(ACT_DOTA_CAST_ABILITY_1)

    	local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1 )
    	local distance = ability:GetLevelSpecialValueFor( "distance" , level - 1 )
    	local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1 )

		local dir = caster:GetForwardVector()

		local startPos = caster:GetAbsOrigin() + dir * 5 
		local endPos = startPos + (dir * distance)

    	EmitSoundOnLocationWithCaster(startPos, "Hero_Pangolier.Swashbuckle.Attack", caster)

		local particle_cast = "particles/units/heroes/hero_pangolier/pangolier_swashbuckler.vpcf"
		
		local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, caster )
		ParticleManager:SetParticleControlEnt(effect_cast, 0, caster, PATTACH_POINT_FOLLOW, 'attach_hitloc', caster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(effect_cast, 1, dir)
		ParticleManager:SetParticleControlEnt(effect_cast, 3, caster, PATTACH_POINT_FOLLOW, 'attach_hitloc', caster:GetAbsOrigin(), false)

		Timers:CreateTimer( 2, function()
			ParticleManager:DestroyParticle(effect_cast, false)
		end)

		local enemies = FindUnitsInLine(caster:GetTeam(), startPos, endPos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS)
    	for _,enemy in pairs(enemies) do
			ApplyCustomDamage(enemy, caster, damage, 6, ability)
    	end
	end
end