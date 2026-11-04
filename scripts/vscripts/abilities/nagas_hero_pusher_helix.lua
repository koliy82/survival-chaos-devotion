function CounterHelix( keys )
	local caster = keys.caster
	local ability = keys.ability
	local helix_modifier = keys.helix_modifier

	if ability:GetLevel() > 0 and ability:IsCooldownReady() then
		ability:ApplyDataDrivenModifier(caster, caster, helix_modifier, {})
		ability:StartCooldown(ability:GetEffectiveCooldown(ability:GetLevel()))
		caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
        ParticleManager:CreateParticle( "particles/units/heroes/hero_tidehunter/tidehunter_anchor_hero_swipe_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	end
end