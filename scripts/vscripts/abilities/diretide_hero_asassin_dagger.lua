function ApplyDamage ( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local damage = ability:GetLevelSpecialValueFor( "strike_damage", ability:GetLevel() - 1 )


	ApplyCustomDamage(target, caster, caster:GetAttackDamage() * damage*0.01, caster.custom_damage_type)

end