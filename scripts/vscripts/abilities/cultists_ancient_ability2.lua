function OnKill(event)
    local caster = event.caster
    local ability = event.ability
	local mana = ability:GetLevelSpecialValueFor("mana", ability:GetLevel() - 1)
    
    caster:GiveMana(mana)
end