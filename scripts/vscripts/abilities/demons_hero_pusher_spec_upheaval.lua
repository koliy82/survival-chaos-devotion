function OnCreated( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability

    if target == caster then
        ability:ApplyDataDrivenModifier(caster, target, "modifier_demons_hero_pusher_spec_upheaval_hero_buff", {})
    end

    ability:ApplyDataDrivenModifier(caster, target, "modifier_demons_hero_pusher_spec_upheaval_buff", {})
end

function OnDestroy( keys )
    local target = keys.target

    if target:HasModifier("modifier_demons_hero_pusher_spec_upheaval_hero_buff") then
        target:RemoveModifierByName("modifier_demons_hero_pusher_spec_upheaval_hero_buff")
    end

    target:RemoveModifierByName("modifier_demons_hero_pusher_spec_upheaval_buff")
end