function ActOnTargets(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	if target and (target:HasModifier("modifier_pirates_hero_tank_brew_debuff") or target:HasModifier("modifier_pirates_creeps_mage_spirt")) then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_pirates_hero_tank_bomb", {})
	end
end