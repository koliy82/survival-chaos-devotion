function OnAttackLanded(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	
	if target:FindModifierByName("modifier_dwarfs_creeps_arme_acid_spray") then
		local add_damage = ability:GetLevelSpecialValueFor( "add_damage", ( ability:GetLevel() - 1) )
		ApplyCustomDamage(target, caster, caster:GetAttackDamage() * add_damage / 100, 5, ability)
	end

end