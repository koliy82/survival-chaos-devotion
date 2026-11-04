function OnHeal( event )
	local caster = event.caster

	local spec_ability = caster:FindAbilityByName("primordials_creeps_melee_pass")

	if spec_ability and spec_ability:IsCooldownReady() then
		spec_ability:ApplyDataDrivenModifier(caster, caster, "modifier_primordials_creeps_melee_pass_buff", {})
		local level = spec_ability:GetLevel()
		
		local heal_radius = spec_ability:GetLevelSpecialValueFor("heal_radius", level -1)
		local heal = spec_ability:GetLevelSpecialValueFor("heal", level -1) * event.ability:GetLevelSpecialValueFor("heal", event.ability:GetLevel() -1) / 100
		local team = caster:GetTeamNumber()
		local position = caster:GetAbsOrigin()
		local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
		local targets =  FindUnitsInRadius(team, position, nil, heal_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
		
		if #targets > 0 then
			for _,unit in ipairs(targets) do
            	unit:Heal( heal, spec_ability )
        	end
		end

		spec_ability:StartCooldown(spec_ability:GetEffectiveCooldown(spec_ability:GetLevel()))
	end
end