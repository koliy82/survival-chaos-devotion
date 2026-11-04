function CreateMissile(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local missiles = ability:GetLevelSpecialValueFor( "missiles", ability:GetLevel() - 1 )
	local starting_distance = ability:GetLevelSpecialValueFor( "starting_distance", ability:GetLevel() - 1 )
	local direction = caster:GetForwardVector()
	local team = caster:GetTeam()
	-- The missile starts some distance from the caster, in the direction of the target (also the way the caster's facing)
	local position = caster:GetAbsOrigin() + starting_distance * direction
	-- The initial position of the missile, to be used later in damage calculations
	ability.starting_position = position
	ability.level = ability:GetLevel() - 1
	-- A boolean telling us whether the missile has hit its target (ensures no repeated missile hit actions)
	
	local targets = FindUnitsInRadius(team, caster:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false)
	local target = nil
	for i=1, missiles do
		if #targets > 0 then
			for k,v in pairs(targets) do
				target = v
				targets[k] = nil
				break
			end
		else
			return
		end
		-- Creates the missile
		local unit = CreateUnitByName("npc_dota_gyrocopter_homing_missile", position, true, caster, nil, team)
		-- Applies the modifer that moves the missile
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_dwarfs_hero_mage_spec_homing_missile", {})
		unit:SetOwner(caster)
		unit.target = target
		unit.hit = false
		ability:ApplyDataDrivenModifier(caster, target, "modifier_dwarfs_hero_mage_spec_homing_missile_target", {})
		-- We need to keep track of passing time, so we know when to fire the missile after the delay
		ability.time_passed = 0
		-- Attaches the fuse particle to the missile
		local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_ABSORIGIN_FOLLOW, unit) 
		ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
	end
end

function MoveMissile(keys)
	local caster = keys.caster
	local ability = keys.ability
	local unit = keys.target
	local target = unit.target
	
	if target then
		if target:IsNull() or not target:IsAlive() then
			EmitSoundOn(keys.sound4, unit)
			unit:ForceKill(false)
			unit:AddNoDraw()
			return
		end
	else
		EmitSoundOn(keys.sound4, unit)
		unit:ForceKill(false)
		unit:AddNoDraw()
		return
	end
	-- The interval on which this function is called (every 0.02 seconds)
	local interval = 0.02
	
	-- Checks whether the missile has hit the target already
	if unit.hit == false then
		local pre_flight_time = ability:GetLevelSpecialValueFor( "pre_flight_time", ability.level )
		local stun_duration = ability:GetLevelSpecialValueFor( "stun_duration", ability.level )
		
		-- Location and distance variables
		local vector_distance = target:GetAbsOrigin() - unit:GetAbsOrigin()
		local distance = (vector_distance):Length2D()
		local direction = (vector_distance):Normalized()
		
		-- Adds the interval length to the passed time
		ability.time_passed = ability.time_passed + interval
		
		-- Checks if the missile has passed its pre-launch phase
		if ability.time_passed >= pre_flight_time then
			-- On the missile launch, we play the launch sound
			-- if ability.time_passed == pre_flight_time then
			-- 	EmitSoundOn(keys.sound2, unit)
			-- end
			-- Checks if the missile is close enough to hit the target (melee range)
			if distance < 128 then
				unit.hit = true
				-- The missile's distance from its starting point
				local travel_vector_distance = unit:GetAbsOrigin() - ability.starting_position
				local travel_distance = travel_vector_distance:Length2D()
				
				local particle = ParticleManager:CreateParticle(keys.particle2, PATTACH_ABSORIGIN_FOLLOW, target) 
				ParticleManager:SetParticleControlEnt(particle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
				EmitSoundOn(keys.sound3, unit)
				
				-- Removes the targeting particle from the target
				target:RemoveModifierByName("modifier_dwarfs_hero_mage_spec_homing_missile_target")
				-- Applies the stun to the target
				target:AddNewModifier(caster, ability, "modifier_stunned", {Duration = stun_duration})
				-- Applies the damage to the target
				local damage = ability:GetLevelSpecialValueFor( "damage", ability.level )
				-- ApplyDamage({victim = target, attacker = caster, damage = damage, damage_type = ability:GetAbilityDamageType()})
				ApplyCustomDamage(target, caster, damage, 6, ability)

				-- Plays the missile death sound
				EmitSoundOn(keys.sound4, unit)
				-- Kills the missile, which triggers the OnMissileAttacked block
				unit:ForceKill(false)
				-- MissileAttacked(keys)
				
				-- Removes the missile's model, so there is no death animation
				unit:AddNoDraw()
				-- Stops both missile sounds
				-- StopSoundEvent(keys.sound2, unit)
			else
				local speed = ability:GetLevelSpecialValueFor( "speed", ability.level )*interval
				-- Turns the missile so it's facing the target
				unit:SetForwardVector(Vector(direction.x/2, direction.y/2, -1))--needfix
				-- Moves the missile
				unit:SetAbsOrigin(unit:GetAbsOrigin() + direction * speed)
			end
		end
	end
end