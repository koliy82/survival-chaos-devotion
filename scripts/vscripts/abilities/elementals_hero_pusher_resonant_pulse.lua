function OnSpellStart( event )
	local caster = event.caster
	local ability = event.ability
	-- Reset the shield
	if caster.custom_barrier then
		caster:AddBarrier(event.damage_absorb, 0, nil, caster, ability)
	end
end
