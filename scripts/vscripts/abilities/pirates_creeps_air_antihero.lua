function OnAttackLanded(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local level = ability:GetLevel() - 1
	local need_hp = ability:GetLevelSpecialValueFor( "need_hp", ( level ) )
	
	if target and not target:IsAncient() and target:GetHealth() >= need_hp then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_pirates_creeps_air_antihero_buff", {})
	end
end