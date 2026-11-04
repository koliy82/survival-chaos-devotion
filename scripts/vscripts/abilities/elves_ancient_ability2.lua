--[[
	author: jacklarnes
	email: christucket@gmail.com
	reddit: /u/jacklarnes
	Date: 03.04.2015.

	Much help from Noya and BMD
]]

--[[
	Must have luna_lucent_beam_datadriven ability to deal damage
	i defaulted the damage to 300 if the ability doesn't exist
]]

function eclipse_start(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	ability.bounceTable = {}

	ability.radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1)
	ability.beam_interval = ability:GetLevelSpecialValueFor("beam_interval", ability:GetLevel() - 1)
	ability.damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1)

	-- if not scepter
	ability.beams = ability:GetLevelSpecialValueFor("beams", ability:GetLevel() - 1) 
	ability.max_hit_count = ability:GetLevelSpecialValueFor("hit_count", ability:GetLevel() - 1)
	-- else
	--ability.beams = ability:GetLevelSpecialValueFor("beams_scepter", ability:GetLevel() - 1) 
	--ability.max_hit_count = ability:GetLevelSpecialValueFor("hit_count_scepter", ability:GetLevel() - 1) 


	for delay = 0, (ability.beams-1) * ability.beam_interval, ability.beam_interval do
		Timers:CreateTimer(delay, function ()
				-- i'm assuming it returns these in random order, might have to fix later
				if caster:IsAlive() == false then
					return
				end

				local unitsNearTarget = FindUnitsInRadius(caster:GetTeamNumber(),
			                            caster:GetAbsOrigin(),
			                            nil,
			                            ability.radius,
			                            DOTA_UNIT_TARGET_TEAM_ENEMY,
			                            DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			                            DOTA_UNIT_TARGET_FLAG_NONE,
			                            FIND_ANY_ORDER,
			                            false)

				-- finds the first target with < max_hit_count
				target = nil
				for k, v in pairs(unitsNearTarget) do
					if ability.bounceTable[v] == nil or ability.bounceTable[v] < ability.max_hit_count then
						target = v
						break
					end
				end

				-- if it finds a target, deals damage and then adds it to the bounceTable
				if target ~= nil then
					beam = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_eclipse_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
					ParticleManager:SetParticleControlEnt(beam, 0, caster, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", caster:GetAbsOrigin(), true )
					ParticleManager:SetParticleControlEnt(beam, 1, target, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", target:GetAbsOrigin(), true )
					ParticleManager:SetParticleControlEnt(beam, 5, target, PATTACH_ABSORIGIN_FOLLOW, "follow_origin", target:GetAbsOrigin(), true )

					EmitSoundOn("Hero_Luna.Eclipse.Target", target)

                    ApplyCustomDamage(target, caster, ability.damage, 6, ability)

					ability.bounceTable[target] = ((ability.bounceTable[target] or 0) + 1)
				end
			end)
	end 
end