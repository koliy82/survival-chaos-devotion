function OnSpellStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local duration = ability:GetLevelSpecialValueFor( "duration", ( ability:GetLevel() - 1) )
	local modifierName = "modifier_demons_hero_asassin_metamorfosis"
	local targetTeam = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local targetFlag = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	-- local fxIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_winter_wyvern/wyvern_arctic_burn_start.vpcf", PATTACH_POINT, target )

    ability:ApplyDataDrivenModifier(caster, caster, modifierName, {duration = duration})
end

function OnCreated(keys)
	local target = keys.target
    -- local ability = keys.ability
    
    target:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
    target:SetRangedProjectileName("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf")
end

function OnDestroy(keys)
	local target = keys.target
    -- local ability = keys.ability
    
    target:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
end