function OnSuccess(keys)
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel()
	if level <= 0 then return end
	local cooldown = ability:GetLevelSpecialValueFor( "duration", ( level - 1) )
    local chance = ability:GetLevelSpecialValueFor( "chance", ( level - 1) )
    local mod = caster:FindModifierByName("modifier_nagas_hero_asassin_shadow_dance")
    if mod then
        chance = chance * mod:GetAbility():GetLevelSpecialValueFor( "depth_mark_chance_mul", ( level - 1) )
    end
	local point = caster:GetAbsOrigin()
    local rand = math.random(1,100)
    
	if ability:IsCooldownReady() and rand < chance then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_nagas_hero_asassin_depth_mark_buff", {})
		local fxIndex = ParticleManager:CreateParticle( "particles/econ/items/ogre_magi/ogre_ti8_immortal_weapon/ogre_ti8_immortal_bloodlust_overhead_goblin.vpcf", PATTACH_OVERHEAD_FOLLOW, caster )
		ParticleManager:SetParticleControlEnt( fxIndex, 1, caster, PATTACH_POINT_FOLLOW, 'attach_hitloc', point, true )
		ability:StartCooldown(ability:GetEffectiveCooldown(level))
	end
end