function OnIntervalThink(keys)
    local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel()
    local radius = ability:GetLevelSpecialValueFor("radius", level -1)
    local damage = ability:GetLevelSpecialValueFor("damage", level -1)
    local max_targets = ability:GetLevelSpecialValueFor("max_targets", level -1)

    local team = caster:GetTeamNumber()
    local position = caster:GetAbsOrigin()
    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
    local targets =  FindUnitsInRadius(team, position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
    if #targets > 0 then
        for i, unit in pairs( targets ) do
            local part = ParticleManager:CreateParticle("particles/units/heroes/hero_razor_reduced_flash/razor_unstable_current_reduced_flash.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
            ParticleManager:SetParticleControl(part, 0, unit:GetAbsOrigin())
            ParticleManager:SetParticleControlEnt( part, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetOrigin(), true )
    
            ApplyCustomDamage(unit, caster, damage, 6, nil)
            if i >= max_targets then break end
        end
    end
end