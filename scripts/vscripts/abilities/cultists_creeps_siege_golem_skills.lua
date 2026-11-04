function OnCreated(keys)
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel()

	local abilities = {
		"cultists_creeps_siege_golem_death",
		"cultists_creeps_siege_golem_buff",
		"cultists_creeps_siege_golem_armorred",
		"cultists_creeps_siege_golem_debuff"
	}

	for i = 1, level do
		caster:AddAbility(abilities[i]):SetLevel(1)
	end
	caster:RemoveAbility("cultists_creeps_siege_golem_skills")
end