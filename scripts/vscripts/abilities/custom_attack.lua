--[[
    "RunScript"
    {
        "Target"		"TARGET"
        "ScriptFile"		"abilities/custom_attack.lua"
        "Function"		"ApplyDamage"
        "damage"        "100"
        "type"          "1"

        //Damage Types
        //Normal = 1
        //Pierce = 2
        //Siege = 3
        //Magic = 4
        //Chaos = 5
        //Spells = 6
        //Hero = 7
    }
]]

function OnCreated(event)
    local caster = event.caster
    caster.custom_damage_type = tonumber(event.type)
    caster.custom_damage_armor_multiplier = {}
    caster.custom_damage_armor_multiplier[0] = 1
    caster.custom_damage_armor_multiplier[1] = 1
    caster.custom_damage_armor_multiplier[2] = 1
    caster.custom_damage_armor_multiplier[3] = 1
    caster.custom_damage_armor_multiplier[4] = 1
    caster.custom_damage_armor_multiplier[5] = 1
    caster.custom_damage_armor_multiplier[6] = 1
    caster.custom_damage_attack_multiplier = {}
    caster.custom_damage_attack_multiplier[0] = 1
    caster.custom_damage_attack_multiplier[1] = 1
    caster.custom_damage_attack_multiplier[2] = 1
    caster.custom_damage_attack_multiplier[3] = 1
    caster.custom_damage_attack_multiplier[4] = 1
    caster.custom_damage_attack_multiplier[5] = 1
    caster.custom_damage_attack_multiplier[6] = 1
    caster.custom_damage_attack_multiplier[7] = 1
end

function ApplyDamage(event)
    local caster = event.caster
    local target = event.target
    local damage = tonumber(event.damage)
    if event.percentage_on_buildings and target:IsAncient() then
        damage = damage * tonumber(event.percentage_on_buildings) / 100
    end
    ApplyCustomDamage(target, caster, damage, tonumber(event.type))
end