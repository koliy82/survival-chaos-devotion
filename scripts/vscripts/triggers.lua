function cornertrigger(trigger)
    local activator = trigger.activator
    if activator.previous_point == nil then return end
    local nowpoint = tonumber(string.sub(trigger.caller:GetName(), -1))
    if activator.previous_point == nowpoint then return end
    activator.first_point = false
    local patharray = {{},{},{},{},{},{},{},{},{}}
    patharray[1][2] = 8
    patharray[1][8] = 2
    patharray[2][1] = 3
    patharray[2][3] = 1
    patharray[3][2] = 4
    patharray[3][4] = 2
    patharray[4][3] = 5
    patharray[4][5] = 3
    patharray[5][4] = 6
    patharray[5][6] = 4
    patharray[6][5] = 7
    patharray[6][7] = 5
    patharray[7][6] = 8
    patharray[7][8] = 6
    patharray[8][1] = 7
    patharray[8][7] = 1
    
    patharray[2][9] = 3
    patharray[4][9] = 5
    patharray[6][9] = 7
    patharray[8][9] = 1
    
    patharray[9][2] = 6
    patharray[9][4] = 8
    patharray[9][6] = 2
    patharray[9][8] = 4

    if nowpoint == 9 then
        if _G.duos then
            patharray[9][8] = 4
            patharray[9][4] = 8
        else
            local point_to_team = {}
            point_to_team[8] = {DOTA_TEAM_CUSTOM_2,DOTA_TEAM_GOODGUYS,DOTA_TEAM_BADGUYS}
            point_to_team[6] = {DOTA_TEAM_GOODGUYS,DOTA_TEAM_BADGUYS,DOTA_TEAM_CUSTOM_1}
            point_to_team[4] = {DOTA_TEAM_BADGUYS,DOTA_TEAM_CUSTOM_1,DOTA_TEAM_CUSTOM_2}
            point_to_team[2] = {DOTA_TEAM_CUSTOM_1,DOTA_TEAM_CUSTOM_2,DOTA_TEAM_GOODGUYS}
            local teams = point_to_team[patharray[9][activator.previous_point]]
            local neednewtarget = false
            if _G.playersinfo[_G:GetPlayerIDByTeam(teams[2])] then
                if not _G.playersinfo[_G:GetPlayerIDByTeam(teams[2])].alive then
                    neednewtarget = true
                end
            else
                neednewtarget = true
            end
            if neednewtarget then
                local point = 0
                local team_to_point = {}
                team_to_point[DOTA_TEAM_GOODGUYS] = 8
                team_to_point[DOTA_TEAM_BADGUYS] = 6
                team_to_point[DOTA_TEAM_CUSTOM_1] = 4
                team_to_point[DOTA_TEAM_CUSTOM_2] = 2
                if _G.playersinfo[_G:GetPlayerIDByTeam(teams[1])] and _G.playersinfo[_G:GetPlayerIDByTeam(teams[1])].alive then
                    point = team_to_point[teams[1]]
                else
                    if _G.playersinfo[_G:GetPlayerIDByTeam(teams[3])] and _G.playersinfo[_G:GetPlayerIDByTeam(teams[3])].alive then
                        point = team_to_point[teams[3]]
                    end
                end
                if point ~= 0 then
                    patharray[9][activator.previous_point] = point
                end
            end
        end
    end

    -- print( '********trigger event************' )
    -- for k, v in pairs(trigger) do
    --     print("DamageFilter: ",k, " ==> ", v)
    -- end
    -- DeepPrintTable(activator)
    -- DeepPrintTable(trigger.caller)
    --print(activator)
    if patharray[nowpoint][activator.previous_point] ~= nil then
        local nextpoint = Entities:FindByName( nil, "corner"..patharray[nowpoint][activator.previous_point]):GetCenter()
        -- activator:MoveToPositionAggressive(nextpoint)
        activator.to_point = nextpoint
        activator.previous_point = nowpoint
    end
end

function basetrigger(trigger)
    local activator = trigger.activator
    if activator:GetTeam() == DOTA_TEAM_NEUTRALS then return end
    if activator.previous_point == nil then
        local caller = trigger.caller
        local pointarray = {}
        pointarray["base_way_1_1"] = 8
        pointarray["base_way_1_2"] = 8
        pointarray["base_way_1_3"] = 8
        pointarray["base_way_2_1"] = 6
        pointarray["base_way_2_2"] = 6
        pointarray["base_way_2_3"] = 6
        pointarray["base_way_3_1"] = 4
        pointarray["base_way_3_2"] = 4
        pointarray["base_way_3_3"] = 4
        pointarray["base_way_4_1"] = 2
        pointarray["base_way_4_2"] = 2
        pointarray["base_way_4_3"] = 2

        if _G.duos then
            pointarray["base_way_3_1"] = 8
            pointarray["base_way_2_1"] = 4
            pointarray["base_way_2_2"] = 4
            pointarray["base_way_2_3"] = 4
            pointarray["base_way_4_1"] = 4
        end
        local patharray = {{},{},{}}
        patharray[1][2] = 9
        patharray[2][2] = 3
        patharray[3][2] = 1
        patharray[1][4] = 9
        patharray[2][4] = 5
        patharray[3][4] = 3
        patharray[1][6] = 9
        patharray[2][6] = 7
        patharray[3][6] = 5
        patharray[1][8] = 9
        patharray[2][8] = 1
        patharray[3][8] = 7
        -- print( '********trigger event************' )
        -- for k, v in pairs(trigger) do
        --     print("DamageFilter: ",k, " ==> ", v)
        -- end
        -- DeepPrintTable(activator)
        -- DeepPrintTable(caller)
        --print(activator)
        -- Timers:CreateTimer(0.5, function()
        --     print(caller)
        --     print(caller:GetName())
        --     print(pointarray[caller:GetName()])
            activator.previous_point = pointarray[caller:GetName()]
            local nextpoint = Entities:FindByName( nil, "corner"..patharray[tonumber(string.sub(caller:GetName(), -1))][activator.previous_point]):GetCenter()
            -- activator:MoveToPositionAggressive(nextpoint)
            activator.to_point = nextpoint
            activator.first_point = true
        -- end)
    elseif activator.first_point then
        -- activator.first_point = false
        local caller = trigger.caller
        local patharray = {{},{},{}}
        patharray[1][2] = 9
        patharray[2][2] = 3
        patharray[3][2] = 1
        patharray[1][4] = 9
        patharray[2][4] = 5
        patharray[3][4] = 3
        patharray[1][6] = 9
        patharray[2][6] = 7
        patharray[3][6] = 5
        patharray[1][8] = 9
        patharray[2][8] = 1
        patharray[3][8] = 7
        if caller then
            local caller_name = caller:GetName()
            if caller_name and caller_name ~= "" then
                local char_num = tonumber(string.sub(caller_name, -1))
                if patharray[char_num] and patharray[char_num][activator.previous_point] then
                    local entnextpoint = Entities:FindByName( nil, "corner"..patharray[char_num][activator.previous_point])
                    if entnextpoint then
                        activator.to_point = entnextpoint:GetCenter()
                    end
                end
            end
        end
    end
end

function building_holdout(trigger)
    local activator = trigger.activator
    if not activator then return end
    if activator:GetLevel() > 1 or activator:IsCustomHero() then
        local caller = trigger.caller
        local num = tonumber(string.sub(caller:GetName(), -1))
        if _G.additional_buildings[num]:GetTeam() ~= activator:GetTeam() then
            _G.additional_buildings[num]:SetNewCustomOwner(activator)
        end
    end
end