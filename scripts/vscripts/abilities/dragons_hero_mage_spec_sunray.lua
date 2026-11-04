function OnSpellStart(keys)
	local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel() - 1
	
    local wave_direction = caster:GetForwardVector()
	local distance = ability:GetLevelSpecialValueFor("distance", level)
	local duration = ability:GetLevelSpecialValueFor("duration", level)
	local endPoint = caster:GetAbsOrigin() + (distance *  wave_direction)

    local particleName = "particles/units/heroes/hero_phoenix/phoenix_sunray.vpcf"
	ability.pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt( ability.pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true )
	ParticleManager:SetParticleControl( ability.pfx, 1, endPoint )

	Timers:CreateTimer( duration, function()
		ParticleManager:DestroyParticle(ability.pfx, false)
	end)
end

function OnIntervalThink(keys)
	local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel() - 1
	
    local wave_direction = caster:GetForwardVector()
	local heal = ability:GetLevelSpecialValueFor("heal", level)
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local distance = ability:GetLevelSpecialValueFor("distance", level)
	local damage = ability:GetLevelSpecialValueFor("damage", level)
	local wave_location = caster:GetAbsOrigin() + (5 *  wave_direction)
	local endPoint = caster:GetAbsOrigin() + (distance *  wave_direction)
	local caster_team = caster:GetTeamNumber()

	ParticleManager:SetParticleControl( ability.pfx, 1, endPoint )

    local units = FindUnitsInLine( caster_team, caster:GetAbsOrigin(), endPoint, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS)
    
    for _,unit in pairs(units) do
    	if unit:GetTeamNumber() ~= caster_team then
			if unit:IsCustomHero() then
				ApplyCustomDamage(unit, caster, damage / 4, 6, ability)
			end			
			ApplyCustomDamage(unit, caster, damage / 4, 6, ability)
		else
			unit:Heal(heal / 4, caster)
		end
    end
end