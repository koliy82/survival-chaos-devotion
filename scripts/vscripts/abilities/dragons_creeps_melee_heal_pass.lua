function OnEnemyDeath(keys)
	local caster = keys.caster
    local ability = keys.ability
    if not ability then return end
    local level = ability:GetLevel()
    local heal = ability:GetLevelSpecialValueFor( "heal", ability:GetLevel() - 1 )
    if level > 0 and ability:IsCooldownReady() and caster:GetMaxHealth() - heal > caster:GetHealth() then
        caster:Heal( heal, ability )
        local cooldown = ability:GetEffectiveCooldown(level)
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_dragons_creeps_melee_heal_pass_stack", {})
	    ability:StartCooldown(cooldown)
    end
end