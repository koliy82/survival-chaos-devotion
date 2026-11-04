function ParalyzingCask(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel()
	local bounce_range = ability:GetLevelSpecialValueFor("radius", (level -1))
	local bounce_delay = ability:GetLevelSpecialValueFor("jump_delay", (level -1))
	local speed = 1000
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", (level -1))
	local damage = ability:GetLevelSpecialValueFor("damage", (level -1))
	
	-- Determines the number of bounces the cask has left
	if ability.bounces_left == nil then
		ability.bounces_left = ability:GetLevelSpecialValueFor("jump_count", (level -1))
	else
		ability.bounces_left = ability.bounces_left - 1
	end
	
	-- Apply the stun to the current target
	if not target:IsCustomHero() then
		target:AddNewModifier(target, ability, "modifier_stunned", {Duration = stun_duration})
	end
	ApplyCustomDamage(target, caster, damage, 6, ability)
	
	-- If the cask has bounces left, it finds a new target to bounce to
	if ability.bounces_left > 0 then
		-- We wait on the delay
		Timers:CreateTimer(bounce_delay,
		function()
			-- Finds all units in the area
			local units = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, bounce_range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false)
			-- Go through the target_enties table, checking for the first one that isn't the same as the target
			local target_to_jump = nil
			for _,unit in pairs(units) do
				if unit ~= target and not target_to_jump then
					target_to_jump = unit
				end
			end
		
			-- If there is a new target to bounce to, we create the a projectile
			if target_to_jump then
				-- Create the next projectile
				local info = {
				Target = target_to_jump,
				Source = target,
				Ability = ability,
				EffectName = keys.particle,
				bDodgeable = true,
				bProvidesVision = false,
				iMoveSpeed = speed,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
				}
				ProjectileManager:CreateTrackingProjectile( info )
			else
				ability.bounces_left = nil
			end	
		end)
	else
		ability.bounces_left = nil
	end
end