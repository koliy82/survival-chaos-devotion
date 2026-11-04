function AddResist( keys )
    local target = keys.target
    local damage_type = keys.damage_type
    local resist = keys.resist
    if target.custom_damage_reduction then
        target.custom_damage_reduction[damage_type] = target.custom_damage_reduction[damage_type] - resist / 100
    end
end

function RemoveResist( keys )
    local target = keys.target
    local damage_type = keys.damage_type
    local resist = keys.resist
    if target.custom_damage_reduction then
        target.custom_damage_reduction[damage_type] = target.custom_damage_reduction[damage_type] + resist / 100
    end
end