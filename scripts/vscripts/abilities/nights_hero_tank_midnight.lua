function OnSpellStart(keys)
	local caster = keys.caster
    local ability = keys.ability
    
    local abil = caster:FindAbilityByName("nights_hero_tank_stacks")
    local level = abil:GetLevel()
    local duration = abil:GetLevelSpecialValueFor("duration", (level - 1))

    abil:ApplyDataDrivenModifier(caster, caster, keys.modifier, {Duration = duration})
end