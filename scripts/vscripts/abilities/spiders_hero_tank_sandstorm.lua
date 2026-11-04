function OnCreated( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability

    if target == caster then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_spiders_hero_tank_sandstorm_buff", {})
    end
end

function OnDestroy( keys )
    local target = keys.target

    target:RemoveModifierByName("modifier_spiders_hero_tank_sandstorm_buff")
end