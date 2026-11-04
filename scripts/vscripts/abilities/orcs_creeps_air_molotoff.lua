function ApplyDamage(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local damage = event.damage
    local damage_multiplier = event.damage_multiplier
    --local level = ability:GetLevel()
    local mod = target:FindModifierByName("modifier_orcs_creeps_air_stickynapalm")
    if mod then
        ApplyCustomDamage(target, caster, damage * damage_multiplier, 6, ability)
    else
        ApplyCustomDamage(target, caster, damage, 6, ability)
    end
end