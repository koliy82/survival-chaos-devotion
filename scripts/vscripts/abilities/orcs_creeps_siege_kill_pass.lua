function KillTarget(event)
    local target = event.target
    if target and not target:IsAncient() and not target:IsCustomHero() then target:Kill(event.ability, event.caster) end
end