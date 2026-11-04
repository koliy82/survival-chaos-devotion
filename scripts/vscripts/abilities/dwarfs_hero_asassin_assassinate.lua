function OnAttackStart(keys)
	local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel()
    if level > 0 and ability:IsCooldownReady() then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_dwarfs_hero_asassin_assassinate_critmod", {})
    end
end

function OnAttackLanded(keys)
	local caster = keys.caster
	local ability = keys.ability
	local cooldown = ability:GetEffectiveCooldown(ability:GetLevel())
	ability:StartCooldown(cooldown)
end