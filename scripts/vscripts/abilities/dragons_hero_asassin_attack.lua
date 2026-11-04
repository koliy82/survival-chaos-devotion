function CheckChance(event)
	local caster = event.caster
	local ability = event.ability
	local crit_chance = ability:GetLevelSpecialValueFor( "crit_chance", ( ability:GetLevel() - 1) )
	local splash_chance = ability:GetLevelSpecialValueFor( "splash_chance", ( ability:GetLevel() - 1) )
	
	local rand = math.random(1,100)
	if rand <= crit_chance then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dragons_hero_asassin_attack_critmod", {})
	elseif rand <= splash_chance + crit_chance then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_dragons_hero_asassin_attack_splash", {})
	end
end

function OnAttackLandedActOnTargets( event )
	local caster = event.caster
    local ability = event.ability
    local target = event.target
    local damage = event.damage
	--if target:FindModifierByName("modifier_dragons_hero_asassin_attack_crit_armor") then
	--	target:RemoveModifierByName("modifier_dragons_hero_asassin_attack_crit_armor")
	--end
	--ability:ApplyDataDrivenModifier(caster, target, "modifier_dragons_hero_asassin_attack_splash_armor", {})
    ApplyCustomDamage(target, caster, damage, 6, ability)
end

function Reduce_Armor (event )
	local caster = event.caster
    local ability = event.ability
    local target = event.target

	local fxIndex = ParticleManager:CreateParticle( "particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_v2_crit_tgt.vpcf", PATTACH_POINT, caster )
	ParticleManager:SetParticleControl( fxIndex, 0, target:GetAbsOrigin() )
	ParticleManager:SetParticleControl( fxIndex, 1,  target:GetAbsOrigin() )

	--if target:FindModifierByName("modifier_dragons_hero_asassin_attack_splash_armor") then
	--	target:RemoveModifierByName("modifier_dragons_hero_asassin_attack_splash_armor")
	--end
	ability:ApplyDataDrivenModifier(caster, target, "modifier_dragons_hero_asassin_attack_crit_armor", {})
end