function OnProjectileHitUnit( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	local damage = keys.damage
	local heal = keys.heal

	local caster_team = caster:GetTeamNumber()

	if target:GetTeamNumber() ~= caster_team then
		if target:FindModifierByName("modifier_dragons_creeps_range_fire_attack_debuff") then
			ApplyCustomDamage(target, caster, damage * 2, 6, ability)
		else
			ApplyCustomDamage(target, caster, damage, 6, ability)
		end
	else
		target:Heal(heal, caster)
	end
end