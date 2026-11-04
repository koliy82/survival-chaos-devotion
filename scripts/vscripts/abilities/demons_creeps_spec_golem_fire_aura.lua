function OnCreated(keys)
    local caster = keys.caster
    caster.custom_damage_armor_multiplier[4] = keys.damage/100
    caster.custom_damage_reduction[3] = caster.custom_damage_reduction[3] + keys.siege_mult/100
end