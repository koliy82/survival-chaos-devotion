function OnCreated(event)
    local caster = event.caster
    caster.custom_damage_armor_multiplier[0] = 0
end

function OnDestroy(event)
    local caster = event.caster
    caster.custom_damage_armor_multiplier[0] = 1
end

function OnAttackLanded(event)
    local caster = event.caster
    local target = event.target

    local damageTable = {
        victim = target,
        attacker = caster,
        damage = caster:GetAttackDamage(),
        damage_type = DAMAGE_TYPE_PURE
    }
    ApplyDamage(damageTable)
end