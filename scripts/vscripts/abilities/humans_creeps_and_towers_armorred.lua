function OnAttackLanded(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    
    if ability:GetLevel() > 0 and target and target:IsAncient() then
        ability:ApplyDataDrivenModifier(caster, target, "modifier_humans_creeps_and_towers_armorred_debuff_build", {})
    else
        ability:ApplyDataDrivenModifier(caster, target, "modifier_humans_creeps_and_towers_armorred_debuff", {})
    end
end