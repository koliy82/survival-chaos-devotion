function UseByHP(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
    local level = ability:GetLevel()
	local hp_cost = keys.hp

	local caster_hp
	if keys.creep then
		caster_hp = caster:GetHealth()
        if _G.playersinfo[caster:GetPlayerOwnerID()].spec:HasModifier("modifiers_cultists_spec_t1t2_pass") and caster:GetLevel() < 3 then
			hp_cost = hp_cost * 0.8
		end
	else
		caster_hp = caster:GetHealth()
	end
	
	if level > 0 and ability:IsCooldownReady() and not caster:IsSilenced() and not target:IsAncient() then
		ability:StartCooldown(ability:GetEffectiveCooldown(level))
		if hp_cost >= caster_hp then
			hp_cost = caster_hp - 1
		end
		local damageTable
		if keys.creep then
			damageTable = {
				victim = caster,
				attacker = caster,
				damage = hp_cost,
				damage_type = DAMAGE_TYPE_PURE
			}
		else
			damageTable = {
				victim = caster,
				attacker = caster,
				damage = hp_cost,
				damage_type = DAMAGE_TYPE_PURE
			}
		end
		ApplyDamage(damageTable)

		if keys.modifier then
			local goal = caster
			if keys.goal_is_target then
				goal = target
				if keys.random then
					local team = caster:GetTeamNumber()
            		local position = target:GetAbsOrigin()
            		local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            		local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            		local targets = FindUnitsInRadius(team, position, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
					
					goal = targets[1]
				end
			end
			if keys.create_thinker and goal and caster then
				local thinker = CreateModifierThinker( caster, ability, "", {Duration = keys.duration}, goal:GetAbsOrigin(), caster:GetTeamNumber(), false)
				ability:ApplyDataDrivenModifier(caster, thinker, keys.modifier, {Duration = keys.duration})
			else
				ability:ApplyDataDrivenModifier(caster, goal, keys.modifier, {Duration = keys.duration or 1})
			end
		end
	end
end