function OnAttacked(keys)
	local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel()
    if level > 0 and ability:IsCooldownReady() then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_frostivus_creeps_melee_warcry_buff", {})

        local cooldown = ability:GetEffectiveCooldown(level)
	    ability:StartCooldown(cooldown)
    end
end