function OnSpellStart( keys )
	local ability = keys.ability
	local caster = keys.caster
	local casterLocation = keys.caster:GetAbsOrigin()
	local minDistance = 150
	local maxDistance = 600
	local duration = ability:GetLevelSpecialValueFor( "duration", ( ability:GetLevel() - 1 ) )
	local count = ability:GetLevelSpecialValueFor( "count", ( ability:GetLevel() - 1 ) )
	local soundEventName = "FrostivusConsumable.Snowman.Spawn"

	for i = 1, count do
		Timers:CreateTimer( (i-1)*0.1, function()
			local directionConstraint = 0
			if ability.directionConstraint then
				ability.directionConstraint = ability.directionConstraint + 1
				if ability.directionConstraint >= 4 then
					ability.directionConstraint = 0
				end
				directionConstraint = ability.directionConstraint
			else
				ability.directionConstraint = 0
			end
		
			-- Get random point
			local castDistance = RandomInt( minDistance, maxDistance )
			local angle = RandomInt( 0, 90 )
			local dy = castDistance * math.sin( angle )
			local dx = castDistance * math.cos( angle )
			local attackPoint = Vector( 0, 0, 0 )
			
			if directionConstraint == 0 then			-- NW
				attackPoint = Vector( casterLocation.x - dx, casterLocation.y + dy, casterLocation.z )
			elseif directionConstraint == 1 then		-- NE
				attackPoint = Vector( casterLocation.x + dx, casterLocation.y + dy, casterLocation.z )
			elseif directionConstraint == 2 then		-- SE
				attackPoint = Vector( casterLocation.x + dx, casterLocation.y - dy, casterLocation.z )
			else										-- SW
				attackPoint = Vector( casterLocation.x - dx, casterLocation.y - dy, casterLocation.z )
			end
			
			StartSoundEventFromPosition( soundEventName, attackPoint )
			
			local thinker = CreateModifierThinker( caster, ability, "", {duration = duration}, attackPoint, caster:GetTeamNumber(), false)
			ability:ApplyDataDrivenModifier(caster, thinker, "modifier_dragons_hero_mage_spec_ice_lab", {duration = duration})
		end)
	end
end

function OnCreated(keys)
    keys.target:FindModifierByName("modifier_dragons_hero_mage_spec_ice_lab_trigger"):GetAuraOwner():Destroy()
end