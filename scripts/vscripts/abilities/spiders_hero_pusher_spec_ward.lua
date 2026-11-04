function OnSpellStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	local plague_ward_level = ability:GetLevel()
	if plague_ward_level > 0 then
        local owner = caster:GetOwner()
		local spawn_location = caster:GetAbsOrigin()
		local rand_direction = RandomInt( -1,0 )
		if rand_direction == 0 then rand_direction = 1 end
		spawn_location.x = spawn_location.x + 100 * rand_direction
	
		rand_direction = RandomInt( -1,0 )
		if rand_direction == 0 then rand_direction = 1 end
		spawn_location.y = spawn_location.y + 100 * rand_direction
		
		local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1)
		local plague_ward_unit = CreateUnitByName("npc_dota_spiders_ward", spawn_location, true, owner, owner, caster:GetTeam())
		FindClearSpaceForUnit( plague_ward_unit, spawn_location, false )
		
		plague_ward_unit:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
		
		local venomancer_plague_ward_cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_ward_cast.vpcf", PATTACH_ABSORIGIN, caster)
		local plague_ward_spawn_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_ward_spawn.vpcf", PATTACH_ABSORIGIN, plague_ward_unit)
	end
end