function OnCreated(event)
    local caster = event.caster
    local damage = event.damage

    caster.custom_damage_armor_multiplier[4] = damage/100
end