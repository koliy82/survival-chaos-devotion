function OnProjectileHitUnit( event )
	local caster = event.caster
	local ability = event.ability
	local damage = event.damage
	local heal = event.heal
	local target = event.target
    
    if target:GetTeam() ~= caster:GetTeam() then
        ApplyCustomDamage(target, caster, damage, 6, ability)
	else
        target:Heal( heal, ability )
    end
end