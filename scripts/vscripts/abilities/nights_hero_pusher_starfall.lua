function OnAttackStart(keys)
	local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel() - 1
    if level + 1 > 0 and ability:IsCooldownReady() and caster:GetMana() >= ability:GetManaCost(level) then
        local wave_direction = caster:GetForwardVector()
	    local radius = ability:GetLevelSpecialValueFor("radius", level)
	    local wave_distance = ability:GetLevelSpecialValueFor("distance", level)
		local start_location = caster:GetOrigin()
		local end_location = start_location + wave_direction * wave_distance

	    local damage = ability:GetLevelSpecialValueFor("damage", level)
        
        for start = 0, wave_distance, 85 do
			local beam = ParticleManager:CreateParticle("particles/econ/items/mirana/mirana_starstorm_bow/mirana_starstorm_starfall_attack.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControl(beam, 0, start_location + wave_direction * start )
		end

		Timers:CreateTimer(0.5, function ()
			local units = FindUnitsInLine( caster:GetTeamNumber(), start_location, end_location, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS)
			for k, v in pairs(units) do
				ApplyCustomDamage(v, caster, damage, 6, ability)
				EmitSoundOn("Hero_Mirana.Starstorm.Impact", v)
			end
		end)
		local cooldown = ability:GetEffectiveCooldown(level + 1)
	    ability:StartCooldown(cooldown)
		caster:SpendMana(ability:GetManaCost(level), ability)
    end
end