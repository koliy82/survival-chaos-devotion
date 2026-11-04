function OnAttackLanded(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    if level > 0 and target and not target:IsAncient() then
        local need_attack = ability:GetLevelSpecialValueFor( "need_attack" , level - 1  )
        local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1  )
        local stun_duration = ability:GetLevelSpecialValueFor( "stun_duration" , level - 1  )

        local mod = caster:FindModifierByName("modifier_nagas_hero_tank_bash")
        mod:SetStackCount(mod:GetStackCount()+1)
        if mod:GetStackCount() >= need_attack then
            mod:SetStackCount(0)
            target:EmitSound("Hero_Slardar.Bash")
            target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
            ApplyCustomDamage(target, caster, damage, caster.custom_damage_type, ability)
        end
    end
end