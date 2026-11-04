function OnSpellStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	ability.level = ability:GetLevel()
	if ability.level > 0 then
        local owner = caster:GetOwner()
		
		local life_time = ability:GetLevelSpecialValueFor( "life_time", ability.level - 1 )

		local spawn_location = caster:GetAbsOrigin() + caster:GetForwardVector() * 100

		caster.pumpkin = CreateUnitByName("npc_dota_diretide_pusher_pumpkin", spawn_location, true, owner, owner, caster:GetTeam())
		FindClearSpaceForUnit( caster.pumpkin, spawn_location, false )
		
		caster.pumpkin:AddNewModifier(caster, ability, "modifier_kill", {duration = life_time})

		ability:ApplyDataDrivenModifier(caster, caster.pumpkin, "modifier_diretide_hero_pusher_pumpkin_move", {})

		ability:ApplyDataDrivenModifier(caster, caster.pumpkin, "modifier_diretide_hero_pusher_pumpkin_aura", {})
	end
end

function Move(keys)
	local caster = keys.caster
	local ability = keys.ability

	if not caster or not caster:IsAlive() then
		return
	end

	local interval = 0.02
		
	local vector_distance = caster:GetAbsOrigin() - caster.pumpkin:GetAbsOrigin()
	local distance = (vector_distance):Length2D()
	local direction = (vector_distance):Normalized()

	if distance > 300 then
		local speed = ability:GetLevelSpecialValueFor( "speed", ability.level ) * interval
		caster.pumpkin:SetForwardVector(Vector(0, direction.y, 0))
		caster.pumpkin:SetAbsOrigin(caster.pumpkin:GetAbsOrigin() + direction * speed)
	end
end