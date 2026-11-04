function OnSpellStart(keys)
    local caster = keys.caster
    local ability = keys.ability
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )
    local max_targets = ability:GetLevelSpecialValueFor("max_targets", ability:GetLevel() - 1 )

    local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
    local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES

    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, FIND_FARTHEST, false)
    for _,unit in ipairs(units) do
        if not unit:HasModifier("modifier_treants_creeps_mage_bonds_buff") then
            ability:ApplyDataDrivenModifier(caster, unit, "modifier_treants_creeps_mage_bonds_buff", {})
            max_targets = max_targets - 1
            if max_targets == 0 then break end
        end
    end
end

function OnIntervalThink( keys )
    local caster = keys.caster
    local target = keys.target

    -- if not (caster and caster:IsAlive()) then
    --     target:RemoveModifierByName("modifier_treants_creeps_mage_bonds_buff")
    --     return
    -- end

    if caster and target then
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_leech_seed.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
    end
end