function torrent_storm_explode( keys )
	local ability = keys.ability
	local caster = keys.caster
	local casterLocation = keys.caster:GetAbsOrigin()
	local abilityDamage = ability:GetLevelSpecialValueFor( "damage", ( ability:GetLevel() - 1 ) )
	local minDistance = ability:GetLevelSpecialValueFor( "explosion_min_dist", ( ability:GetLevel() - 1 ) )
	local maxDistance = ability:GetLevelSpecialValueFor( "explosion_max_dist", ( ability:GetLevel() - 1 ) )
	local radius = ability:GetLevelSpecialValueFor( "explosion_radius", ( ability:GetLevel() - 1 ) )
	local modifDuration = ability:GetLevelSpecialValueFor( "stun_duration", ( ability:GetLevel() - 1 ) ) + ability:GetLevelSpecialValueFor( "slow_duration", ( ability:GetLevel() - 1 ) )
	local modifierName = "modifier_nagas_hero_pusher_torrent_storm_debuff"
	local particleName = "particles/units/heroes/hero_kunkka/kunkka_spell_torrent_splash.vpcf"
	local soundEventName = "Ability.Torrent"
	local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local targetFlag = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
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
	
	-- Fire sound at dummy
	StartSoundEventFromPosition( soundEventName, attackPoint )
	
	-- Fire effect
	local fxIndex = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )
	ParticleManager:SetParticleControl( fxIndex, 0, attackPoint )
	
	-- From here onwards might be possible to port it back to datadriven through modifierArgs with point but for now leave it as is
	-- Loop through units
	local units = FindUnitsInRadius( caster:GetTeamNumber(), attackPoint, nil, radius, targetTeam, targetType, targetFlag, FIND_ANY_ORDER, false )
    for k, v in pairs( units ) do
        ability:ApplyDataDrivenModifier(caster, v, modifierName, {duration = modifDuration})
        ApplyCustomDamage(v, caster, abilityDamage, 6, ability)
	end
end