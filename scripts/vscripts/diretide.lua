LinkLuaModifier( "modifier_diretide_roshan", "modifiers/modifier_diretide_roshan.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_diretide_roshan_barrack", "modifiers/modifier_diretide_roshan.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_diretide_roshan_truesight", "modifiers/modifier_diretide_roshan.lua", LUA_MODIFIER_MOTION_NONE )
local diretide = {}

function diretide:BuyCandy(data)
    local id = data.PlayerID
    if not id or not _G.playersinfo[id].alive then return end
    local str_id = tostring(id)
    local price = CustomNetTables:GetTableValue("Diretide","price")
    if PlayerResource:GetGold(id) >= price.buy then
        local candys = CustomNetTables:GetTableValue("Diretide","candys")
        if _G.playersinfo[id].aura == "diretide_ancient_candys_aura" and _G.playersinfo[id].ancient then
            -- local abil = _G.playersinfo[id].ancient:FindAbilityByName("diretide_ancient_candys_aura")
            if RollPercentage(20) then
                PlayerResource:ModifyGold(id, -price.buy * 0.7, false, DOTA_ModifyGold_PurchaseConsumable)
                diretide:ChangePrice(price, 1)
            else
                PlayerResource:ModifyGold(id, -price.buy, false, DOTA_ModifyGold_PurchaseConsumable)
                diretide:ChangePrice(price, 1)
            end
        else
            PlayerResource:ModifyGold(id, -price.buy, false, DOTA_ModifyGold_PurchaseConsumable)
            if _G.playersinfo[id].race == 11 then
                diretide:ChangePrice(price, 1)
            end
        end
        candys[str_id] = candys[str_id] + 1
        CustomNetTables:SetTableValue("Diretide","candys",candys)
    end
end

function diretide:SellCandy(data)
    local id = data.PlayerID
    if not id or not _G.playersinfo[id].alive then return end
    local str_id = tostring(id)
    local candys = CustomNetTables:GetTableValue("Diretide","candys")
    if candys[str_id] > 0 then
        local price = CustomNetTables:GetTableValue("Diretide","price")
        PlayerResource:ModifyGold(id, price.sell, false, DOTA_ModifyGold_SellItem)
        candys[str_id] = candys[str_id] - 1
        if _G.playersinfo[id].race == 11 then
            diretide:ChangePrice(price, -1)
        end
        CustomNetTables:SetTableValue("Diretide","candys",candys)
    end
end

function diretide:UseCandyAbility(data)
    local id = data.PlayerID
    if not id then return end
    if data.code == "diretide_ancient_candy_abil1" or data.code == "diretide_ancient_candy_abil2" or data.code == "diretide_ancient_candy_abil3" then
        if _G.playersinfo[id].race == 11 and _G.playersinfo[id].alive and _G.playersinfo[id].ancient and _G.playersinfo[id].ancient:IsAlive() then
            if GameRules:GetDOTATime(false, false) > 0 then
                local str_id = tostring(id)
                local candys = CustomNetTables:GetTableValue("Diretide","candys")
                local abil = _G.playersinfo[id].ancient:FindAbilityByName(data.code)
                if abil:IsCooldownReady() then
                    local cost = abil:GetLevelSpecialValueFor( "candy_cost", abil:GetLevel() - 1 )
                    if candys[str_id] >= cost then
                        abil:CastAbility()
                        abil:StartCooldown(abil:GetCooldownTime())
                        candys[str_id] = candys[str_id] - cost
                        if _G.playersinfo[id].race == 11 then
                            diretide:ChangePrice(price, -cost)
                        end
                        CustomNetTables:SetTableValue("Diretide","candys",candys)
                    else
                        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "display_custom_error", { message = "not_enough_candy" })
                    end
                else
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "display_custom_error", { message = "dota_hud_error_ability_in_cooldown" })
                end
            end
        else

        end
    end
end

function diretide:ChangePrice(price, change) -- used in diretide_spec_soul_exchanger.lua
    --if change == 0 then return end
    --if not price then
    --    price = CustomNetTables:GetTableValue("Diretide","price")
    --end
    --price.buy = price.buy + 10 * change
    --price.sell = price.sell + 8 * change
	--CustomNetTables:SetTableValue("Diretide","price",price)
end

function diretide:StartGame()
	local player_race = {}
    diretide.diretide_race_count = 0
    diretide.roshans = {}
    for id, data in pairs(_G.playersinfo) do
        player_race[id] = data.race
        if data.race == 11 then
            data.ancient:AddAbility("diretide_ancient_candy_abil1"):SetLevel(1)
            data.ancient:AddAbility("diretide_ancient_candy_abil2"):SetLevel(1)
            data.ancient:AddAbility("diretide_ancient_candy_abil3"):SetLevel(1)
            diretide.diretide_race_count = diretide.diretide_race_count + 1
            local roshan = CreateUnitByName("npc_dota_diretide_roshan", Vector(0,0,0), true, nil, nil, DOTA_TEAM_NEUTRALS)
            roshan:AddNewModifier(data.ancient, nil, "modifier_diretide_roshan", {})
            roshan:AddNewModifier(roshan, nil, "modifier_diretide_roshan_truesight", {})
            roshan:AddActivityModifier("trickortreat")
            roshan.can_attack = false
            roshan.owner_id = id
            roshan.old_ids = {}

            function roshan:AIGoToPlayer()
                if not (roshan and roshan:IsAlive()) then return end
                roshan.ai_state = "move"
                roshan.target_id = diretide:GetRandomAlivePlayerIDForRoshan(roshan)
                if not roshan.target_id then
                    roshan:RemoveSelf()
                    diretide.roshans[roshan.owner_id] = nil
                    return
                end

                local gameEvent = {}
                gameEvent["player_id"] = roshan.target_id
                gameEvent["teamnumber"] = -1
                gameEvent["message"] = "#Combat_Message_move_roshan"
                FireGameEvent( "dota_combat_event_message", gameEvent )

                if not diretide.roshan_targets[roshan.target_id] then
                    diretide.roshan_targets[roshan.target_id] = {}
                end

                if not diretide.roshan_barrack_targets[roshan.target_id] then
                    diretide.roshan_barrack_targets[roshan.target_id] = 0
                end
                roshan.old_ids[roshan.target_id] = true
                roshan.target_pos = _G.playersinfo[roshan.target_id].ancient:GetAbsOrigin()
                for k, barack in pairs(_G.playersinfo[roshan.target_id].baracks) do
                    if not barack:IsAttackImmune() then
                        if k - 1 == diretide.roshan_barrack_targets[roshan.target_id] % #_G.playersinfo[roshan.target_id].baracks then
                            barack:AddNewModifier(data.ancient, nil, "modifier_diretide_roshan_barrack", {})
                            roshan.target_pos = barack:GetAbsOrigin()
                            break
                        end
                    end
                end
                diretide.roshan_barrack_targets[roshan.target_id] = diretide.roshan_barrack_targets[roshan.target_id] + 1
                roshan:MoveToPosition(roshan.target_pos)
                Timers:CreateTimer(1, function()
                    roshan:MoveToPosition(roshan.target_pos)
                end)
            end

            function roshan:AIWaitPlayer()
                if not (roshan and roshan:IsAlive()) then return end
                roshan:Stop()
                if _G.playersinfo[roshan.target_id].ancient and _G.playersinfo[roshan.target_id].ancient:IsAlive() then
                    roshan.ai_state = "wait"
                    roshan.start_wait = GameRules:GetDOTATime(false, false)
                    diretide.roshan_targets[roshan.target_id][roshan] = true
                    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(roshan.target_id), "OpenSelectAbil", {mode = "diretide"})
                    roshan:StartGesture(ACT_DOTA_CHANNEL_ABILITY_5)
                else
                    roshan:AIGoToPlayer()
                end
            end

            function roshan:AIAttackPlayer(id)
                if not (roshan and roshan:IsAlive()) then return end
                roshan.ai_state = "attack"
                roshan.start_attack = GameRules:GetDOTATime(false, false)
                roshan:SetModelScale(0.9)
                --roshan.can_attack = true
                local min_range = 999999
                local target = nil
                for _, barack in pairs(_G.playersinfo[id].baracks) do
                    if not barack:IsAttackImmune() then
                        local range = (roshan:GetAbsOrigin() - barack:GetAbsOrigin()):Length2D()
                        if range < min_range then
                            min_range = range
                            target = barack
                            barack:RemoveModifierByName("modifier_diretide_roshan_barrack")
                        end
                    end
                end
                
                if target then
                    target:AddNewModifier(roshan, nil, "modifier_diretide_roshan_barrack_curse", {Duration = 180})
                --else
                --    if _G.playersinfo[roshan.target_id].ancient and _G.playersinfo[roshan.target_id].ancient:IsAlive() then
                --        roshan:MoveToTargetToAttack(_G.playersinfo[roshan.target_id].ancient)
                --    else
                --        roshan:AIGoToPlayer()
                --    end
                end
            end

            function roshan:AIEatCandy()
                if not (roshan and roshan:IsAlive()) then return end
                roshan.ai_state = "eat"
                for _, barack in pairs(_G.playersinfo[roshan.target_id].baracks) do
                    if barack then
                        barack:RemoveModifierByName("modifier_diretide_roshan_barrack")
                    end
                end
                -- roshan:SetModelScale(0.9)
                Timers:CreateTimer(9.8, function()
                    Timers:CreateTimer(0.4, function()
                        roshan:AIGoToPlayer()
                    end)
                    roshan:FadeGesture(ACT_DOTA_CHANNEL_ABILITY_7)
                end)
                roshan:StartGesture(ACT_DOTA_CHANNEL_ABILITY_7)
            end

            local AIThink = function()
                if roshan:IsNull() then return end
                if not roshan:IsAlive() then return end

                if roshan.ai_state == "move" then
                    local pos = roshan:GetAbsOrigin()
                    if (roshan.target_pos - pos):Length2D() < 340 then
                        roshan:AIWaitPlayer()
                    end
                end
                if roshan.ai_state == "wait" then
                    if GameRules:GetDOTATime(false, false) - roshan.start_wait >= 10 then
                        diretide.roshan_targets[roshan.target_id][roshan] = nil
                        local hide = true
                        for rosh, _ in pairs(diretide.roshan_targets[roshan.target_id]) do
                            hide = false
                            break
                        end
                        if hide then CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(roshan.target_id), "CloseSelectAbil", {}) end
                        roshan:AIAttackPlayer(roshan.target_id)
                    end
                end
                if roshan.ai_state == "attack" then
                    if GameRules:GetDOTATime(false, false) - roshan.start_attack >= 7 then
                        roshan.can_attack = false
                        roshan:SetModelScale(0.75)
                        roshan:AIGoToPlayer()
                    end
                end
                return 0.1
            end

            roshan:SetContextThink( "AIThink", AIThink, 0.1 )

            diretide.roshans[id] = roshan
            Timers:CreateTimer(1, function() roshan:AIGoToPlayer() end)
        end
    end
	CustomNetTables:SetTableValue("Diretide","enable",{value = "true", player_race = player_race})
end

function diretide:OnPlayerDefeat(id)
    local candys = CustomNetTables:GetTableValue("Diretide","candys")
    local str_id = tostring(id)
    if _G.playersinfo[id].race == 11 then
        diretide:ChangePrice(nil, -candys[str_id])
    end
    
    if diretide.roshans[id] then
        
        if diretide.roshans[id].ai_state == "wait" then
            local hide = true
            for rosh, _ in pairs(diretide.roshan_targets[diretide.roshans[id].target_id]) do
                if rosh == diretide.roshans[id] then
                    diretide.roshan_targets[rosh.target_id][rosh] = nil
                else
                    hide = false
                    break
                end
            end
            if hide then CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(diretide.roshans[id].target_id), "CloseSelectAbil", {}) end
        end
        
        diretide.roshans[id]:RemoveSelf()
        diretide.roshans[id] = nil
    end
end

function diretide:GetRandomAlivePlayerIDForRoshan(roshan)
    local alive_players = {}
    local all_alive_players = {}
    local skip_owner = false
    for id, data in pairs(_G.playersinfo) do
        if data.alive and data.ancient and data.ancient:IsAlive() then
            if not roshan.old_ids[id] then
                if not (id == roshan.owner_id and _G.playersinfo[id].aura == "diretide_ancient_candys_aura") then
                    table.insert( alive_players, id )
                end
            end
            if id ~= roshan.target_id then
                if id == roshan.owner_id and _G.playersinfo[id].aura == "diretide_ancient_candys_aura" then
                    skip_owner = true
                else
                    table.insert( all_alive_players, id )
                end
            end
        end
    end
    if #alive_players <= 0 then
        if #all_alive_players <= 0 then
            if skip_owner then
                return roshan.owner_id
            else
                return nil
            end
        end
        roshan.old_ids = {}
        roshan.old_ids[roshan.target_id] = true
        alive_players = all_alive_players
    end
    return alive_players[RandomInt(1, #alive_players)]
end

function diretide:PayCandy(data)
    local id = data.PlayerID
    if not id then return end
    local need = false
    for rosh, _ in pairs(diretide.roshan_targets[id]) do
        need = true
        break
    end
    if not need then return end
    local candys = CustomNetTables:GetTableValue("Diretide","candys")
    local str_id = tostring(id)
    if candys[str_id] > 0 then
        candys[str_id] = candys[str_id] - 1
        local first = true
        local hide = true
        for rosh, _ in pairs(diretide.roshan_targets[id]) do
            if first then
                ProjectileManager:CreateTrackingProjectile( {
                    Target = rosh,
                    Source = _G.playersinfo[id].ancient,
                    Ability = nil,	
                    EffectName = "particles/hw_fx/hw_candy_projectile.vpcf",
                    iMoveSpeed = 400
                })
                diretide.roshan_targets[id][rosh] = nil
                if id == rosh.owner_id then
                    diretide:ChangePrice(nil, -1)
                else
                    candys[tostring(rosh.owner_id)] = candys[tostring(rosh.owner_id)] + 1
                    if _G.playersinfo[id].race ~= 11 then
                        diretide:ChangePrice(nil, 1)
                    end
                end
                rosh:AIEatCandy()
                first = false
            else
                hide = false
                break
            end
        end
        CustomNetTables:SetTableValue("Diretide","candys",candys)
        if hide then CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "CloseSelectAbil", {}) end
    else
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "display_custom_error", { message = "not_enough_candy" })
    end
end

function diretide:Init()
    diretide.roshan_targets = {}
    diretide.roshan_barrack_targets = {}
	local candys = {}
    for i=0,PlayerResource:GetPlayerCount()-1 do
        diretide.roshan_targets[i] = {}
        diretide.roshan_barrack_targets[i] = 0
        candys[i] = 0
    end
	CustomNetTables:SetTableValue("Diretide","candys",candys)
	CustomNetTables:SetTableValue("Diretide","price",{buy = 100, sell = 80})
	CustomGameEventManager:RegisterListener("BuyCandy", Dynamic_Wrap(diretide, 'BuyCandy'))
    CustomGameEventManager:RegisterListener("SellCandy", Dynamic_Wrap(diretide, 'SellCandy'))
    CustomGameEventManager:RegisterListener("UseCandyAbility", Dynamic_Wrap(diretide, 'UseCandyAbility'))
    table.insert( _G.onstartgame, diretide )
end

diretide:Init()
return diretide