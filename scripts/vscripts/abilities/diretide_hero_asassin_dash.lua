function OnSpellStart(keys)
    local caster = keys.caster
    local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
	local distance = ability:GetLevelSpecialValueFor("distance", ability_level)
    local mod = ability:ApplyDataDrivenModifier(caster, caster, "modifier_diretide_hero_asassin_dash_move", {duration = duration})
    mod:AddParticle(ParticleManager:CreateParticle('particles/econ/items/shadow_fiend/sf_desolation/sf_desolation_haste.vpcf', PATTACH_ABSORIGIN_FOLLOW, caster), false, false, 0, false, false)
    mod:AddParticle(ParticleManager:CreateParticle('particles/econ/items/bloodseeker/bloodseeker_ti7/bloodseeker_ti7_thirst_owner.vpcf', PATTACH_ABSORIGIN_FOLLOW, caster), false, false, 0, false, false)
    local casterPos = caster:GetAbsOrigin()

    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	local targets =  FindUnitsInRadius(caster:GetTeamNumber(), casterPos, nil, distance, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
    if #targets > 0 then
		local dir = (targets[1]:GetOrigin()-casterPos):Normalized()

		local startPos = casterPos + dir * 5 
		local endPos = startPos + (dir * distance)
        caster:MoveToPosition(endPos)
        caster:StartGesture(ACT_DOTA_FLAIL)
        caster:AddActivityModifier("forcestaff_friendly")
        Timers:CreateTimer(0.45, function()
            -- caster:StartGesture(ACT_DOTA_FORCESTAFF_END)
            -- Timers:CreateTimer(0.1, function()
                caster:MoveToPosition(casterPos)
                caster:StartGesture(ACT_DOTA_FLAIL)
                caster:AddActivityModifier("forcestaff_friendly")
                Timers:CreateTimer(0.35, function()
                    caster:StartGesture(ACT_DOTA_FORCESTAFF_END)
                end)
            -- end)
        end)
    end
end