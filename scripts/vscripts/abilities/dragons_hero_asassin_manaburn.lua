function ManaBreak( event )
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local manaBurn = event.mana_per_hit
	local manaDamage = event.damage_per_burn

	if not target:IsMagicImmune() and not target:IsAncient() then
		local damage
		if(target:GetMana() >= manaBurn) then
			damage = manaBurn * manaDamage
    		target:SpendMana(manaBurn, ability)
		else
			damage = target:GetMana() * manaDamage
    		target:SetMana(0)
		end
		ApplyCustomDamage(target, caster, damage, 6, ability)
	end
end

function CheckBurning( event )
	local target = event.target
	local caster = event.caster
	local ability = event.ability

	if target:HasModifier("modifier_dragons_race_bonus_burning") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dragons_hero_asassin_manaburn_buff", {})
	end
end