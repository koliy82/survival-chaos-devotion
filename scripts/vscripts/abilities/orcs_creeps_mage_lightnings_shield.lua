function CastShield( event )
	local caster = event.caster
    local ability = event.ability
    local target = event.target
    local level = ability:GetLevel() - 1

    if target:IsCustomHero() then
        ability:ApplyDataDrivenModifier(caster, target, "modifier_orcs_creeps_mage_lightnings_shield", {Duration = ability:GetLevelSpecialValueFor("duration_on_hero", level )})
    else
        ability:ApplyDataDrivenModifier(caster, target, "modifier_orcs_creeps_mage_lightnings_shield", {Duration = ability:GetLevelSpecialValueFor("duration", level )})
    end
end