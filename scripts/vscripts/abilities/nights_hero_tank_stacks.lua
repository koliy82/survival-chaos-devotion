function OnKill(keys)
	local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel()
	if level > 0 and ability:IsCooldownReady() then
		ability:StartCooldown(ability:GetEffectiveCooldown(level))
        ability:ApplyDataDrivenModifier(caster, caster, keys.modifier, {Duration = keys.duration})
    end
end