function OnCreated(event)
	local ability = event.ability
	if ability and ability:GetLevel() > 0 then
		local caster = event.caster
		caster.custom_damage_attack_multiplier[6] = 1 + event.bonus_damage_prc/100
	end
end