function OnCreated( event )
	local target = event.target
	local ability = event.ability
	local level = ability:GetLevel()
	
	local heal = ability:GetLevelSpecialValueFor("heal", level - 1)

	target:Heal( heal, ability )
end