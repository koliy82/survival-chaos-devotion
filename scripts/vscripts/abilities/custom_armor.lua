function OnCreated(event)
    local caster = event.caster
    caster.custom_armor_type = tonumber(event.type)
    caster.custom_block = {}
    caster.custom_block[0] = 0
    caster.custom_block[1] = 0
    caster.custom_block[2] = 0
    caster.custom_block[3] = 0
    caster.custom_block[4] = 0
    caster.custom_block[5] = 0
    caster.custom_block[6] = 0
    caster.custom_block[7] = 0
    caster.custom_damage_reduction = {}
    caster.custom_damage_reduction[0] = 1
    caster.custom_damage_reduction[1] = 1
    caster.custom_damage_reduction[2] = 1
    caster.custom_damage_reduction[3] = 1
    caster.custom_damage_reduction[4] = 1
    caster.custom_damage_reduction[5] = 1
    caster.custom_damage_reduction[6] = 1
    caster.custom_damage_reduction[7] = 1
end