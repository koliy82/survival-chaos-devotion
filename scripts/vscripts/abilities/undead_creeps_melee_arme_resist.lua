function OnTakeDamage( event )
	local damage = event.DamageTaken
	local caster = event.caster
	local ability = event.ability
	local level = ability:GetLevel()
	local block_damage_prc = ability:GetLevelSpecialValueFor( "damage_absorb" , level - 1  )

	local heal = damage * block_damage_prc / 100
	
	caster:Heal(heal, caster)
end