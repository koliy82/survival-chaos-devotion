if not PlayerTables then
  PlayerTables = class({})
end

-- [SCD-FIX] диагностический и защитный патч транспорта PlayerTables
-- причина патча: таблица "kvs" (способности/предметы/юниты с ценами) не доходит
-- до панорамы у части игроков -> тултипы без цен; подозрение на размер чанка
-- CustomGameEvent и на потерю подтверждений. Здесь: логи, pcall, retry,
-- правильная итерация очереди, уменьшенный чанк.
local PT_CHUNK = 60000      -- было 400000: слишком крупно для одного события
local PT_RETRY = 75         -- тиков без PlayerTables_Ready (5 тиков/с => ~15 сек) до повторной отправки
local PT_DIAG = true

local function ptlog(...)
  if PT_DIAG then
    local t = { "[PT]" }
    for _, v in ipairs({ ... }) do t[#t + 1] = tostring(v) end
    print(table.concat(t, " "))
  end
end

function PlayerTables:start()
  self.tables = {}
  self.subscriptions = {}
  self.queue = {}
  self.queue_ready = {}
  self.queue_sent = {}

  CustomGameEventManager:RegisterListener("PlayerTables_Connected", Dynamic_Wrap(PlayerTables, "PlayerTables_Connected"))
  CustomGameEventManager:RegisterListener("PlayerTables_Ready", Dynamic_Wrap(PlayerTables, "PlayerTables_Ready"))
end

function PlayerTables:OnThink()
  local timer = 0.2
  -- [SCD-FIX] собственный тик-счётчик: os.time() в Dota Lua VM не гарантирован
  PlayerTables._tick = (PlayerTables._tick or 0) + 1
  if #PlayerTables.queue > 0 then
    -- [SCD-FIX] итерация обратным порядком: table.remove внутри pairs() пропускает элементы
    local now = PlayerTables._tick
    local i = #PlayerTables.queue
    while i >= 1 do
      local v = PlayerTables.queue[i]
      local pid = v.playerid
      local sent = PlayerTables.queue_sent[pid] or 0
      if PlayerTables.queue_ready[pid] or (now - sent) > PT_RETRY then
        if (now - sent) > PT_RETRY and not PlayerTables.queue_ready[pid] then
          ptlog("retry pack", v.key, "pack_id", v.data and v.data.pack_id, "pid", pid, "age", now - sent)
        end
        local player = PlayerResource:GetPlayer(pid)
        if player then
          local ok, err = pcall(function()
            CustomGameEventManager:Send_ServerToPlayer(player, v.key, v.data)
          end)
          if not ok then
            ptlog("Send_ServerToPlayer FAILED:", err, "pid", pid, "pack bytes", #(v.data and v.data.pack or ""))
          end
          PlayerTables.queue_ready[pid] = false
          PlayerTables.queue_sent[pid] = now
          table.remove(PlayerTables.queue, i)
        else
          -- игрока нет: дропаем его очередь целиком, чтобы не копить мёртвые чанки
          table.remove(PlayerTables.queue, i)
        end
      end
      i = i - 1
    end
  end

  return timer
end

function PlayerTables:SendToPlayer(pid, player, key, data)

  local function splitByChunk(text, chunkSize)
    local s = {}
    for i = 1, #text, chunkSize do
      s[#s + 1] = text:sub(i, i + chunkSize - 1)
    end
    return s
  end

  if type(data.table) ~= "string" then
    ptlog("SendToPlayer ABORT: table is not a string (json.encode failed?), name=", data.name, "type=", type(data.table))
    return
  end

  local packs = splitByChunk(data.table, PT_CHUNK)
  ptlog("table", data.name, "size", #data.table, "bytes ->", #packs, "packs x", PT_CHUNK)

  for k, v in ipairs(packs) do
    table.insert(PlayerTables.queue, { playerid = pid, key = key, data = { name = data.name, pack = v, pack_id = k, packs_count = #packs } })
  end
end

function PlayerTables:PlayerTables_Ready(args)
  local pid = args.PlayerID
  if not pid then
    return
  end

  PlayerTables.queue_ready[pid] = true
  ptlog("client ready pid", pid)
end

function PlayerTables:PlayerTables_Connected(args)
  local pid = args.PlayerID
  if not pid then
    return
  end

  local player = PlayerResource:GetPlayer(pid)
  ptlog("client connected pid", pid, "has player", player ~= nil)

  if IsInToolsMode() then
    Timers:CreateTimer(3, function()
      PlayerTables.queue_ready[pid] = true
    end)
  else
    PlayerTables.queue_ready[pid] = true
  end

  for k, v in pairs(PlayerTables.subscriptions) do
    if v[pid] then
      if player then
        PlayerTables:SendToPlayer(pid, player, "pt_fu", { name = k, table = PlayerTables.tables[k] })
      end
    end
  end
end

function PlayerTables:CreateTable(tableName, tableContents, pids)
  tableContents = tableContents or {}
  local ok, encoded = pcall(json.encode, tableContents)
  if not ok or type(encoded) ~= "string" then
    -- [SCD-FIX] раньше json.encode падал/возвращал nil и валил колбэк состояния игры
    print("[SCD-FIX] CreateTable('" .. tableName .. "'): json.encode FAILED, table NOT sent. err=", tostring(encoded))
    return
  end
  tableContents = encoded
  pids = pids or {}

  if pids == true then
    pids = {}
    for i = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
      pids[#pids + 1] = i
    end
  end

  if self.tables[tableName] then
    print("[playertables.lua] Warning: player table '" .. tableName .. "' already exists.  Overriding.")
  end

  self.tables[tableName] = tableContents
  self.subscriptions[tableName] = {}

  ptlog("CreateTable", tableName, "json bytes", #tableContents)

  for k, v in pairs(pids) do
    local pid = k
    if type(v) == "number" then
      pid = v
    end
    if pid >= 0 and pid < DOTA_MAX_TEAM_PLAYERS then
      self.subscriptions[tableName][pid] = true
      local player = PlayerResource:GetPlayer(pid)
      if player then
        PlayerTables:SendToPlayer(pid, player, "pt_fu", { name = tableName, table = tableContents })
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

  for k, v in pairs(pids) do
    local player = PlayerResource:GetPlayer(k)
    if player then
      PlayerTables:SendToPlayer(k, player, "pt_fu", { name = tableName, table = nil })
    end
  end

  self.tables[tableName] = nil
  self.subscriptions[tableName] = nil
end

if not PlayerTables.tables then PlayerTables:start() end
