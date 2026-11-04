function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()

    function ability:OnSpawnUnit(data)
        local unit = EntIndexToHScript(data.unit)
        if unit:GetPlayerOwnerID() == id then
            if not unit:IsCustomHero() then
            --    ability:ApplyDataDrivenModifier(caster, unit, "modifier_beastmen_ancient_regen_aura_hero_buff", {})
            --else
                local spawner_abil = EntIndexToHScript(data.spawner_ability)
                if spawner_abil:GetAbilityName() ~= "unit_barrack_core" then
                    ability:ApplyDataDrivenModifier(caster, unit, "modifier_beastmen_ancient_regen_aura_creep_buff", {})
                end
            end
        end
    end
    
    ListenToGameEvent('custom_spawn_unit', ability.OnSpawnUnit, ability)
end

function OnDestroy(event)
    local ability = event.ability

    StopListeningToAllGameEvents(ability)
end