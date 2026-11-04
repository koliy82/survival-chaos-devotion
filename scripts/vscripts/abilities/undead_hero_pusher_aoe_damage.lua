function ApplyDamage(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability

	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() -1)
	local building_damage = ability:GetLevelSpecialValueFor("building_damage", ability:GetLevel() -1)

    if target:IsAncient() then
        ApplyCustomDamage(target, caster, damage * building_damage / 100, 6, ability)
    else
        ApplyCustomDamage(target, caster, damage, 6, ability)
    end
end