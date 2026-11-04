function OnTakeDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
    local casterHP = caster:GetHealthPercent()
    local level = ability:GetLevel()
	local need_hp = ability:GetLevelSpecialValueFor( "health", level - 1 )
	
	if level > 0 and casterHP <= need_hp and not caster:HasModifier("modifier_cultists_creeps_arme_rage_buff_2") then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_cultists_creeps_arme_rage_buff", {} )
		need_hp = ability:GetLevelSpecialValueFor( "health_2", level - 1 )
		if casterHP <= need_hp then
			caster:RemoveModifierByName("modifier_cultists_creeps_arme_rage_buff")
			ability:ApplyDataDrivenModifier( caster, caster, "modifier_cultists_creeps_arme_rage_buff_2", {} )
		end
	end
end