function OnSpellStart( event )
	local caster	= event.caster
	local ability	= event.ability
	local modifier_name	= event.modifier
	
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	
	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO

	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
	local unit_under_lasso
	
	for i,unit in ipairs(units) do
		if unit:HasFlyMovementCapability() and not unit:FindModifierByName(modifier_name) then
			ability:ApplyDataDrivenModifier( caster, unit, modifier_name, {})
			unit_under_lasso = unit
			break
		end
	end
	
	if unit_under_lasso then
		-- Create particle FX
		local particleName = "particles/units/heroes/hero_batrider/batrider_flaming_lasso.vpcf"
		local pfx = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true )
		ParticleManager:SetParticleControlEnt( pfx, 1, unit_under_lasso, PATTACH_POINT_FOLLOW, "attach_hitloc", unit_under_lasso:GetAbsOrigin(), true)

		Timers:CreateTimer( duration, function()
			ParticleManager:DestroyParticle( pfx, false )
		end)
	end
end