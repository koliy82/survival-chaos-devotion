function OnSpellStart(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target

    if caster and target then 
        local abil1 = caster:FindAbilityByName("dragons_creeps_air_fireball")
        Timers:CreateTimer(0.01, function()
            if abil1 then
                local cd_remain = abil1:GetCooldownTimeRemaining()
                caster:GiveMana(abil1:GetManaCost(abil1:GetLevel()-1))
                abil1:EndCooldown()
                caster:CastAbilityOnPosition(target:GetAbsOrigin(), abil1, caster:entindex())
                Timers:CreateTimer(0.2, function()
                    abil1:EndCooldown()
                    abil1:StartCooldown(cd_remain)
                end)
            end
        end)
    end
end