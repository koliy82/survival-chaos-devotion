function OnCreated(keys)
    local caster = keys.caster
    caster.custom_damage_reduction[6] = caster.custom_damage_reduction[6] - keys.spell_red/100
    caster.custom_damage_reduction[3] = caster.custom_damage_reduction[3] + keys.siege_mult/100
end