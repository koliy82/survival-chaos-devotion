function OnIntervalThink(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability

	local heal = ability:GetLevelSpecialValueFor( "heal", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local damage_on_buildings = ability:GetLevelSpecialValueFor( "damage_on_buildings", ability:GetLevel() - 1 )

    local caster_team = caster:GetTeamNumber()

    if target:GetTeamNumber() == caster_team and not target:IsAncient() then
        target:Heal( heal, ability )
    else
        if target:IsAncient() then
            ApplyCustomDamage(target, caster, damage * damage_on_buildings / 100, 6, ability)
        else
            ApplyCustomDamage(target, caster, damage, 6, ability)
        end
    end
end

function Effect(event)
    local caster = event.caster
    local ability = event.ability

	local particle_cast = "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian_aoe.vpcf"
	local sound_cast = "Hero_Dawnbreaker.Solar_Guardian.Target"
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )

	point = caster:GetAbsOrigin()

	ability.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, caster )
	ParticleManager:SetParticleControl( ability.effect_cast, 0, point )
	ParticleManager:SetParticleControl( ability.effect_cast, 1, point )
	ParticleManager:SetParticleControl( ability.effect_cast, 2, Vector( radius, radius, radius ) )

	EmitSoundOnLocationWithCaster( point, sound_cast, caster )
end

function OnDestroy(event)
    local ability = event.ability

    ParticleManager:DestroyParticle(ability.effect_cast, false)
end