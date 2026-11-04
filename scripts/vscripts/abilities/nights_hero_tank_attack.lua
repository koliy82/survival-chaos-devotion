function OnAttackStart(keys)
	local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel()
    if level > 0 and ability:IsCooldownReady() then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_nights_hero_tank_attack_caster", {})
    end
end

function OnAttackLanded(keys)
	local caster = keys.caster
	local ability = keys.ability
	local cooldown = ability:GetEffectiveCooldown(ability:GetLevel())
	ability:StartCooldown(cooldown)
    caster:SpendMana(ability:GetManaCost(ability:GetLevel() - 1), ability)
end