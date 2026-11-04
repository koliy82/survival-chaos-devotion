function AffectBuffes(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	if caster and target and target:GetTeamNumber() == caster:GetTeamNumber() then
		local buff_ability = caster:FindAbilityByName("cultists_hero_mage_buffes")
		local duration =  1
		buff_ability:ApplyDataDrivenModifier(caster, target, "modifier_cultists_hero_mage_buffes", { Duration = duration})
	end
end