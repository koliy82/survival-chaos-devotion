function OnCreated( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability

    if target == caster then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_nagas_hero_tank_spawning_pond_buff", {})
    end
end

function OnDestroy( keys )
    local target = keys.target

    target:RemoveModifierByName("modifier_nagas_hero_tank_spawning_pond_buff")
end