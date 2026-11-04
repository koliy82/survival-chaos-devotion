function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()
    
    if _G.playersinfo[id].ancient then
        ability:ApplyDataDrivenModifier(caster, _G.playersinfo[id].ancient, "modifier_cultists_ancient_builds_aura_buff", {})
	end
    for k, v in pairs(_G.playersinfo[id].baracks) do
        ability:ApplyDataDrivenModifier(caster, v, "modifier_cultists_ancient_builds_aura_buff", {})
	end
    for k, v in pairs(_G.playersinfo[id].towers) do
        ability:ApplyDataDrivenModifier(caster, v, "modifier_cultists_ancient_builds_aura_buff", {})
	end
end

function DamageReturn(event)
	local caster = event.caster
    local ability = event.ability
    local attacker = event.attacker
    local target = event.target

    local damage = event.damage

    local particle_cast = "particles/units/heroes/hero_dark_seer/dark_seer_ion_shell_damage.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, attacker )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0),
		true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		attacker,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0),
		true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

    -- ApplyCustomDamage(attacker, caster, damage, 6, ability)
    ApplyPureDamageTable(attacker, caster, damage, ability)
end