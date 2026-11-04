function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()

    for k, v in pairs(_G.playersinfo[id].baracks) do
        ability:ApplyDataDrivenModifier(caster, v, "modifier_dwarfs_ancient_slow_aura_buff", {})
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        ability:ApplyDataDrivenModifier(caster, v, "modifier_dwarfs_ancient_slow_aura_buff", {})
    end
end

function OnAttackLandedActOnTargets(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target
    local damageprc = event.damage/100
    ApplyCustomDamage(target, caster, damageprc*caster:GetAttackDamage(), 6, ability)
end