function OnTakeDamage(keys)
	local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel()
    if level > 0 and ability:IsCooldownReady() then
        local mod = caster:FindModifierByName(keys.modifier)
        local maxstacks = ability:GetLevelSpecialValueFor( "need_damage" , level - 1  )
        local damage_taken = keys.DamageTaken

        if mod then
            stacks = mod:GetStackCount()
            if stacks < maxstacks then
                mod:SetStackCount(stacks+damage_taken)
            else
                local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	            local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	            local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

                local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1  )
                local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1  )

                local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
	            for _,unit in ipairs(units) do
                    ApplyCustomDamage(unit, caster, damage, 6)
                end

                local particle = ParticleManager:CreateParticle("particles/econ/items/storm_spirit/strom_spirit_ti8/gold_storm_spirit_ti8_overload_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
                ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
                ParticleManager:SetParticleControl(particle, 1, Vector(radius,radius,radius))

                StartSoundEvent("Hero_Invoker.EMP.Discharge", caster)

                mod:SetStackCount(0)
                local cooldown = ability:GetEffectiveCooldown(level)
	            ability:StartCooldown(cooldown)
            end
        end
    end
end