function OnSuccess(keys)
	local caster = keys.caster
	local ability = keys.ability
	local chance = ability:GetLevelSpecialValueFor( "chance", ( ability:GetLevel() - 1) )
    local mod = caster:FindModifierByName("modifier_nagas_hero_asassin_shadow_dance")
    if mod then
        chance = mod:GetAbility():GetLevelSpecialValueFor( "crit_hit_chance", ( ability:GetLevel() - 1) )
    end
	local point = caster:GetAbsOrigin()
	local rand = math.random(1,100)
	if rand < chance then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_nagas_hero_asassin_crit_critmod", {})
		local fxIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/skeleton_king_ti8_weapon_blur_critical_outertrail.vpcf", PATTACH_POINT, caster )
		ParticleManager:SetParticleControlEnt( fxIndex, 1, caster, PATTACH_POINT_FOLLOW, 'attach_hitloc', point, true )
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_nagas_hero_asassin_crit_hit", {})
	end
end