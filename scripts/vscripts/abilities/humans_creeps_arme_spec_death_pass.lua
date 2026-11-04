function SetHealth( event )
	local target = event.target
	local ability = event.ability
    local health = ability:GetLevelSpecialValueFor( "health", ability:GetLevel() - 1 )/100
    target:SetHealth(target:GetMaxHealth()*health)
end