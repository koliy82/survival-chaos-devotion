function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()
    ability:ApplyDataDrivenModifier(caster, _G.playersinfo[id].ancient, "modifier_humans_ancient_buildings_damage_aura_buff", {})
    for k, v in pairs(_G.playersinfo[id].baracks) do
        ability:ApplyDataDrivenModifier(caster, v, "modifier_humans_ancient_buildings_damage_aura_buff", {})
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        ability:ApplyDataDrivenModifier(caster, v, "modifier_humans_ancient_buildings_damage_aura_buff", {})
        v.custom_damage_armor_multiplier[5] = v.custom_damage_armor_multiplier[5] + 0.75
    end
end

function OnDestroy(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()
    if _G.playersinfo[id].ancient then
        _G.playersinfo[id].ancient:RemoveModifierByName("modifier_humans_ancient_buildings_damage_aura_buff")
    end
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:RemoveModifierByName("modifier_humans_ancient_buildings_damage_aura_buff")
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveModifierByName("modifier_humans_ancient_buildings_damage_aura_buff")
    end
end