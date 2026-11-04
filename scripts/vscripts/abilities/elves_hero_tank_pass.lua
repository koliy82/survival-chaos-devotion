function OnSuccess(keys)
	local caster = keys.caster
	local ability = keys.ability
	local cooldown = ability:GetEffectiveCooldown(ability:GetLevel())
	ability:StartCooldown(cooldown)
	caster:RemoveModifierByName("mod_elves_hero_tank_pass")
    Timers:CreateTimer(cooldown,function()
    	ability:ApplyDataDrivenModifier(caster, caster, "mod_elves_hero_tank_pass", {})
    end)
end