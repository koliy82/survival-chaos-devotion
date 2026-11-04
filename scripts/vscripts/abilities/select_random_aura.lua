function OnSpellStart(keys)
	local id = keys.caster:GetPlayerID()
	if not id then return end
	if _G.playersinfo[id].ancient and _G.playersinfo[id].ancient:GetLevel() > 1 then
		_G.playersinfo[id].ancient:RemoveAbility("ancient_select_aura")
		_G.playersinfo[id].ancient:RemoveAbility("ancient_select_random_aura")
		if _G.playersinfo[id].ancient:FindAbilityByName("ancient_select_aura") and _G.playersinfo[id].ancient:FindAbilityByName("ancient_select_random_aura") then
			local random = RollPercentage(3)
			_G.playersinfo[id].ancient:AddAbility(_G.playersinfo[id].raceinfo["auras"][tostring(random)]):SetLevel(1)
			_G.playersinfo[id].aura = _G.playersinfo[id].raceinfo["auras"][tostring(random)]
		end
	end
end