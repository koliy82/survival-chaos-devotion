function OnAttackLanded(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()
    if level > 0 and ability:IsCooldownReady() then
        local need_attack = ability:GetLevelSpecialValueFor( "need_attack" , level - 1  )
        local mod = caster:FindModifierByName("modifier_nights_creeps_melee_crit")
        mod:SetStackCount(mod:GetStackCount() + 1)
        if mod:GetStackCount() >= need_attack then
            mod:SetStackCount(0)
            ability:StartCooldown(ability:GetEffectiveCooldown(level))
            
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_nights_creeps_melee_crit_buff", {})
        end
    end
end

function OnKill(keys)
    keys.ability:EndCooldown()
end