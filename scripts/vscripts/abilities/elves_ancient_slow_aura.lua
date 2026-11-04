function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target
    if target:IsCustomHero() then
        ability:ApplyDataDrivenModifier(caster, target, "modifier_elves_ancient_slow_aura_buff", {})
    end
end