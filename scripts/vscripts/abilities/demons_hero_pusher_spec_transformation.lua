function OnTakeDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
    local HP_now = caster:GetHealth()
    local HP_max = caster:GetMaxHealth()
    local casterHP = caster:GetHealth()
    local level = ability:GetLevel()

	local health_limit = ability:GetLevelSpecialValueFor( "health", level - 1 ) / 100
	
	if level > 0 and HP_now <= HP_max * health_limit and ability:IsActivated() then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_demons_hero_pusher_spec_transformation", {} )
		caster:RemoveModifierByName("modifier_demons_hero_pusher_spec_transformation_check")
		caster:RemoveAbility("demons_hero_pusher_spec_transformation")
		caster:AddAbility("demons_hero_pusher_spec_upheaval"):SetLevel(level)
	end
end