function OnAttackLanded( event )
	local target = event.target
	local ability = event.ability
	local caster = event.caster

	local target_pos = target:GetAbsOrigin()

	local bonus_damage = event.bonus_damage

	local damage_for_mana = caster:GetManaPercent() / 2
	ApplyCustomDamage(target, caster, bonus_damage + damage_for_mana, 6)

	if ability and not target:IsAlive() then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_primordials_hero_mage_mana_attack_buff", {})
    	EmitSoundOnLocationWithCaster(target_pos, "Hero_Zuus.StaticField", caster)
	end
end