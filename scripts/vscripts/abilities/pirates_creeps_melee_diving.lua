function OnAttacked(event)
    local caster = event.caster
    local ability = event.ability

    local level = ability:GetLevel()
    local need_hp = ability:GetLevelSpecialValueFor( "need_hp" , level - 1  )
    
    if ability:IsCooldownReady() and caster:GetHealthPercent() <= need_hp then
        ability:StartCooldown(ability:GetEffectiveCooldown(level))
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_pirates_creeps_melee_diving_invisible_buff", {})
        --if caster:HasModifier("modifier_pirates_creeps_melee_smokebomb_buff") then
            local spec_ability = caster:FindAbilityByName("pirates_creeps_melee_smokebomb")
            if spec_ability and spec_ability:GetLevel() > 0 then
                spec_ability:ApplyDataDrivenModifier(caster, caster, "modifier_pirates_creeps_melee_diving_buff", {})
            end
        --end
        
        local point = caster:GetAbsOrigin()

        ability.index = ParticleManager:CreateParticle("particles/units/heroes/hero_slark/slark_shadow_dance.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
        ParticleManager:SetParticleControlEnt(ability.index, 1, caster, PATTACH_POINT_FOLLOW, nil, point, true)
        ParticleManager:SetParticleControlEnt(ability.index, 3, caster, PATTACH_POINT_FOLLOW, "attach_eyeL", point, true)
        ParticleManager:SetParticleControlEnt(ability.index, 4, caster, PATTACH_POINT_FOLLOW, "attach_eyeR", point, true)
    end
end

function OnDestroy(event)
    local ability = event.ability

    ParticleManager:DestroyParticle( ability.index, false )
end