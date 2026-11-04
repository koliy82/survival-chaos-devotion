function OnAttackLanded(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    if level > 0 and not caster:HasModifier("modifier_humans_creeps_range_rage_buff") then
        local need_attack = ability:GetLevelSpecialValueFor( "need_attack" , level - 1  )
        local mod = caster:FindModifierByName("modifier_humans_creeps_range_rage")
        mod:SetStackCount(mod:GetStackCount()+1)
        if mod:GetStackCount() >= need_attack then
            mod:SetStackCount(0)
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_humans_creeps_range_rage_buff", {})
        end
    end
end