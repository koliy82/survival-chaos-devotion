function FormRaceTable(race_table)

    local SplitToStrings = function(str)
        local arr = {}
        for v in string.gmatch(str, "[^%s]+") do
            table.insert( arr, v)
        end
        return arr
    end

    local SplitToNumbers = function(str)
        local arr = {}
        for v in string.gmatch(str, "[^%s]+") do
            table.insert( arr, tonumber(v))
        end
        return arr
    end

    local UnitOrBuildingUpdrage = function(unit_upgrade_data)
        if unit_upgrade_data.damage then
            unit_upgrade_data.damage = SplitToNumbers(unit_upgrade_data.damage)
        end
        if unit_upgrade_data.health then
            unit_upgrade_data.health = SplitToNumbers(unit_upgrade_data.health)
        end
        if unit_upgrade_data.health_regen then
            unit_upgrade_data.health_regen = SplitToNumbers(unit_upgrade_data.health_regen)
        end
        if unit_upgrade_data.mana then
            unit_upgrade_data.mana = SplitToNumbers(unit_upgrade_data.mana)
        end
        if unit_upgrade_data.mana_regen then
            unit_upgrade_data.mana_regen = SplitToNumbers(unit_upgrade_data.mana_regen)
        end
        if unit_upgrade_data.armor then
            unit_upgrade_data.armor = SplitToNumbers(unit_upgrade_data.armor)
        end
        if unit_upgrade_data.ats then
            unit_upgrade_data.ats = SplitToNumbers(unit_upgrade_data.ats)
        end
        if unit_upgrade_data.add_ability then
            unit_upgrade_data.add_ability = SplitToStrings(unit_upgrade_data.add_ability)
        end
        if unit_upgrade_data.upgrade_ability then
            unit_upgrade_data.upgrade_ability = SplitToStrings(unit_upgrade_data.upgrade_ability)
        end
        if unit_upgrade_data.wave_cd_red then
            unit_upgrade_data.wave_cd_red = SplitToNumbers(unit_upgrade_data.wave_cd_red)
        end
    end

    for _, race_name in pairs(race_table.races_names) do
        for _, upgrade_data in pairs(race_table[race_name].race_data.upgrades) do
            if upgrade_data.need_castle_level then
                upgrade_data.need_castle_level = SplitToNumbers(upgrade_data.need_castle_level)
            end

            if upgrade_data.gold_cost then
                for mod, gold_cost_str in pairs(upgrade_data.gold_cost) do
                    upgrade_data.gold_cost[mod] = SplitToNumbers(gold_cost_str)
                end
            end
            if upgrade_data.units then
                local i = 1
                while upgrade_data.units[tostring(i)] do
                    UnitOrBuildingUpdrage(upgrade_data.units[tostring(i)])
                    i = i + 1
                end
            end
            if upgrade_data.castle then
                UnitOrBuildingUpdrage(upgrade_data.castle)
            end
            if upgrade_data.towers then
                UnitOrBuildingUpdrage(upgrade_data.towers)
            end
            if upgrade_data.barracks then
                UnitOrBuildingUpdrage(upgrade_data.barracks)
            end
        end
        for _, upgrade_data in pairs(race_table[race_name].race_data.tower_upgrades) do
            if upgrade_data.need_castle_level then
                upgrade_data.need_castle_level = SplitToNumbers(upgrade_data.need_castle_level)
            end

            if upgrade_data.gold_cost then
                for mod, gold_cost_str in pairs(upgrade_data.gold_cost) do
                    upgrade_data.gold_cost[mod] = SplitToNumbers(gold_cost_str)
                end
            end
            if upgrade_data.units then
                local i = 1
                while upgrade_data.units[tostring(i)] do
                    UnitOrBuildingUpdrage(upgrade_data.units[tostring(i)])
                    i = i + 1
                end
            end
            if upgrade_data.castle then
                UnitOrBuildingUpdrage(upgrade_data.castle)
            end
            if upgrade_data.towers then
                UnitOrBuildingUpdrage(upgrade_data.towers)
            end
            if upgrade_data.barracks then
                UnitOrBuildingUpdrage(upgrade_data.barracks)
            end
        end
    end
    return race_table
end

function GCCollect()
    local m = collectgarbage('count')
    print(string.format("[Lua Memory]  %.3f KB  %.3f MB", m, m / 1024))
end