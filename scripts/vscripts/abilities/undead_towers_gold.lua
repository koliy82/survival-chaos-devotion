function OnKill(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	local gold = ability:GetLevelSpecialValueFor("gold", ability:GetLevel() -1)
	local id = caster:GetPlayerOwnerID()

	caster:EmitSound("General.Coins")
    PlayerResource:ModifyGold(id, gold, false, DOTA_ModifyGold_CreepKill)
end