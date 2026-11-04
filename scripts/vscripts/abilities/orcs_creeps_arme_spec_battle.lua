function OnTakeDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
    local casterHP = caster:GetHealthPercent()
    local level = ability:GetLevel()
	local need_hp = ability:GetLevelSpecialValueFor( "health", level - 1 )
	
	if level > 0 and casterHP <= need_hp and not caster:HasModifier("modifier_orcs_creeps_arme_spec_battle_buff") then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_orcs_creeps_arme_spec_battle_buff", {} )
	end
end