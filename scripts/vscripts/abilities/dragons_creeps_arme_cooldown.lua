function OnKill( keys )
	local caster = keys.caster
    local ability = keys.ability
    local mana = ability:GetLevelSpecialValueFor( "mana" , ability:GetLevel() - 1  )
    caster:GiveMana(mana)
end