function OnProjectileHitUnit(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability

    if ability and ability:GetLevel() > 0 then
        local duration = event.duration
        if not target:HasModifier("modifier_nagas_creep_range_poison_sting_damage_and_debuff") then--modifier_elementals_air_buff
	        ability:ApplyDataDrivenModifier(caster, target, "modifier_nagas_creep_range_poison_sting_damage_and_debuff", {Duration = duration})
        else
	        ability:ApplyDataDrivenModifier(caster, target, "modifier_nagas_creep_range_poison_sting_damage_and_debuff", {Duration = duration})
        end
    end
end