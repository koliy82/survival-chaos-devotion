function ShadowWave( keys )
    local caster = keys.caster
    local caster_location = caster:GetAbsOrigin()
    local target = keys.target
    local target_location = target:GetAbsOrigin()
    local ability = keys.ability
    local ability_level = ability:GetLevel() - 1

    -- Ability variables
    local bounce_radius = ability:GetLevelSpecialValueFor("bounce_radius", ability_level)
    local max_targets = ability:GetLevelSpecialValueFor("max_targets", ability_level)
    local heal = ability:GetLevelSpecialValueFor("heal", ability_level)
    local damage_radius = ability:GetLevelSpecialValueFor("damage_radius", ability_level)
    local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
    local unit_healed = false

    if caster:HasAbility("pszAbilityName") then
        max_targets = ability:GetLevelSpecialValueFor("elite_max_targets", ability_level)
    end

	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

    -- Particles
    local shadow_wave_particle = keys.shadow_wave_particle
    local shadow_wave_damage_particle = keys.damage_particle

    -- Setting up the damage and hit tables
    local hit_table = {}

    -- If the target is not the caster then do the extra bounce for the caster
    if target ~= caster then
        -- Insert the caster into the hit table
        table.insert(hit_table, caster)
        -- Heal the caster and do damage to the units around it
        caster:Heal(heal, caster)
        local units = FindUnitsInRadius(caster:GetTeamNumber(), caster_location, nil, damage_radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)

        for _,unit in ipairs(units) do
            local damage_particle = ParticleManager:CreateParticle(shadow_wave_damage_particle, PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(damage_particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(damage_particle)
            ApplyCustomDamage(unit, caster, damage, 6, nil)
        end
    end

    -- Mark the target as already hit
    table.insert(hit_table, target)
    -- Heal the initial target and do the damage to the units around it
    target:Heal(heal, caster)

    local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, damage_radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)

    for _,unit in ipairs(units) do
        local damage_particle = ParticleManager:CreateParticle(shadow_wave_damage_particle, PATTACH_CUSTOMORIGIN, caster)
        ParticleManager:SetParticleControlEnt(damage_particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
        ParticleManager:ReleaseParticleIndex(damage_particle)
        ApplyCustomDamage(unit, caster, damage, 6, nil)
    end
    
    
    -- Priority is Hurt Heroes > Hurt Units > Heroes > Units
    -- we start from 2 first because we healed 1 target already
    for i = 2, max_targets do
        -- Helper variable to keep track if we healed a unit already
        unit_healed = false

        -- Find all the units in bounce radius
        local units = FindUnitsInRadius(caster:GetTeam(), target_location, nil, bounce_radius, ability:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false)
        
        -- HURT UNITS --
        -- check for hurt units if we havent healed a unit yet
        if not unit_healed then
            for _,unit in pairs(units) do
                local check_unit = 0	-- Helper variable to determine if the unit has been hit or not

                -- Checking the hit table to see if the unit is hit
                for c = 0, #hit_table do
                    if hit_table[c] == unit then
                        check_unit = 1
                    end
                end

                -- If its not hit then check if the unit is hurt
                if check_unit == 0 then
                    if unit:GetHealth() ~= unit:GetMaxHealth() then
                        -- After we find the hurt hero unit then we insert it into the hit table to keep track of it
                        -- and we also get the unit position
                        table.insert(hit_table, unit)
                        local unit_location = unit:GetAbsOrigin()

                        -- Create the particle for the visual effect
                        local particle = ParticleManager:CreateParticle(shadow_wave_particle, PATTACH_CUSTOMORIGIN, caster)
                        ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
                        ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit_location, true)

                        -- Set the unit as the new target
                        target = unit
                        target_location = unit_location

                        -- Heal it and deal damage to enemy units around it
                        target:Heal(heal, caster)

                        local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, damage_radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)

                        for _,unit in ipairs(units) do
                            local damage_particle = ParticleManager:CreateParticle(shadow_wave_damage_particle, PATTACH_CUSTOMORIGIN, caster)
                            ParticleManager:SetParticleControlEnt(damage_particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
                            ParticleManager:ReleaseParticleIndex(damage_particle)
                            ApplyCustomDamage(unit, caster, damage, 6, nil)
                        end

                        -- Set the helper variable to true
                        unit_healed = true

                        -- Exit the loop for finding hurt heroes
                        break
                    end
                end
            end
        end

        -- UNITS --
        -- Search for units regardless if it is hurt or not
        -- Search only if we havent healed a unit yet
        if not unit_healed then
            for _,unit in pairs(units) do
                local check_unit = 0	-- Helper variable to determine if a unit has been hit or not

                -- Checking the hit table to see if the unit is hit
                for c = 0, #hit_table do
                    if hit_table[c] == unit then
                        check_unit = 1
                    end
                end

                -- If its not hit then do the bounce
                if check_unit == 0 then
                    -- Insert the found unit into the hit table
                    -- and we also get the unit position
                    table.insert(hit_table, unit)
                    local unit_location = unit:GetAbsOrigin()

                    -- Create the particle for the visual effect
                    local particle = ParticleManager:CreateParticle(shadow_wave_particle, PATTACH_CUSTOMORIGIN, caster)
                    ParticleManager:SetParticleControlEnt(particle, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target_location, true)
                    ParticleManager:SetParticleControlEnt(particle, 1, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit_location, true)

                    -- Set the unit as the new target
                    target = unit
                    target_location = unit_location

                    -- Heal it and deal damage to enemy units around it
                    target:Heal(heal, caster)

                    local units = FindUnitsInRadius(caster:GetTeamNumber(), target_location, nil, damage_radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)

                    for _,unit in ipairs(units) do
                        local damage_particle = ParticleManager:CreateParticle(shadow_wave_damage_particle, PATTACH_CUSTOMORIGIN, caster)
                        ParticleManager:SetParticleControlEnt(damage_particle, 0, unit, PATTACH_POINT_FOLLOW, "attach_hitloc", unit:GetAbsOrigin(), true)
                        ParticleManager:ReleaseParticleIndex(damage_particle)
                        ApplyCustomDamage(unit, caster, damage, 6, nil)
                    end

                    -- Set the helper variable to true
                    unit_healed = true

                    -- Exit the loop for finding hurt heroes
                    break				
                end
            end
        end
    end
end