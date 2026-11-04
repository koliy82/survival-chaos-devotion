function OnTakeDamage(keys)
	local caster = keys.caster

    local mod = caster:FindModifierByName(keys.modifier)

    if mod then
        stacks = mod:GetStackCount()
        mod:SetStackCount(stacks + keys.DamageTaken)
    end
end

function OnDestroy(keys)
	local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel()

    local mod = caster:FindModifierByName(keys.modifier)
    local maxstacks = ability:GetLevelSpecialValueFor( "hp_need" , level - 1 )

    if mod then
        local particle = ParticleManager:CreateParticle("particles/econ/items/lifestealer/ls_ti10_immortal/ls_ti10_immortal_infest.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
        
        local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
        local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
        local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

        local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1 )
        local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1 )

        local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
        for _,unit in ipairs(units) do
            ApplyCustomDamage(unit, caster, damage, 6, ability)
        end
        stacks = mod:GetStackCount()
        if stacks >= maxstacks then
            local heal = ability:GetLevelSpecialValueFor( "heal" , level - 1 )
            caster:Heal(heal, ability )
            
            local cd_red = ability:GetLevelSpecialValueFor( "cd_red" , level - 1 )
            local cd_remain = ability:GetCooldownTimeRemaining()
            ability:EndCooldown()
            ability:StartCooldown(cd_remain - cd_red)
        end
        mod:SetStackCount(0)
    end
end