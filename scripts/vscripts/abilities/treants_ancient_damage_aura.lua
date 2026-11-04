function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    local modifier_name = event.modifier_name
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        ability:ApplyDataDrivenModifier(caster, v, modifier_name, {})
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        ability:ApplyDataDrivenModifier(caster, v, modifier_name, {})
    end
end

function OnDestroy(event)
    local caster = event.caster
    local ability = event.ability
    local modifier_name = event.modifier_name
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:RemoveModifierByName(modifier_name)
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveModifierByName(modifier_name)
    end
end