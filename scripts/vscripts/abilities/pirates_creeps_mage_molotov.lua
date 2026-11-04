function ActOnTargets(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability

    if target:HasModifier("modifier_pirates_creeps_mage_spirt") then
        local spec_ability = caster:FindAbilityByName("pirates_creeps_mage_spirt")
        if spec_ability then
            local level = spec_ability:GetLevel()
	        local damage = ability:GetLevelSpecialValueFor("add_damage", (level - 1))
            ApplyCustomDamage(target, caster, damage, 6, ability)
        end
    end
end