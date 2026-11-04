function start(keys)
	local caster = keys.caster
	local ability = keys.ability
	for i=0,23 do
		local ab = caster:GetAbilityByIndex(i)
		if ab and ab ~= ability then
			ab:EndCooldown()
		end
	end
end