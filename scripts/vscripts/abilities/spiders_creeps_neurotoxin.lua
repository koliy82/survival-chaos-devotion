function OnAttackLanded(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local chance = ability:GetLevelSpecialValueFor( "root_chance", ( ability:GetLevel() - 1) )
    local abil = caster:FindAbilityByName("spiders_creeps_arme_roar")
    if abil then
        chance = chance + abil:GetLevelSpecialValueFor( "bonus_chance", ( abil:GetLevel() - 1) )
    end

	if RollPercentage(chance) then
		local damage = ability:GetLevelSpecialValueFor( "damage", ( ability:GetLevel() - 1) )
		if not target:IsCustomHero() then
			ability:ApplyDataDrivenModifier(caster, target, "modifier_spiders_creeps_neurotoxin_debuff", {})
		end
		ApplyCustomDamage(target, caster, damage, 6, ability)
	end
end