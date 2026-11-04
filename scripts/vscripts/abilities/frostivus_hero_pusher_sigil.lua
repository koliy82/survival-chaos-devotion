function OnSpellStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	ability.level = ability:GetLevel()
	if ability.level > 0 then
        local owner = caster:GetOwner()
		
		local life_time = ability:GetLevelSpecialValueFor( "life_time", ability.level - 1 )

		local spawn_location = caster:GetAbsOrigin() + caster:GetForwardVector() * 100

		caster.sigil = CreateUnitByName("npc_dota_frostivus_pusher_sigil", spawn_location, true, owner, owner, caster:GetTeam())
		FindClearSpaceForUnit( caster.sigil, spawn_location, false )
		
		caster.sigil:AddNewModifier(caster, ability, "modifier_kill", {duration = life_time})

		ability:ApplyDataDrivenModifier(caster, caster.sigil, "modifier_frostivus_hero_pusher_sigil_move", {})

		ability:ApplyDataDrivenModifier(caster, caster.sigil, "modifier_frostivus_hero_pusher_sigil_aura", {})
	end
end

function Move(keys)
	local caster = keys.caster
	local ability = keys.ability

	if not caster or not caster:IsAlive() then
		return
	end

	local interval = 0.02
		
	local vector_distance = caster:GetAbsOrigin() - caster.sigil:GetAbsOrigin()
	local distance = (vector_distance):Length2D()
	local direction = (vector_distance):Normalized()

	if distance > 250 then
		local speed = ability:GetLevelSpecialValueFor( "speed", ability.level ) * interval
		caster.sigil:SetForwardVector(Vector(0, direction.y, 0))
		caster.sigil:SetAbsOrigin(caster.sigil:GetAbsOrigin() + direction * speed)
	end
end