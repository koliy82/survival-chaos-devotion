function OnAttackLanded(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
    local level = ability:GetLevel()
	if level > 0 and ability:IsCooldownReady() and caster:GetMana() >= ability:GetManaCost(level - 1) then
		ability:StartCooldown(ability:GetEffectiveCooldown(level))
		caster:SpendMana(ability:GetManaCost(level - 1), ability)
		local duration = ability:GetLevelSpecialValueFor( "duration", ( level - 1 ) )
		local thinker = CreateModifierThinker( caster, ability, "", {Duration = duration}, caster:GetAbsOrigin(), caster:GetTeamNumber(), false)
		ability:ApplyDataDrivenModifier(caster, thinker, "modifier_treants_furion_natures_grasp", {Duration = duration})
	end
end

function OnCreated(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local dash_speed = ability:GetSpecialValueFor("projectile_speed")
	local direction = caster:GetForwardVector()
	target.caster_team = caster:GetTeamNumber()
	target.start_location = caster:GetAbsOrigin()
	target.length  = ability:GetSpecialValueFor("length")
    target.radius  = ability:GetSpecialValueFor("radius")
    target.particles = {}

	while dash_speed < target.length do
        local particle = ParticleManager:CreateParticle(keys.particle, PATTACH_WORLDORIGIN, caster)
        -- Fire effect
        target.expected_location = target.start_location + direction  * dash_speed
        dash_speed = dash_speed + 200
        ParticleManager:SetParticleControl( particle, 0, target.expected_location )
        table.insert( target.particles, particle )
	end
end

function OnInterval(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	if ability then
		local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
		local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
		local targetFlag = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
		local modifierName = "modifier_treants_furion_natures_grasp_debuff"

		local units = FindUnitsInLine( target.caster_team, target.start_location, target.expected_location, nil, target.radius, targetTeam, targetType, targetFlag)
		for k, v in pairs( units ) do
			ability:ApplyDataDrivenModifier(caster, v, modifierName, {duration = 0.5})
			ability:ApplyDataDrivenModifier(caster, v, "modifier_treants_furion_natures_grasp_debuff_armor", {duration = 2})
		end
	end
end

function OnDestroy(keys)
    local target = keys.target
	if target.particles then
    	for k, v in pairs( target.particles ) do
    	    ParticleManager:DestroyParticle(v, false)
    	end
	end
end
