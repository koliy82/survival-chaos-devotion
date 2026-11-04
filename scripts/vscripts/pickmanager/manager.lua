require('logger/logger')

PickManager = PickManager or {
    PreparePhase = 5,

    BanPhaseEnd = 0,
    PickPhaseEnd = 0,
    BanSpecPhaseEnd = 0,
    PickSpecPhaseEnd = 0,
    TimeForBan = 10,
    TimeToPickSpec = 0,
    PreparePhaseIsInProgress = "0",
    BanPhaseIsInProgress = "10",
    PickPhaseIsInProgress = "20",
    BanSpecPhaseIsInProgress = "30",
    PickSpecPhaseIsInProgress = "40",

    PickFinished = 0,

    PlayerCount = 0,

    PreGamePhase = 0,

    IsTournamentPick = false,
    IsBanSpec = false,

    PlayerVotes = { system = {}, ban_specs = {} },

    SCGameMode = {}
}

function phaseNameByID(phaseId)
    if phaseId == PickManager.PreparePhaseIsInProgress then
        return "prepare"
    elseif phaseId == PickManager.BanPhaseIsInProgress then
        return "ban"
    elseif phaseId == PickManager.PickPhaseIsInProgress then
        return "pick"
    elseif phaseId == PickManager.BanSpecPhaseIsInProgress then
        return "ban_spec"
    elseif phaseId == PickManager.PickSpecPhaseIsInProgress then
        return "pick_spec"
    end
    return "undefined"
end

function PickManager:Init(SCGameMode)
    self.PlayerCount = math.max(PlayerResource:GetPlayerCount(), 1)
    self.BanPhaseEnd = self.PreparePhase + self.PlayerCount * self.TimeForBan
    self.PickPhaseEnd = self.BanPhaseEnd + 5 + self.PlayerCount * self.TimeForBan
    self.BanSpecPhaseEnd = self.PickPhaseEnd + 5 + self.PlayerCount * self.TimeForBan
    self.PickSpecPhaseEnd = self.BanSpecPhaseEnd + 5 + self.PlayerCount * self.TimeForBan
    self.TimeToPickSpec = self.BanSpecPhaseEnd
    --self.PreGamePhase = self.PickSpecPhaseEnd + 20

    Log("self:Init GetPlayerCount" .. self.PlayerCount)
    self.PreGamePhase = self.PickSpecPhaseEnd

    self.PickFinished = self.BanSpecPhaseEnd
    CustomNetTables:SetTableValue("pickphase", "pickphase", { value = "0" })
    self.SCGameMode = SCGameMode
end

function PickManager:getMode()
    local tournamentVotes = 0
    local standardVotes = 0
    local noSpecBanVotes = 0
    local specBanVotes = 0
    DeepPrintTable(PickManager.PlayerVotes)

    for _, vote in pairs(PickManager.PlayerVotes["system"]) do
        if vote == "0" then
            standardVotes = standardVotes + 1
        end
        if vote == "1" then
            tournamentVotes = tournamentVotes + 1
        end
    end

    for _, vote in pairs(PickManager.PlayerVotes.ban_specs) do
        if vote == "0" then
            noSpecBanVotes = noSpecBanVotes + 1
        end
        if vote == "1" then
            specBanVotes = specBanVotes + 1
        end
    end

    Log("standardvotes " .. standardVotes)
    Log("tournamentvotes " .. tournamentVotes)
    Log("noSpecBanVotes " .. noSpecBanVotes)
    Log("specBanVotes " .. specBanVotes)

    self.IsTournamentPick = tournamentVotes > standardVotes
    self.IsBanSpec = specBanVotes > noSpecBanVotes

    if self.IsTournamentPick then
        GameRules:SetPreGameTime(self.PreGamePhase)
    else
        GameRules:SetPreGameTime(60)
    end
end

function PickManager:startPickPhase()
    Log("PickManager:startPickPhase" .. GameRules:GetDOTATime(false, false))
    Log("PickManager.PlayerCount: " .. self.PlayerCount)
    Log("PickManager.BanPhaseEnd: " .. self.BanPhaseEnd)
    Log("PickManager.PickPhaseEnd: " .. self.PickPhaseEnd)
    Log("PickManager.BanSpecPhaseEnd: " .. self.BanSpecPhaseEnd)
    Log("PickManager.PickSpecPhaseEnd: " .. self.PickSpecPhaseEnd)
    Log("PickManager.PickFinished: " .. self.PickFinished)
    Log("PickManager.PreGamePhase: " .. self.PreGamePhase)

--     Timers:CreateTimer(0.1, )

--     Timers:CreateTimer(PickManager.PreparePhase, function()


        if self.IsTournamentPick then
            PickManager.IsTournamentPick = true
            self.TimeToPickSpec = self.PickPhaseEnd
            if self.IsBanSpec then
                self.TimeToPickSpec = self.BanSpecPhaseEnd
            end
            PickManager:TournamentPick()
        else
            PickManager.PickPhaseEnd = 60
            self.PreGamePhase = 60
--             GameRules:FinishCustomGameSetup()

            PickManager:StandardPick()
        end

--         CreateTimer(self.PreGamePhase - 20, function()
--              setFaze(self.PickSpecPhaseIsInProgress)
--         end)

        --Log("PickManager.IsTournamentPick " .. PickManager.IsTournamentPick)
--     end)

end

function PickManager:setFaze(faze)
    print("set pick faze to ", faze)
    Log("time: " .. GameRules:GetDOTATime(false, true))

    CustomNetTables:SetTableValue("pickphase", "pickphase", { value = faze, isTournamentPick = self.IsTournamentPick })
end

function PickManager:shufflePlayerOrder()
    Msg("PickManager:shufflePlayerOrder")
    Log("PickManager:shufflePlayerOrder")
    local playerBets = {}

    for k = 0, PlayerResource:GetPlayerCount() do
        if PlayerResource:IsValidPlayer(k) then
            local bet = RandomInt(1, 100)
            print("playerBets player ", k, " bet: ", bet)
            table.insert(playerBets, tonumber(k), bet)
        end
    end

    table.sort(playerBets)

    print("playerBets", GameRules:GetDOTATime(false, true))
    print(playerBets)
    Log(playerBets)
    DeepPrintTable(playerBets)

    self.pickOrder = {}

    local i = 0
    for k, _ in pairs(playerBets) do
        print("player ", k, " order to ban is: ", i)
        Msg("PickManager: player " .. k .. " order to ban is: " .. i)
        Log("PickManager: player " .. k .. " order to ban is: " .. i)
        table.insert(self.pickOrder, k, i)
        i = i + 1
    end
end

-- data name: settingsName, value: value, playerId: Game.GetLocalPlayerID()
function PickManager:SettingsChange(data)
    Log("PickManager:SettingsChange " .. data.playerId .. " " .. data.name .. " " .. data.value)
    PickManager.PlayerVotes[data.name][data.playerId] = data.value
    Log(PickManager.PlayerVotes)
    PickManager:getMode()
end

function PickManager:StandardPick()
    self:setFaze(self.PickPhaseIsInProgress)
end

function CreateTimer(seconds, f)
    local curTime = GameRules:GetDOTATime(false, false)

    Timers:CreateTimer(seconds - curTime, function()
        f()
    end)
end

function PickManager:TournamentPick()
    Log("tournamentPick")

--     GameRules:GetGameModeEntity():SetDraftingBanningTimeOverride(200)
--     Timers:CreateTimer(PickManager.PreparePhase, setFaze(PickManager.PreparePhaseIsInProgress))
--     setFaze(self.BanPhaseIsInProgress)
    CreateTimer(self.BanPhaseEnd, function()
        self:setFaze(self.PickPhaseIsInProgress)
    end)
    CreateTimer(self.PickPhaseEnd, function()
        Log("end of pick phase")
        for k, _ in pairs(_G.playersinfo) do
            if _G.playersinfo[k].race == nil then
                local data = {}
                data.PlayerID = k
                data.race = RandomInt(1, _G.free_race_count)
                Log("player " .. k .. " havent chosen a race, so we choose for him: " .. data.race)

                self.SCGameMode:SelectRace(data)
            end
        end

    end)
    if self.IsBanSpec then
        CreateTimer(self.BanSpecPhaseEnd, function()
            self:setFaze(self.PickSpecPhaseIsInProgress)
        end)
    else
        CreateTimer(self.PickPhaseEnd, function()
            self:setFaze(self.PickSpecPhaseIsInProgress)
        end)
    end
    --Timers:CreateTimer(self.PickSpecPhaseEnd, setFaze("50"))

    CreateTimer(self.PreparePhase / 2, function()

        self:shufflePlayerOrder()

        function triggerPickPhase(timing, player, pickOrder, phase)
            curTime = GameRules:GetDOTATime(false, false)
            Log("self:triggerPickPhase curTime: " .. curTime)
            Timers:CreateTimer(timing + (self.TimeForBan * pickOrder) - curTime, function()
                print("player ", player, " time to ", phaseNameByID(phase))
                Log("player " .. player .. " time to ban")
                CustomNetTables:SetTableValue("pickphase", tostring(player), { value = phase, player = player, isTournamentPick = true })
                if phase == self.PickPhaseIsInProgress then
                    EmitAnnouncerSoundForPlayer("announcer_dlc_bristleback_bris_ann_pick_yr_04", player)
                else
                    EmitAnnouncerSoundForPlayer("announcer_dlc_clockwerk_announcer_ban_yr_01", player)
                end
            end)
        end
        for k, pickOrder in pairs(self.pickOrder) do
            triggerPickPhase(self.PreparePhase / 2, k, pickOrder, self.BanPhaseIsInProgress)
            triggerPickPhase(self.BanPhaseEnd, k, pickOrder, self.PickPhaseIsInProgress)
            Log("triggerPickPhase")
            Log(self.IsBanSpec)
            if self.IsBanSpec then
                triggerPickPhase(self.PickPhaseEnd, k, pickOrder, self.BanSpecPhaseIsInProgress)
            end
        end
    end)
end