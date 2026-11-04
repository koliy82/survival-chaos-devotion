function OnAttackLanded(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    if level > 0 then
        local need_attack = ability:GetLevelSpecialValueFor( "need_attack" , level - 1  )
        local mod = caster:FindModifierByName("modifier_dwarfs_creeps_range_impetus")
        mod:SetStackCount(mod:GetStackCount()+1)
        if mod:GetStackCount() >= need_attack then
            mod:SetStackCount(0)
            local min_distance = ability:GetLevelSpecialValueFor( "min_distance" , level - 1  )
            local distance = (caster:GetOrigin()-target:GetOrigin()):Length2D()
            local damage_per_dist = ability:GetLevelSpecialValueFor( "damage" , level - 1  )
            if distance >= min_distance then
                ApplyCustomDamage(target, caster, damage_per_dist/100*(distance-min_distance), 6, ability)
                
                if target and not target:IsAncient() then
                    ability:ApplyDataDrivenModifier(caster, target, "modifier_dwarfs_creeps_range_impetus_debuff", {})
                end
            end
        end
    end
end