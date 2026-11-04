function OnSpellStart(keys)
	local caster = keys.caster
	local ability = keys.ability

	local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local targetFlag = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO

	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() -1)
	local creep_level = ability:GetLevelSpecialValueFor("creep_level", ability:GetLevel() -1)

	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, targetTeam, targetType, targetFlag, FIND_FARTHEST, false)
    ability.victim = nil

	for _,unit in ipairs(units) do
		if unit:GetLevel() == creep_level then
			ability.victim = unit
			break
		end
	end

	if ability.victim then
		ability:ApplyDataDrivenModifier(caster, ability.victim, "modifier_frostivus_creeps_mage_sinister_debuff", {})
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_frostivus_creeps_mage_sinister_buff", {})

    	caster.particle = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_gaze.vpcf", PATTACH_ABSORIGIN_FOLLOW, ability.victim)
		ParticleManager:SetParticleControlEnt(caster.particle, 0, ability.victim, PATTACH_ABSORIGIN_FOLLOW, nil, ability.victim:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(caster.particle, 1, ability.victim, PATTACH_ABSORIGIN_FOLLOW, nil, ability.victim:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(caster.particle, 2, caster, PATTACH_POINT_FOLLOW, "attach_portrait", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(caster.particle, 3, caster, PATTACH_ABSORIGIN_FOLLOW, nil, caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(caster.particle, 10, ability.victim, PATTACH_ABSORIGIN_FOLLOW, nil, ability.victim:GetAbsOrigin(), true)
		--AddParticle(particle, false, false, -1, false, false)

		caster.particle2 = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_gaze_eyes.vpcf", PATTACH_ABSORIGIN_FOLLOW, ability.victim)
		ParticleManager:SetParticleControlEnt(caster.particle2, 1, caster, PATTACH_POINT_FOLLOW, "attach_eye_l", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(caster.particle2, 2, caster, PATTACH_POINT_FOLLOW, "attach_eye_r", caster:GetAbsOrigin(), true)
		--AddParticle(particle2, false, false, -1, false, false)
	else 
		caster:Interrupt()
	end
end

function OnChannelSucceeded(keys)
	local caster = keys.caster
	local ability = keys.ability

	if ability.victim and ability.victim:IsAlive() then ability.victim:Kill(ability, caster) end
end

function OnChannelInterrupted(keys)
	local caster = keys.caster
	local ability = keys.ability

	if caster.particle then 
		ParticleManager:DestroyParticle(caster.particle, false)
	end
	if caster.particle2 then 
		ParticleManager:DestroyParticle(caster.particle2, false)
	end

	if caster:IsAlive() then
		local mana = ability:GetManaCost( ability:GetLevel() - 1 )
		caster:GiveMana(mana)
		ability:EndCooldown()
	end
end