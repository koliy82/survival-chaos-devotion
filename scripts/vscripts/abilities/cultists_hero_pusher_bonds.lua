function OnCreated( keys )
    local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel()

    ability.enemies = {}
    
	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

	local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1  )
	local max_targets = ability:GetLevelSpecialValueFor( "max_targets" , level - 1  )

	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)

    for _, unit in ipairs(units) do
        table.insert( ability.enemies, unit )
        ability:ApplyDataDrivenModifier(caster, unit, "modifier_cultists_hero_pusher_bonds_friends", {})
        if #ability.enemies >= max_targets then break end
    end
end

function OnIntervalThink( keys )
    local caster = keys.caster
    local target = keys.target

    if not (caster and caster:IsAlive()) then
        target:RemoveModifierByName("modifier_cultists_hero_pusher_bonds_friends")
        return
    end

    if caster and target then
        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_soul_rip_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 2, caster:GetAbsOrigin())
    end
end

function OnTakeDamage( keys )
    local caster = keys.caster
    local ability = keys.ability
    if not (caster and caster:IsAlive() and ability.enemies) then
        return
    end
    
    local damage_red_prc = ability:GetLevelSpecialValueFor("damage_red_prc", ability:GetLevel() - 1 )
    local damage = keys.damage * damage_red_prc / 100 / #ability.enemies

    for _, unit in ipairs(ability.enemies) do
        if unit and IsValidEntity(unit) and unit:IsAlive() then

            local damageTable = {
                victim = unit,
                attacker = caster,
                damage = damage,
                damage_type = DAMAGE_TYPE_PURE,
            }
            
            ApplyDamage(damageTable)
        end
    end
end

function OnDeath( keys )
    local caster = keys.caster
    local ability = keys.ability
    local heal = ability:GetLevelSpecialValueFor("heal", ability:GetLevel() - 1 )

    caster:Heal( heal, ability )
end