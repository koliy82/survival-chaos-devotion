function OnCreated( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability

    if target:HasAbility("invaders_hero_tank_chrono") then
        ability:ApplyDataDrivenModifier(caster, target, "modifier_invaders_hero_tank_chrono_buff", {})
    else
        ability:ApplyDataDrivenModifier(caster, target, "modifier_invaders_hero_tank_chrono_enemy", {})
    end
end

function OnDestroy( keys )
    local target = keys.target

    target:RemoveModifierByName("modifier_invaders_hero_tank_chrono_enemy")
end