function OnAttacked(keys)
	local caster = keys.caster
    local ability = keys.ability
    local attacker = keys.attacker

    if attacker:IsAncient() then return end
    if not attacker.custom_armor_type then return end

    local damage_return = keys.damage_return
    local damage_taken = keys.DamageTaken

    ApplyCustomDamage(attacker, caster, damage_taken * damage_return / 100, 6, ability)
end