function OnCreated(keys)
    local caster = keys.caster
    local ability = keys.ability
    local id = caster:GetPlayerOwnerID()
    ability.level = _G.playersinfo[id].unitsinfo[caster:GetUnitName()].abilities["demons_heroes_soul_echo"]
end

function OnUpdate(keys)
    local ability = keys.ability
    if ability.level then ability:SetLevel(ability.level) end
end