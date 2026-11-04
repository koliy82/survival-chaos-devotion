function OnAttackLanded(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	local level = ability:GetLevel() - 1
	local damage = ability:GetLevelSpecialValueFor("damage", level)

	target:RemoveModifierByName("modifier_frostivus_creeps_melee_armor_debuff_slow")
	target:RemoveModifierByName("modifier_frostivus_creeps_melee_armor_debuff")

	if target:GetMoveSpeedModifier(target:GetBaseMoveSpeed(), false) < 345 then
        ApplyCustomDamage(target, caster, damage, 6, ability)
        ability:ApplyDataDrivenModifier(caster, target, "modifier_frostivus_creeps_melee_armor_debuff_slow", {})
	else
        ApplyCustomDamage(target, caster, keys.mass_damage, 6, ability)
        ability:ApplyDataDrivenModifier(caster, target, "modifier_frostivus_creeps_melee_armor_debuff", {})
	end
end

