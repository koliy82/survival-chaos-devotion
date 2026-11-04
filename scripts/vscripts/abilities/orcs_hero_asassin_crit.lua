function OnAttackLanded(event)
    local caster = event.caster
    local ability = event.ability
    local max_stacks = ability:GetSpecialValueFor("max_stacks")
    local duration = ability:GetSpecialValueFor("duration")

    local mod = caster:FindModifierByName("modifier_orcs_hero_asassin_crit_buff")
    if mod then
        local stacks = mod:GetStackCount()
        if stacks < max_stacks then
            mod:SetStackCount(stacks + 1)
        end
        mod:SetDuration(duration, true)
    else
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_orcs_hero_asassin_crit_buff", {duration = duration})
    end
end