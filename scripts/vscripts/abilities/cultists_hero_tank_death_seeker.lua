function OnIntervalThink(keys)
	local caster = keys.caster
	local ability = keys.ability
    local level = ability:GetLevel()

	if level > 0 then
		local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
		local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

		local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1  )

		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)

		local mod = caster:FindModifierByName("modifier_cultists_hero_tank_death_seeker")

		if not mod then
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_cultists_hero_tank_death_seeker", {})
		else
			mod:SetStackCount(#units)
	
			if not ability.effect then
				ability.effect = ParticleManager:CreateParticle( "particles/units/heroes/hero_abaddon/abaddon_curse_counter_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, caster )
			end
			ParticleManager:SetParticleControl( ability.effect, 0, caster:GetAbsOrigin() )
			ParticleManager:SetParticleControl( ability.effect, 1, Vector(1, mod:GetStackCount(), 0) )
			ParticleManager:SetParticleControl( ability.effect, 3, caster:GetAbsOrigin() )
		end
	end
end