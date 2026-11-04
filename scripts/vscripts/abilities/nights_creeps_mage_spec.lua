function OnAttackLanded(event)
    local caster = event.caster
    local ability = event.ability
    local chance = event.chance

    if caster and RollPercentage(chance) then
        local level = ability:GetLevel()
        local abil1 = caster:FindAbilityByName("nights_creeps_mage_ice_cover")
        local abil2 = caster:FindAbilityByName("nights_creeps_mage_mark")
        local abil3 = caster:FindAbilityByName("nights_creeps_mage_ats")
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
            if abil3 then
                local cd_remain = abil3:GetCooldownTimeRemaining()
                abil3:EndCooldown()
                abil3:StartCooldown(cd_remain - cd_red)
            end
        end)
    end
end