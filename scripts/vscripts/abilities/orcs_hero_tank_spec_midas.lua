function OnSpellStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	
	local victims = ability:GetLevelSpecialValueFor("victims", ability:GetLevel() -1)
	local gold = ability:GetLevelSpecialValueFor("gold", ability:GetLevel() -1)
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() -1)
	local id = caster:GetPlayerOwnerID()
	
	local multicast = 1
	
	local multicast_ability = caster:FindAbilityByName("orcs_hero_tank_spec_multicast")
	if multicast_ability then
		local level = multicast_ability:GetLevel()
		if level > 0 then
			local two_times = multicast_ability:GetLevelSpecialValueFor( "multicast_2_times" , level - 1  )
			local three_times = multicast_ability:GetLevelSpecialValueFor( "multicast_3_times" , level - 1  )
			local four_times = multicast_ability:GetLevelSpecialValueFor( "multicast_4_times" , level - 1  )
			
			if RandomInt( 0,100 ) < two_times then multicast = 2 end
			if RandomInt( 0,100 ) < three_times then multicast = 3 end
			if RandomInt( 0,100 ) < four_times then multicast = 4 end
		end
	end
	
	if multicast > 1 then
		local effect_cast = ParticleManager:CreateParticle(
			"particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf",
			PATTACH_OVERHEAD_FOLLOW,
			caster
		)
		ParticleManager:SetParticleControl( effect_cast, 1, Vector( multicast, 2, 0 ) )
		ParticleManager:ReleaseParticleIndex( effect_cast )
	end
	
	for i = 1, multicast do
		Timers:CreateTimer( (i-1)*0.4, function()
			local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false)
			for k,unit in ipairs(units) do
				if k <= victims then
					unit:Kill(ability, caster)
					local effect = ParticleManager:CreateParticle("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
					ParticleManager:SetParticleControlEnt( effect, 0, unit, PATTACH_POINT_FOLLOW, "follow_origin", unit:GetOrigin(), true )
					ParticleManager:SetParticleControlEnt( effect, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true )
					unit:EmitSound("General.Coins")
                    PlayerResource:ModifyGold(id, math.random(0, gold), false, DOTA_ModifyGold_CreepKill)
				end
			end
		end)
	end
end

