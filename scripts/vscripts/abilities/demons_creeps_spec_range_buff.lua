function OnAttackLanded(keys)
	local caster = keys.caster
	local target = keys.target
    local ability = keys.ability
    local level = ability:GetLevel() - 1

    local wave_direction = caster:GetForwardVector()
	local damage = ability:GetLevelSpecialValueFor("damage", level) / 100
	local chance = ability:GetLevelSpecialValueFor("chance", level)
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local wave_distance = ability:GetLevelSpecialValueFor("distance", level)

    local targets = FindUnitsInLine( caster:GetTeamNumber(), target:GetOrigin() + wave_direction * radius, target:GetOrigin() + wave_direction * wave_distance, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS)
    local abil1 = caster:FindAbilityByName("demons_creeps_range_damage")
    for _,unit in pairs(targets) do
		if abil1 and abil1:GetLevel() > 0 and RollPercentage(chance) then
			local abil1_level = abil1:GetLevel()
			local duration = abil1:GetLevelSpecialValueFor( "duration" , abil1_level - 1  )
			local maxstacks = abil1:GetLevelSpecialValueFor( "max_stacks" , abil1_level - 1  )
			local mod = unit:FindModifierByName("modifier_demons_creeps_range_damage_slow")
			if mod then
				local stacks = mod:GetStackCount()
				if stacks < maxstacks then
					mod:SetStackCount(stacks+1)
				end
				mod:SetDuration(duration, true)
			else
				unit:AddNewModifier(caster, abil1, "modifier_demons_creeps_range_damage_slow", {duration = duration}):SetStackCount(1)
			end
		end
		ApplyCustomDamage(unit, caster, damage*caster:GetAttackDamage(), caster.custom_damage_type, ability)
    end
end