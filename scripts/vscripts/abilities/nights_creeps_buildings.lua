function OnIntervalThink(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()
    local id = caster:GetPlayerOwnerID()

    if not GameRules:IsDaytime() then

        ability:ApplyDataDrivenModifier(caster, caster, "modifier_nights_creeps_buildings_regen", { Duration = 5 })--360sec

        for k, v in pairs(_G.playersinfo[id].baracks) do
            v:FindAbilityByName("spawn_hero_nights_tank"):SetLevel(level + 1)
            v:FindAbilityByName("spawn_hero_nights_mage"):SetLevel(level + 1)
            v:FindAbilityByName("spawn_hero_nights_asassin"):SetLevel(level + 1)
            v:FindAbilityByName("spawn_hero_nights_pusher"):SetLevel(level + 1)
            for i=0, 8 do
                local item = v:GetItemInSlot(i)
                if item and item.charge_restore_time then
                    item.charge_restore_time = item:GetSpecialValueFor("charge_restore_time") * (1 - event.charge_red / 100)
                end
            end
        end
    else
        for k, v in pairs(_G.playersinfo[id].baracks) do
            v:FindAbilityByName("spawn_hero_nights_tank"):SetLevel(1)
            v:FindAbilityByName("spawn_hero_nights_mage"):SetLevel(1)
            v:FindAbilityByName("spawn_hero_nights_asassin"):SetLevel(1)
            v:FindAbilityByName("spawn_hero_nights_pusher"):SetLevel(1)
            for i=0, 8 do
                local item = v:GetItemInSlot(i)
                if item and item.charge_restore_time then
                    item.charge_restore_time = item:GetSpecialValueFor("charge_restore_time")
                end
            end
        end
    end
end