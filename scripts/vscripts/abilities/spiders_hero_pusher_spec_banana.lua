LinkLuaModifier( "agr_mod", "modifiers/agr_mod.lua", LUA_MODIFIER_MOTION_NONE )
function OnSpellStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	caster:EmitSound("sounds/weapons/hero/venomancer/banana.vsnd")
	
	local banana_ward_level = ability:GetLevel()
	if banana_ward_level > 0 then
        local owner = caster:GetOwner()
		local radius = ability:GetLevelSpecialValueFor("radius", banana_ward_level -1)
		local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
		local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
		local targetFlag = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
		local spawn_location = caster:GetAbsOrigin() + caster:GetForwardVector() * 300
		
		-- local duration = ability:GetLevelSpecialValueFor("duration", banana_ward_level - 1)
		local banana_ward_unit = CreateUnitByName("npc_dota_spiders_banana", spawn_location, true, owner, owner, caster:GetTeam())
		FindClearSpaceForUnit( banana_ward_unit, spawn_location, false )
		
		banana_ward_unit:AddNewModifier(caster, ability, "modifier_kill", {duration = 15})
		
		local venomancer_banana_ward_cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_ward_cast.vpcf", PATTACH_ABSORIGIN, caster)
		local banana_ward_spawn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_ward_spawn.vpcf", PATTACH_ABSORIGIN, banana_ward_unit)

		ability:ApplyDataDrivenModifier(caster, banana_ward_unit, "modifier_spiders_hero_pusher_spec_banana_passive", {})
		
		local units = FindUnitsInRadius(caster:GetTeamNumber(), spawn_location, nil, radius, targetTeam, targetType, targetFlag, FIND_ANY_ORDER, false)
		for k,v in pairs(units) do
			v:AddNewModifier(banana_ward_unit, ability, "agr_mod", {duration = 1})
		end
	end
end