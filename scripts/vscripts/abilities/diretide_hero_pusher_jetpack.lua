function OnSpellStart(keys)
    local caster = keys.caster
    local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
    local distance = ability:GetLevelSpecialValueFor("distance", ability_level)
    local casterPos = caster:GetAbsOrigin()

    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	local targets =  FindUnitsInRadius(caster:GetTeamNumber(), casterPos, nil, distance, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
    if #targets > 0 then
		local dir = (targets[1]:GetOrigin()-casterPos):Normalized()

		local startPos = casterPos + dir * 5 
		local endPos = startPos + (dir * distance)

        local mod = ability:ApplyDataDrivenModifier(caster, caster, "modifier_diretide_hero_pusher_jetpack", {duration = duration})
        local part = ParticleManager:CreateParticle('particles/units/heroes/hero_rattletrap/rattletrap_jetpack.vpcf', PATTACH_ABSORIGIN_FOLLOW, caster)
        ParticleManager:SetParticleControlEnt(part, 1, caster, PATTACH_ABSORIGIN_FOLLOW, nil, startPos, true)
        ParticleManager:SetParticleControlEnt(part, 2, caster, PATTACH_ABSORIGIN_FOLLOW, nil, startPos, true)
        ParticleManager:SetParticleControlEnt(part, 3, caster, PATTACH_ABSORIGIN_FOLLOW, nil, startPos, true)
        mod:AddParticle(part, false, false, 0, false, false)
        -- mod:AddParticle(ParticleManager:CreateParticle('particles/econ/items/bloodseeker/bloodseeker_ti7/bloodseeker_ti7_thirst_owner.vpcf', PATTACH_ABSORIGIN_FOLLOW, caster), false, false, 0, false, false)
        -- caster:SetModelScale(0.3)
        caster:MoveToPosition(endPos)
        caster:AddActivityModifier("jetpack")
        caster:StartGesture(ACT_DOTA_FLAIL)--ACT_DOTA_IDLE
        Timers:CreateTimer(2, function()
                caster:MoveToPosition(startPos)
                Timers:CreateTimer(2, function()
                    caster:FadeGesture(ACT_DOTA_FLAIL)
                    caster:ClearActivityModifiers()
                end)
        end)
    end
end

function ApplyDamage(keys)
    local caster = keys.caster
    local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local damage_radius = ability:GetLevelSpecialValueFor("damage_radius", ability_level)
    local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
    local buildings_damage = 100 - ability:GetLevelSpecialValueFor("buildings_damage", ability_level)
    local part = ParticleManager:CreateParticle('particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_death_explosion.vpcf', PATTACH_ABSORIGIN, caster)
    ParticleManager:SetParticleControl(part, 0, GetGroundPosition(caster:GetAbsOrigin(), caster))
    
	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NONE

	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, damage_radius, target_teams, target_types, target_flags, 0, false)
	
    for _, unit in pairs( units ) do
        if unit:IsAncient() then
            ApplyCustomDamage(unit, caster, damage * buildings_damage / 100, 6, ability)
        else
            ApplyCustomDamage(unit, caster, damage, 6, ability)
        end
    end
end