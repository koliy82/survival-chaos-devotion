function OnAttackLanded(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local level = ability:GetLevel()
	local chance = ability:GetLevelSpecialValueFor( "chance", ( level - 1) )
    local bonus_ability = caster:FindAbilityByName("invaders_creeps_range_armor")
    if bonus_ability then
        chance = chance + bonus_ability:GetLevelSpecialValueFor( "bonus_chance", ( bonus_ability:GetLevel() - 1) )
    end

	if RollPercentage(chance) and target and target:IsAlive() and not target:IsCustomHero() and not target:IsAncient() then
		local damage = ability:GetLevelSpecialValueFor( "damage", ( level - 1) )
		ability:ApplyDataDrivenModifier(caster, target, "modifier_invaders_creeps_range_malefice", {})
		ApplyCustomDamage(target, caster, damage, 6, ability)
	end
end