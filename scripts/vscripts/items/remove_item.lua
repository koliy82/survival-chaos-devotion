function RemoveSelf(event)
    local caster = event.caster
    local item = event.ability
    caster:RemoveItem(item)
end