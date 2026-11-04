function OnCreated(keys)
	local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    if caster:IsAncient() then 
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_undead_creeps_arme_poison_attack_racks", {})
    else
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_undead_creeps_arme_poison_attack", {})
    end
end