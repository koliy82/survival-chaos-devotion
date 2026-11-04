function OnSuccess(keys)
	local caster = keys.caster
	local ability = keys.ability
	local cooldown = ability:GetEffectiveCooldown(ability:GetLevel())
	ability:StartCooldown(cooldown)
	caster:RemoveModifierByName("modifier_dwarfs_hero_pusher_whirling_death_pass")
    Timers:CreateTimer(cooldown,function()
    	ability:ApplyDataDrivenModifier(caster, caster, "modifier_dwarfs_hero_pusher_whirling_death_pass", {})
    end)
end