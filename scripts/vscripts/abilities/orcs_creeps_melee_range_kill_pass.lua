function OnEnemyDeath(keys)
	local caster = keys.caster
    local ability = keys.ability
    if not ability then return end
    local level = ability:GetLevel()
    if level > 0 and ability:IsCooldownReady() then
        ability:ApplyDataDrivenModifier(caster, caster, "modifiers_orcs_creeps_melee_range_kill_pass_buff", {})
        caster:Heal( keys.heal, ability )
        local cooldown = ability:GetEffectiveCooldown(level)
	    ability:StartCooldown(cooldown)
    end
end