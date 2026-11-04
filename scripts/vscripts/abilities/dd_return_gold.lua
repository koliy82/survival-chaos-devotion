function ReturnGold(event)
	-- [SCD-DIAG] телеметрия авторского возврата золота
	local ok, err = pcall(function()
		local id = event.caster:GetPlayerOwnerID()
		print("[SCD-DIAG] dd_return_gold: enter, ability=" .. event.ability:GetAbilityName() ..
			" caster=" .. event.caster:GetEntityIndex() .. " gold_before=" .. PlayerResource:GetGold(id))
		event.ability:ReturnGold()
		print("[SCD-DIAG] dd_return_gold: done, gold_after=" .. PlayerResource:GetGold(id))
	end)
	if not ok then
		print("[SCD-DIAG] dd_return_gold: ERROR " .. tostring(err))
	end
end