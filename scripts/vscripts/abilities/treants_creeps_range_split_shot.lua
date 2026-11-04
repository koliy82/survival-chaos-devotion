function SplitShotDamage( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local arrow_damage = ability:GetLevelSpecialValueFor("arrow_damage", ability_level)

	ApplyCustomDamage(target, caster, caster:GetAttackDamage() * arrow_damage / 100, caster.custom_damage_type, ability)
	
	local tower_ability = caster:FindAbilityByName("treants_creeps_range_roots")
	if tower_ability and tower_ability:GetLevel() > 0 and not target:IsCustomHero() then
		local chance = ability:GetLevelSpecialValueFor("chance", tower_ability:GetLevel() - 1)
		if RollPercentage(chance) then
			tower_ability:ApplyDataDrivenModifier(caster, target, "modifier_root_dd", {})
		end
	end
end