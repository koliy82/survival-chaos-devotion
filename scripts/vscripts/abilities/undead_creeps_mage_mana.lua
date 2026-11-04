function OnEnemyDeath(keys)
	local caster = keys.caster
    local ability = keys.ability
    if not ability then return end
    local level = ability:GetLevel()
    if level > 0 and ability:IsCooldownReady() then
        local mana = ability:GetLevelSpecialValueFor("mana", level)
        caster:GiveMana(mana)
        local cooldown = ability:GetEffectiveCooldown(level)
	    ability:StartCooldown(cooldown)
    end
end