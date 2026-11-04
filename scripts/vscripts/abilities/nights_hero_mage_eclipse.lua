function eclipse_start(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	ability.bounceTable = {}

	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	local beam_interval = ability:GetLevelSpecialValueFor("beam_interval", ability:GetLevel() - 1)
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
	ability.max_hit_count = ability:GetLevelSpecialValueFor("hit_count", ability:GetLevel() - 1)

	if not GameRules:IsDaytime() then
		duration = duration + ability:GetLevelSpecialValueFor("night_bonus", ability:GetLevel() - 1)
	end

	for delay = 0, duration, beam_interval do
		Timers:CreateTimer(delay, function ()
				local unitsNearTarget = FindUnitsInRadius(caster:GetTeamNumber(),
			                            caster:GetAbsOrigin(),
			                            nil,
			                            radius,
			                            DOTA_UNIT_TARGET_TEAM_ENEMY,
			                            DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			                            DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			                            FIND_ANY_ORDER,
			                            false)

				target = nil
				for k, v in pairs(unitsNearTarget) do
					if ability.bounceTable[v] == nil or ability.bounceTable[v] < ability.max_hit_count then
						target = v
						break
					end
				end

				if target ~= nil then
					beam = ParticleManager:CreateParticle("particles/econ/items/luna/luna_lucent_ti5/luna_eclipse_impact_moonfall.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
					ParticleManager:SetParticleControlEnt(beam, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", caster:GetAbsOrigin(), true )
					ParticleManager:SetParticleControlEnt(beam, 1, target, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", target:GetAbsOrigin(), true )
					ParticleManager:SetParticleControlEnt(beam, 5, target, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", target:GetAbsOrigin(), true )

					EmitSoundOn("Hero_Luna.Eclipse.Target", target)

					if target:IsCustomHero() then
                    	ApplyCustomDamage(target, caster, damage / 2, 6, ability)
					else
						ApplyCustomDamage(target, caster, damage, 6, ability)
					end

					ability.bounceTable[target] = ((ability.bounceTable[target] or 0) + 1)
				end
			end)
	end 
end