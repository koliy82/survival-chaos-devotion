function OnSuccess( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local modifier = keys.modifier

	if not target:IsAncient() then
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
	end
end