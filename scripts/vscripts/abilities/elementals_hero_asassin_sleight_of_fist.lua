function sleight_of_fist_init( keys )
	local caster = keys.caster
	-- local targetPoint = keys.target_points[1]
	-- local targetPoint = keys.target
	local targetPoint = keys.target:GetAbsOrigin()
	local ability = keys.ability
	local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
	local attack_interval = ability:GetLevelSpecialValueFor( "attack_interval", ability:GetLevel() - 1 )
	local casterModifierName = "modifier_elementals_hero_asassin_sleight_of_fist"
	local particleSlashName = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf"
	local particleTrailName = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf"
	local particleCastName = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf"
	local slashSound = "Hero_EmberSpirit.SleightOfFist.Damage"
	
	-- Targeting variables
	local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local targetFlag = DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	local unitOrder = FIND_ANY_ORDER
	
	-- Necessary varaibles
	local counter = 0
	caster.sleight_of_fist_active = true
	local start_position = caster:GetAbsOrigin()
	
	-- Casting particles
	local castFxIndex = ParticleManager:CreateParticle( particleCastName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( castFxIndex, 0, targetPoint )
	ParticleManager:SetParticleControl( castFxIndex, 1, Vector( radius, 0, 0 ) )
	
	Timers:CreateTimer( 0.1, function()
		ParticleManager:DestroyParticle( castFxIndex, false )
		ParticleManager:ReleaseParticleIndex( castFxIndex )
	end)

	caster:AddNoDraw()
	
	-- Start function
	local units = FindUnitsInRadius(
		caster:GetTeamNumber(), targetPoint, caster, radius, targetTeam,
		targetType, targetFlag, unitOrder, false
	)
	
	local old_target = caster:GetAbsOrigin()
	
	-- print("sleight")
	for _, target in pairs( units ) do
		-- print(counter)
		counter = counter + 1
		Timers:CreateTimer( counter * attack_interval, function()
				-- Only jump to it if it's alive
				if target and target:IsAlive() then
					-- Create trail particles
					local trailFxIndex = ParticleManager:CreateParticle( particleTrailName, PATTACH_CUSTOMORIGIN, target )
					ParticleManager:SetParticleControl( trailFxIndex, 0, target:GetAbsOrigin() )
					ParticleManager:SetParticleControl( trailFxIndex, 1, old_target )

					old_target = target:GetAbsOrigin()
					
					Timers:CreateTimer( 0.1, function()
							ParticleManager:DestroyParticle( trailFxIndex, false )
							ParticleManager:ReleaseParticleIndex( trailFxIndex )
							return nil
						end
					)
					
					-- Slash particles
					local slashFxIndex = ParticleManager:CreateParticle( particleSlashName, PATTACH_ABSORIGIN_FOLLOW, target )
					StartSoundEvent( slashSound, caster )
					
					ApplyCustomDamage(target, caster, damage, 6, ability)
					
					Timers:CreateTimer( 0.1, function()
							ParticleManager:DestroyParticle( slashFxIndex, false )
							ParticleManager:ReleaseParticleIndex( slashFxIndex )
							StopSoundEvent( slashSound, caster )
							return nil
						end
					)
				
				end
				return nil
			end
		)
	end
	
	-- Return caster to origin position
	-- print(( counter + 1 ) * attack_interval)
	Timers:CreateTimer( ( counter + 1 ) * attack_interval, function()
			--FindClearSpaceForUnit( caster, start_position, false )
			caster:RemoveModifierByName( casterModifierName )
			caster:RemoveNoDraw()
			caster.sleight_of_fist_active = false
			return nil
		end
	)
end