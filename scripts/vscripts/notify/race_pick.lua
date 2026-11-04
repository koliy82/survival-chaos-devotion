function racePick(playersinfo, all_specs, specs_count, data)
    return function()
        print('racePick')
--         DeepPrintTable(playersinfo)
        local id = data.PlayerID
        -- DeepPrintTable(all_specs)
        if specs_count <= #all_specs then
            --Timers:CreateTimer( BanSpecPhase - GameRules:GetDOTATime(false,false), function()
                if not (CustomNetTables:GetTableValue("bannedspecs", tostring(data.specId))) then
                playerInfo = playersinfo[id]
                    playerInfo.spec:AddAbility(all_specs[specs_count]):SetLevel(1)
                    specs_count = specs_count + 1
                    return 0.1
                end
            --end)
        else
            --_G.playersinfo[id].spec:AddAbility("forall_spec_anti_hero_towers"):SetLevel(1)
            -- _G.playersinfo[id].spec:AddAbility("forall_spec_spell_shield"):SetLevel(1)
            if data.race ~= 17 then playersinfo[id].spec:AddAbility("forall_spec_hero_items"):SetLevel(1) end

            --table.insert( all_specs, "forall_spec_anti_hero_towers" )
            if data.race ~= 17 then table.insert( all_specs, "forall_spec_hero_items" ) end
            --Timers:CreateTimer( BanSpecPhase - GameRules:GetDOTATime(false,false), function()
                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "building_selection_new", {
                    abilities = all_specs,
                    endTime = 90
                } )
            --end)

            print("halt")

            DeepPrintTable(all_specs)
            print(id)
            CustomGameEventManager:Send_ServerToAllClients("player_specs", {
                abilities = all_specs,
                id = id
            } )
        end
    end
end