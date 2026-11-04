function OnAttackLanded(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()

    local need_attack = ability:GetLevelSpecialValueFor( "need_attack" , level - 1  )
    local mod = caster:FindModifierByName("modifier_pirates_creeps_range_ats")
    if mod then
        mod:SetStackCount(mod:GetStackCount() + 1 )
        if mod:GetStackCount() >= need_attack then
            mod:SetStackCount(0)
            local stun_duration = ability:GetLevelSpecialValueFor( "stun_duration" , level - 1  )
            if caster:HasModifier("modifier_pirates_creeps_range_ats_check") then
                caster:AddNewModifier(caster, ability, "modifier_disarmed", {Duration = stun_duration})
            end
            caster:RemoveModifierByName("modifier_pirates_creeps_range_ats")
            caster:RemoveModifierByName("modifier_pirates_creeps_range_ats_buff")
            caster:RemoveModifierByName("modifier_pirates_creeps_range_ats_check")
        end
    end
end