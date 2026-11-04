function OnSuccess( event )
	local caster = event.caster
	local target = event.target

	local spec_ability = caster:FindAbilityByName("dragons_creeps_mage_fire_attack")

	if spec_ability and spec_ability:GetLevel() > 0 then
		spec_ability:ApplyDataDrivenModifier(caster, target, "modifier_dragons_creeps_mage_fire_attack_debuff", {})
	end
end