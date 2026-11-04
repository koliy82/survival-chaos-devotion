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
                local cooldown = ability:GetEffectiveCooldown(level)
	            ability:StartCooldown(cooldown)
                mod:SetStackCount(0)

                local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	            local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	            local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

                local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1  )
                local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1  )

                local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
	            for _,unit in ipairs(units) do
                    ability:ApplyDataDrivenModifier(caster, unit, "modifier_primordials_hero_pusher_passive_debuff", {})
                    ApplyCustomDamage(unit, caster, damage, 6)
                end

                ability:ApplyDataDrivenModifier(caster, caster, "modifier_primordials_hero_pusher_passive_cleave", {})

                local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_primal_beast/primal_beast_roar_aoe.vpcf", PATTACH_ABSORIGIN, caster)
                ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
                ParticleManager:SetParticleControl(particle, 1, Vector( radius, 1, 0 ))

                StartSoundEvent("Hero_PrimalBeast.Uproar.MaxStacks", caster)
                --caster:StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_3, 1.0)
            end
        end
    end
end