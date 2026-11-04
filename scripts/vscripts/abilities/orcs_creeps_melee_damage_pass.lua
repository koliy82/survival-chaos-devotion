function OnEnemyDeath(keys)
	local caster = keys.caster
    local ability = keys.ability
    if not ability then return end
    local level = ability:GetLevel()
    if level > 0 and ability:IsCooldownReady() then
        ability:ApplyDataDrivenModifier(caster, caster, "orcs_creeps_melee_damage_pass_buff", {})
        local cooldown = ability:GetEffectiveCooldown(level)
	    ability:StartCooldown(cooldown)
    end
end