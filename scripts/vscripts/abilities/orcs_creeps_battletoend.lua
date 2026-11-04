function OnTakeDamage( keys )
    --DeepPrintTable(keys)
	local caster = keys.caster
	local ability = keys.ability
    local casterHP = caster:GetHealth()
	local casterMaxHp = caster:GetMaxHealth()
    --local level = ability:GetLevel()
	
	if casterHP <= 0 and ability:IsCooldownReady() then
		local chance = ability:GetLevelSpecialValueFor("chance", ability:GetLevel() - 1)
		if RandomInt( 1,100 ) <= chance then
			caster:SetHealth(casterMaxHp)
			ability:ApplyDataDrivenModifier( caster, caster, "modifier_orcs_creeps_battletoend_pass_newlife", {} )
			caster:RemoveModifierByName("modifier_orcs_creeps_battletoend_pass_check")
			caster:RemoveAbility("orcs_creeps_battletoend_pass")
			PlayerResource:ModifyGold(keys.attacker:GetPlayerOwnerID(), keys.gold, false, DOTA_ModifyGold_CreepKill)
		end
	end
end