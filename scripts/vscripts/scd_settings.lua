-- [SCD-FIX] Настройка «Улучшенная косметика автора» — выбор ХОСТА лобби на этапе расы.
--
-- ЗАЧЕМ. Фикс `5ff7086` не создаёт декоративные модели (`prop_dynamic`) на НЕ-героях:
-- их приходилось ~2.6 на крипа (у людей — 6.25), то есть при 300 крипах клиент рисовал
-- почти 800 лишних моделей. Владелец подтвердил замером на своей машине: при одинаковой
-- нагрузке (`scd_spawn_waves 20 0 1`) с косметикой ~7-8 FPS, без неё ~14-16.
-- Но это ВИД игры, поэтому выбор отдан хосту лобби, а не зашит жёстко: по умолчанию
-- косметика ВЫКЛЮЧЕНА (быстрее), галочка возвращает авторский вид.
--
-- СХЕМА.
--   клиент `selection_race.vjs_c`: показывает галочку ТОЛЬКО хосту, шлёт событие
--     `SCDSetCosmetics { enabled = <bool> }`;
--   сервер (этот файл): проверяет, что отправитель — хост, меняет
--     `_G.SCD_CREEP_COSMETICS` и публикует состояние в net-таблицу `SCD_Settings`,
--     чтобы галочка была одинаково верной у всех клиентов.
--
-- ПОЧЕМУ ОТПРАВИТЕЛЯ БЕРЁМ ИЗ `data.PlayerID`. Обёртка движка `Dynamic_Wrap` кладёт id
-- отправителя в `data.PlayerID` — это видно по авторскому `SCGameMode:SelectRace`,
-- который читает `data.PlayerID`, хотя клиент в `SelectRace()` шлёт только `race`.
-- Доверять полю из payload НЕЛЬЗЯ (клиент может прислать чужой id), поэтому берём именно
-- то, что положила обёртка, а при её отсутствии — отказываем.
--
-- Почему не отдельный ConVar клиента: клиентские конвары другим игрокам из аддона не
-- выставить, а решение должно применяться на СЕРВЕРЕ, до спавна крипов.
_G.SCD_Settings = _G.SCD_Settings or {}

local S = _G.SCD_Settings

S.NETTABLE = "SCD_Settings"
S.inited = false
S.hostPid = nil
S.displayed = nil
S.rejectedNoted = nil

function S:IsHost(pid)
    if pid == nil then return false end
    if self.hostPid == nil then return false end
    return pid == self.hostPid
end

function S:PublishCosmetics()
    local enabled = _G.SCD_CREEP_COSMETICS and true or false
    if self.displayed == enabled then return end
    self.displayed = enabled
    CustomNetTables:SetTableValue(self.NETTABLE, "cosmetics", { enabled = enabled })
end

function S:PublishHost()
    local pid = self.hostPid
    if pid == nil then return end
    CustomNetTables:SetTableValue(self.NETTABLE, "host", { pid = pid })
end

-- Хост лобби. GameRules:PlayerHasCustomGameHostPrivileges принимает дескриптор игрока;
-- строка есть в server.dll этой сборки (проверено поиском по бинарнику).
-- Если движок не дал привилегий никому (бывает у локально поднятого матча), считаем
-- хостом игрока 0 и пишем об этом в лог — иначе настройка была бы недоступна вообще.
-- Проход прямой, без return из pcall-замыкания: так понятнее, кто и почему выбран.
function S:DetectHost()
    local privilegesOk = true
    for pid = 0, 23 do
        if PlayerResource:IsValidPlayerID(pid) then
            local player = PlayerResource:GetPlayer(pid)
            if player then
                local ok, res = pcall(function()
                    return GameRules:PlayerHasCustomGameHostPrivileges(player)
                end)
                if not ok then
                    privilegesOk = false
                elseif res then
                    return pid, "privileges"
                end
            end
        end
    end
    if privilegesOk then
        -- Ни у кого нет привилегий: у локально поднятого матча хоста может не быть вовсе.
        return 0, "fallback-pid0"
    end
    return 0, "fallback-error"
end

function S:OnSetCosmetics(data)
    local pid = data and data.PlayerID
    local wanted = data and data.enabled
    if type(wanted) ~= "boolean" then
        wanted = (wanted == 1) or (wanted == "1") or (wanted == true)
    end

    if not self:IsHost(pid) then
        -- не хост: не меняем и сообщаем один раз на игрока, чтобы не спамить
        local key = tostring(pid)
        if self.rejectedNoted ~= key then
            self.rejectedNoted = key
            print("[SCD-FIX] косметика: игрок " .. tostring(pid) ..
                " попытался изменить настройку, но хост = " .. tostring(self.hostPid))
        end
        self:PublishCosmetics()
        return
    end

    _G.SCD_CREEP_COSMETICS = wanted
    self.displayed = nil            -- заставит PublishCosmetics отправить новое значение
    self:PublishCosmetics()
    print(string.format("[SCD-FIX] косметика: хост %s выставил enabled=%s (декоративные модели крипов %s)",
        tostring(pid), tostring(wanted),
        wanted and "СОЗДАЮТСЯ, вид как в оригинале" or "не создаются, быстрее"))
end

function S:Init()
    if self.inited then return end
    self.inited = true
    -- Dynamic_Wrap кладёт id отправителя в data.PlayerID (см. шапку файла)
    CustomGameEventManager:RegisterListener("SCDSetCosmetics", Dynamic_Wrap(S, "OnSetCosmetics"))
    self:PublishCosmetics()
    print("[SCD-FIX] косметика: слушатель SCDSetCosmetics зарегистрирован")
end

-- Вызывается из SCGameMode:OnThink (тик 0.2 с). Публикует только изменения.
function S:Think()
    self:Init()
    local pid, how = self:DetectHost()
    if pid ~= self.hostPid then
        self.hostPid = pid
        self:PublishHost()
        print("[SCD-FIX] косметика: хост лобби = игрок " .. tostring(pid) .. " (" .. tostring(how) .. ")")
    end
    self:PublishCosmetics()
end