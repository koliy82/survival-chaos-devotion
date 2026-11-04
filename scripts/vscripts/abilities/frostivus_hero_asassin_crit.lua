function OnAttackStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local chance = ability:GetLevelSpecialValueFor( "crit_chance", ( ability:GetLevel() - 1) )
    local mod = caster:FindModifierByName("modifier_frostivus_hero_asassin_invisible_buff")
    if mod then
        chance = chance * 1.5
    end
	local rand = math.random(1,100)
	if rand <= chance then
		local target = keys.target
		local point = target:GetAbsOrigin()
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_frostivus_hero_asassin_crit_critmod", {})

		local fxIndex = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_crit_tgt.vpcf", PATTACH_POINT, caster )
		ParticleManager:SetParticleControl( fxIndex, 0, point )
		ParticleManager:SetParticleControl( fxIndex, 1,  point )

		local fxIndex2 = ParticleManager:CreateParticle( "particles/econ/items/ogre_magi/ogre_magi_arcana/ogre_magi_arcana_secondstyle_fireblast.vpcf", PATTACH_POINT, caster )
		ParticleManager:SetParticleControl( fxIndex2, 0, point )
		ParticleManager:SetParticleControl( fxIndex2, 1,  point )

		local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	    local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	    local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

        local radius = ability:GetLevelSpecialValueFor( "explosion_radius" , ability:GetLevel() - 1  )
        local damage = ability:GetLevelSpecialValueFor( "explosion_damage" , ability:GetLevel() - 1  )

        local units = FindUnitsInRadius(caster:GetTeamNumber(), point, nil, radius, target_teams, target_types, target_flags, 0, false)
	    for _,unit in ipairs(units) do
			ability:ApplyDataDrivenModifier(caster, unit, "modifier_frostivus_hero_asassin_crit_debuff", {})
            ApplyCustomDamage(unit, caster, damage, 6)
        end
	end
end