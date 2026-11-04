function OnAttackLanded(event)
    local caster = event.caster
    local ability = event.ability
    local chance = event.chance

    if caster and not caster:FindModifierByName("modifier_pirates_creeps_melee_ats_buff") and RollPercentage(chance) then 
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_pirates_creeps_melee_ats_buff", {})
        local level = ability:GetLevel()
        local maxstacks = ability:GetLevelSpecialValueFor( "max_stacks" , level - 1 )
        local mod = caster:FindModifierByName("modifier_pirates_creeps_melee_ats")
        if mod then
            mod:SetStackCount(maxstacks)
        end
        local abil1 = caster:FindAbilityByName("pirates_creeps_melee_smokebomb")
        local abil2 = caster:FindAbilityByName("pirates_creeps_melee_hook")
        local cd_red = ability:GetLevelSpecialValueFor("cd_red", level - 1)
        Timers:CreateTimer(0.01, function()
            if abil1 then
                local cd_remain = abil1:GetCooldownTimeRemaining()
                abil1:EndCooldown()
                abil1:StartCooldown(cd_remain - cd_red)
            end
            if abil2 then
                local cd_remain = abil2:GetCooldownTimeRemaining()
                abil2:EndCooldown()
                abil2:StartCooldown(cd_remain - cd_red)
            end
        end)
        local mana = ability:GetLevelSpecialValueFor( "mana" , level - 1 )
        caster:GiveMana(mana)
    end
end

function OnAttackLandedStacks(event)
    local caster = event.caster
    local ability = event.ability

    local mod = caster:FindModifierByName("modifier_pirates_creeps_melee_ats")
    if mod then
        local stacks = mod:GetStackCount()
        if stacks > 0 then
            mod:SetStackCount(stacks-1)
        else
            caster:RemoveModifierByName("modifier_pirates_creeps_melee_ats_buff")
        end
    end
end