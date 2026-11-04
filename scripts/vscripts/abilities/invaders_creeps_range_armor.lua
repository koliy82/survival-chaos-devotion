function OnAttackLanded(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	local level = ability:GetLevel() - 1

	target:RemoveModifierByName("modifier_invaders_creeps_range_armor_debuff_slow")
	target:RemoveModifierByName("modifier_invaders_creeps_range_armor_debuff")

	if target:IsStunned() then
        ability:ApplyDataDrivenModifier(caster, target, "modifier_invaders_creeps_range_armor_debuff_slow", {})
	else
        ability:ApplyDataDrivenModifier(caster, target, "modifier_invaders_creeps_range_armor_debuff", {})
	end
end