function OnSpellStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	local fissure_range = ability:GetLevelSpecialValueFor("distance", (ability:GetLevel() -1))
	local fissure_radius = ability:GetLevelSpecialValueFor("radius", (ability:GetLevel() -1))
	local stun_duration = ability:GetLevelSpecialValueFor("stun_duration", (ability:GetLevel() -1))
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() -1))
	
	-- Position and direction variables
	local direction = caster:GetForwardVector()
	local startPos = caster:GetAbsOrigin() + direction
	local endPos = caster:GetAbsOrigin() + direction * fissure_range
	
	-- Renders the fissure particle in a line
	local particle = ParticleManager:CreateParticle("particles/econ/items/earthshaker/earthshaker_ti9/earthshaker_fissure_ti9.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle, 0, startPos)
	ParticleManager:SetParticleControl(particle, 1, endPos)
	ParticleManager:SetParticleControl(particle, 2, Vector(3, 0, 0 ))

    local units = FindUnitsInLine( caster:GetTeamNumber(), startPos, endPos, nil, fissure_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS)
        
    for _,unit in pairs(units) do
    	unit:AddNewModifier(caster, ability, "modifier_stunned", {Duration = stun_duration})
		ApplyCustomDamage(unit, caster, damage, 6)
    end
end