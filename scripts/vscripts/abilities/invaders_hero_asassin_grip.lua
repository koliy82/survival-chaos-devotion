function OnIntervalThink( event )
	local target = event.target
	local manaBurn = event.mana_red

	if target and target:IsAlive() then
		--target:ReduceMana(target:GetMaxMana() * manaBurn / 100)
		local total_mana_burn = target:GetMaxMana() * manaBurn / 100
		local target_mana = target:GetMana()
		if target_mana <= total_mana_burn then
			target:SetMana(0)
		else
			target:SpendMana(total_mana_burn, event.ability)
		end
	end
end