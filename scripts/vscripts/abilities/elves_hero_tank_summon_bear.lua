function OnCreated(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()-1

    if level > 0 then
        target:CreatureLevelUp(level)
    end
end