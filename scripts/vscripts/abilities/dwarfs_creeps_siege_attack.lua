function OnAttackLanded( keys )
    local caster = keys.caster
    local target = keys.target

    if target:FindAbilityByName("fort_armor") then
        local ability = keys.ability
        ability:ApplyDataDrivenModifier(caster, target, "modifier_dwarfs_creeps_siege_attack_damage", {})
    end
end