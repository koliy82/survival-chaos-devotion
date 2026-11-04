function OnSpellStart(keys)
	local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel()

    local duration = keys.duration

    for i = 1, duration do
		Timers:CreateTimer( (i-1), function()
            caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_2, duration)
			local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	        local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	        local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

            local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1  )
            local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1  )

            local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
	        for _,unit in ipairs(units) do
                ApplyCustomDamage(unit, caster, damage, 6)
            end
        
            local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_primal_beast/primal_beast_trample.vpcf", PATTACH_WORLDORIGIN, caster)
            ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
            ParticleManager:SetParticleControl(particle, 1, Vector( radius, radius, radius))
        
            StartSoundEvent("Hero_PrimalBeast.Trample", caster)
		end)
	end    
end