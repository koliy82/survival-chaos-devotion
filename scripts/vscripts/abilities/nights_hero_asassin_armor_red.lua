function OnAttackLanded(event)
    local target = event.target
    if target and target:IsAlive() then 
        local ability = event.ability
        local level = ability:GetLevel()
        local duration = ability:GetLevelSpecialValueFor( "duration" , level - 1  )
        local maxstacks = ability:GetLevelSpecialValueFor( "max_stacks" , level - 1  )
        local mod = target:FindModifierByName("modifier_nights_hero_asassin_armor_red_debuff")
        if mod then
            local stacks = mod:GetStackCount()
            if stacks < maxstacks then
                mod:SetStackCount(stacks+1)
                mod:SetDuration(duration, true)
            else
                mod:SetDuration(duration, true)
                local caster = event.caster
                local abil = caster:FindAbilityByName("nights_hero_asassin_ats")
                abil:ApplyDataDrivenModifier(caster, caster, "modifier_nights_hero_asassin_ats_buff", {duration = 3})
            end
        else
            ability:ApplyDataDrivenModifier(event.caster, target, "modifier_nights_hero_asassin_armor_red_debuff", {duration = duration}):SetStackCount(1)
        end
    end
end