function OnAttack(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
    local level = ability:GetLevel()
	local hp_cost = keys.hp

	local caster_hp = caster:GetHealth()

	if level > 0 and ability:IsCooldownReady() and caster_hp > hp_cost then
		local radius = ability:GetLevelSpecialValueFor("radius", level - 1 )
		local hp_need = ability:GetLevelSpecialValueFor("hp_need", level - 1 )
		local duration = ability:GetLevelSpecialValueFor("duration", level - 1 )

		local team = caster:GetTeamNumber()
		local position = target:GetAbsOrigin()
		local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
		local targets = FindUnitsInRadius(team, position, nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
		
		local weak_unit
		for _, unit in ipairs(targets) do
			if unit:GetHealthPercent() <= hp_need and not unit:IsCustomHero() then
				weak_unit = unit
				break
			end
		end

		if weak_unit then
			local heal = ability:GetLevelSpecialValueFor("heal", level - 1 )
			for _, unit in ipairs(targets) do
				unit:Heal( heal, ability )
				ability:ApplyDataDrivenModifier(caster, unit, "modifier_cultists_creeps_mage_denay", {Duration = duration})
			end
			ability:StartCooldown(ability:GetEffectiveCooldown(level))
			local damageTable = {
				victim = caster,
				attacker = caster,
				damage = hp_cost,
				damage_type = DAMAGE_TYPE_PURE
			}
			ApplyDamage(damageTable)
			weak_unit:Kill(ability, caster)
		end
	end
end