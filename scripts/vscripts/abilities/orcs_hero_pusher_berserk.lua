function OnAttackLanded( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local level = ability:GetLevel()
    local bonus_damage_to_fort = ability:GetLevelSpecialValueFor( "bonus_damage_to_fort" , level - 1  )

    if target:FindAbilityByName("fort_armor") then
        ApplyCustomDamage(target, caster, bonus_damage_to_fort, caster.custom_damage_type, ability)
    end
end