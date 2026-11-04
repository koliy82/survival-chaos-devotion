function ActOnTargets(event)
    local ability = event.ability
    local level = ability:GetLevel()
    if level > 0 then
        local caster = event.caster
        local target = event.target
        if target:IsCustomHero() then
            ability:ApplyDataDrivenModifier(caster, target, "modifier_nagas_creeps_air_skin_debuff_hero", {})
        else
            ability:ApplyDataDrivenModifier(caster, target, "modifier_nagas_creeps_air_skin_debuff", {})
        end
    end
end