if not PlayerTables then
  PlayerTables = class({})
end

function PlayerTables:start()
  self.tables = {}
  self.subscriptions = {}
  self.queue = {}
  self.queue_ready = {}

  CustomGameEventManager:RegisterListener("PlayerTables_Connected", Dynamic_Wrap(PlayerTables, "PlayerTables_Connected"))
  CustomGameEventManager:RegisterListener("PlayerTables_Ready", Dynamic_Wrap(PlayerTables, "PlayerTables_Ready"))
end

function PlayerTables:OnThink()
  local timer = 0.2
  if #PlayerTables.queue > 0 then
    for k,v in pairs(PlayerTables.queue) do
      if PlayerTables.queue_ready[v.playerid] then
        local player = PlayerResource:GetPlayer(v.playerid)
        CustomGameEventManager:Send_ServerToPlayer(player, v.key, v.data )
        PlayerTables.queue_ready[v.playerid] = false
        table.remove( PlayerTables.queue, k )
      end
    end
  end
  
	return timer
end

function PlayerTables:SendToPlayer(pid, player, key, data)

  local function splitByChunk(text, chunkSize)
    local s = {}
    for i=1, #text, chunkSize do
        s[#s+1] = text:sub(i,i+chunkSize - 1)
    end
    return s
  end

  local packs = splitByChunk(data.table, 400000)
  
  for k,v in ipairs(packs) do
    table.insert( PlayerTables.queue, {playerid = pid, key = key, data = {name = data.name, pack = v, pack_id = k, packs_count = #packs}} )
  end
end

function PlayerTables:PlayerTables_Ready(args)
  --print('PlayerTables_Ready')
  --PrintTable(args)

  local pid = args.PlayerID
  if not pid then
    return
  end
  
  PlayerTables.queue_ready[pid] = true
end

function PlayerTables:PlayerTables_Connected(args)
  --print('PlayerTables_Connected')
  --PrintTable(args)

  local pid = args.PlayerID
  if not pid then
    return
  end

  local player = PlayerResource:GetPlayer(pid)
  --print('player: ', player)

  if IsInToolsMode() then
    Timers:CreateTimer(3,function()
      PlayerTables.queue_ready[pid] = true
    end)
  else
    PlayerTables.queue_ready[pid] = true
  end

  for k,v in pairs(PlayerTables.subscriptions) do
    if v[pid] then
      if player then
        PlayerTables:SendToPlayer(pid, player, "pt_fu", {name=k, table=PlayerTables.tables[k]} )
      end
    end
  end
end

function PlayerTables:CreateTable(tableName, tableContents, pids)
  tableContents = tableContents or {}
  tableContents = json.encode(tableContents)
  pids = pids or {}

  if pids == true then
    pids = {}
    for i=0,DOTA_MAX_TEAM_PLAYERS-1 do
      pids[#pids+1] = i
    end
  end

  if self.tables[tableName] then
    print("[playertables.lua] Warning: player table '" .. tableName .. "' already exists.  Overriding.")
  end

  self.tables[tableName] = tableContents
  self.subscriptions[tableName] = {}

  for k,v in pairs(pids) do
    local pid = k
    if type(v) == "number" then
      pid = v
    end
    if pid >= 0 and pid < DOTA_MAX_TEAM_PLAYERS then
      self.subscriptions[tableName][pid] = true
      local player = PlayerResource:GetPlayer(pid)
      if player then
        PlayerTables:SendToPlayer(pid, player, "pt_fu", {name=tableName, table=tableContents} )
      end
    else
      print("[playertables.lua] Warning: Pid value '" .. pid .. "' is not an integer between [0," .. DOTA_MAX_TEAM_PLAYERS .. "].  Ignoring.")
    end
  end
end

function PlayerTables:DeleteTable(tableName)
  if not self.tables[tableName] then
    print("[playertables.lua] Warning: Table '" .. tableName .. "' does not exist.")
    return
  end

  local table = self.tables[tableName]
  local pids = self.subscriptions[tableName]

  for k,v in pairs(pids) do
    local player = PlayerResource:GetPlayer(k)
    if player then
      PlayerTables:SendToPlayer(k, player, "pt_fu", {name=tableName, table=nil} )
    end
  end

  self.tables[tableName] = nil
  self.subscriptions[tableName] = nil  
end

if not PlayerTables.tables then PlayerTables:start() end