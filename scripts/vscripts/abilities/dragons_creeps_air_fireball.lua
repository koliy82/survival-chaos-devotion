function OnIntervalThink(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	if target:HasModifier("modifier_dragons_race_bonus_burning") then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_dragons_creeps_air_fireball_debuff_armor", {})
	end
end