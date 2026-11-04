function OnTakeDamage( event )
	local damage = event.DamageTaken
	local caster = event.caster
	local ability = event.ability
	local level = ability:GetLevel()
	if not caster.borrowed_heal then caster.borrowed_heal = 0 end
	local max_heal = ability:GetLevelSpecialValueFor( "max_heal" , level - 1  ) - caster.borrowed_heal
	local block_damage_prc = ability:GetLevelSpecialValueFor( "block_damage_prc" , level - 1  )

	local heal = damage * block_damage_prc / 50
	if heal > max_heal then
		heal = max_heal
		caster:RemoveModifierByName("modifier_primordials_hero_asassin_shield")
	end
	caster.borrowed_heal = caster.borrowed_heal + heal
	
	caster:Heal(heal, caster)
end