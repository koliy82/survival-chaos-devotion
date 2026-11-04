function OnSuccess(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
    local level = ability:GetLevel()

    local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1 )

	ApplyCustomDamage(target, caster, damage, 6, ability)
end

function OnKill(keys)
	local caster = keys.caster
	local ability = keys.ability
    local level = ability:GetLevel()

    local gold = ability:GetLevelSpecialValueFor( "gold" , level - 1 )

	local id = caster:GetPlayerOwnerID()
	
	caster:EmitSound("General.Coins")
	PlayerResource:ModifyGold(id, gold, false, DOTA_ModifyGold_CreepKill)
end