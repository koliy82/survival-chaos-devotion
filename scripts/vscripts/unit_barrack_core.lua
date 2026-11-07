LinkLuaModifier( "unit_barrack_core_mod", "unit_barrack_core.lua", LUA_MODIFIER_MOTION_NONE )
unit_barrack_core = class({})

function unit_barrack_core:GetIntrinsicModifierName()
	return "unit_barrack_core_mod"
end

unit_barrack_core_mod = class({})

-- [SCD-FIX] Функция была ОБЪЯВЛЕНА ВНУТРИ BigThink, то есть переопределялась заново
-- КАЖДУЮ СЕКУНДУ на КАЖДОМ бараке (лишняя аллокация замыкания + запись в глобал).
-- Вынесена на уровень файла: определяется один раз при загрузке.
--
-- [SCD-FIX] УТЕЧКА ЧАСТИЦ. Исходный код создавал частицу всплывающего числа и НИКОГДА
-- не вызывал ни DestroyParticle, ни ReleaseParticleIndex. BigThink работает раз в
-- секунду на каждом бараке, поэтому за матч набегало:
--     1 частица/с * 3 барака * 4 игрока = 12/с = 720/мин = 43 200/час
-- Индексы частиц остаются занятыми навсегда, и их число растёт ПРОПОРЦИОНАЛЬНО
-- ВРЕМЕНИ ИГРЫ -- это ровно тот признак, который описал владелец («чем дольше
-- играешь, тем меньше FPS»). Правильный образец есть у самого автора:
-- hero_creater.lua:266-267 и unit_building_core.lua:32-33 освобождают индекс.
-- Одноразовые частицы от способностей так делать не обязаны -- эта утечка опасна
-- именно тем, что безусловная и периодическая.
function CustomFloatingText(unit, text, color)
    local particle = ParticleManager:CreateParticle(
        "particles/msg_fx/msg_number.vpcf",
        PATTACH_WORLDORIGIN,
        unit
    )
        -- Get position 200 units above the unit
    local pos = unit:GetAbsOrigin() + Vector(0, 0, 250)
    ParticleManager:SetParticleControl(particle, 0, pos)
    ParticleManager:SetParticleControl(particle, 1, Vector(0, tonumber(text), 0))
    ParticleManager:SetParticleControl(particle, 2, Vector(1, #tostring(text), 0))
    ParticleManager:SetParticleControl(particle, 3, color or Vector(255, 255, 255))
    -- [SCD-FIX] освобождаем индекс: частица одноразовая, её содержимое уже задано
    -- через контрольные точки, handle скрипту больше не нужен.
    ParticleManager:ReleaseParticleIndex(particle)
end

-- [SCD-FIX] ПРЕДОХРАНИТЕЛЬ ПРОТИВ ЛАВИНООБРАЗНОГО НАКОПЛЕНИЯ КРИПОВ.
--
-- ЗАЧЕМ. Замер в живой игре (duos, 4 игрока, волны по 100 крипов; клиентский кадр мерили
-- сэмплером в панораме через $.Schedule(0,...), серверный -- через GetGameFrameTime)
-- показал, что клиентский FPS зависит почти исключительно от числа ОДНОВРЕМЕННО ЖИВЫХ
-- юнитов:
--      68 живых -> 155..178 FPS      355 -> 28..60 FPS
--     160       ->  95..120          452 -> 18..28 FPS
--     252       ->  62..80           655 ->   8..12 FPS
--                                    ~755 ->  6..9   (владелец описывал «падает до 5»)
-- Серверный кадр при этом ВСЕГДА ровно 33.33 мс (30 тиков/с) и ни одного пропущенного
-- тика, даже при 1084 AIThink/с: серверная Lua успевает, узкое место -- рендер клиента.
--
-- ЧТО ПРОВЕРЕНО И НЕ ПОМОГЛО (чтобы не повторять эти ветки):
--   * NoHealthBar() на 479 юнитах -- FPS не изменился (22.8 -> 20.0, в пределах шума).
--     Хп-полосы узким местом НЕ являются.
--   * Прореживание тиков AI крипов x2 -- FPS не изменился (21.7 -> 21.1). Прежний замер
--     «+75%» оказался артефактом методики: там тело AI не выполнялось ВОВСЕ, крипы
--     переставали двигаться и атаковать. Это ломает игру, а не оптимизирует её.
--   * Утечек таймеров нет: периодические Timers:CreateTimer завершаются, вечные
--     (0.2 / 0.1 / 1 с) -- фиксированная стоимость, со временем не растущая.
--   * Серверный Lua не конкурирует с рендером: сервер ни разу не пропустил тик.
-- Единственный действенный рычаг -- не давать числу одновременно живых юнитов расти
-- бесконечно.
--
-- КАК РАБОТАЕТ. Порог задан по ВСЕЙ карте, а не на игрока: FPS зависит от общего числа
-- юнитов в кадре, а не от их принадлежности. Пока живых крипов меньше порога, поведение
-- ИДЕНТИЧНО оригинальному -- проверка стоит в начале SpawnUnits и ничего не меняет.
-- Выше порога волна пропускается ЦЕЛИКОМ, и спавн возобновляется сам, как только крипы
-- погибнут. Именно пропускается, а не урезается: урезание изменило бы состав волны и
-- баланс рас, а пропуск срабатывает только там, где игра уже неиграбельна по FPS.
--
-- Здания (npc_dota_custom_*) и герои (*_hero_*) в подсчёт не входят: их число ограничено
-- правилами игры и само по себе FPS не роняет.
--
-- НАСТРОЙКА. _G.SCD_CREEP_CAP_TOTAL = 300 соответствует измеренным 28..60 FPS.
-- Полное отключение: _G.SCD_CREEP_CAP_ENABLED = false.
_G.SCD_CREEP_CAP_ENABLED = true
_G.SCD_CREEP_CAP_TOTAL = 300

function _G.SCD_CountAliveCreeps()
    local n = 0
    local ok, list = pcall(function()
        return Entities:FindAllByClassname("npc_dota_creature")
    end)
    if not ok or not list then return n end
    for _, u in pairs(list) do
        if u.IsAlive and u:IsAlive() then
            local nm = u.GetUnitName and u:GetUnitName()
            if nm and not string.find(nm, "^npc_dota_custom_")
                    and not string.find(nm, "_hero_") then
                n = n + 1
            end
        end
    end
    return n
end

function unit_barrack_core_mod:StartGame()
    local caster = self:GetCaster()
    caster.creepspawnpoint = caster:GetAbsOrigin() + caster:GetForwardVector()*100
    caster.herospawnpoint = caster:GetAbsOrigin() - caster:GetForwardVector()*100
    if GetMapName() == "polygon" then return end
    caster.localtimer = caster.barrack_timer
    local mod = caster:FindModifierByName("unit_barrack_core_mod")
    mod:SetStackCount(caster.localtimer)
    self.endTime = GameRules:GetGameTime() + 1
    caster:SetThink("Think", self, "unit_barrack_core_mod", 0.1)
    --Timers:CreateTimer(function()
    --    local caster = self:GetCaster()
    --    if caster:IsAlive() and _G.playersinfo[caster:GetPlayerOwnerID()].alive then
    --        caster.localtimer = caster.localtimer - 1
    --        SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_MAGICAL_BLOCK, caster, caster.localtimer, caster:GetPlayerOwner())
    --        if caster.localtimer <= 0 then
    --            local status, err = pcall(self.SpawnUnits, self)--self:SpawnUnits()
    --            if not status then
    --                pcall(_G.HandleEventError, _G, unit_barrack_core_mod, "barrack_core", err)
    --            end
    --            caster.localtimer = caster.barrack_timer
    --        end
    --    end
    --    return 1.0
    --end)
    
    self:SpawnUnits()
    -- SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, caster, caster.localtimer, nil)
end

function unit_barrack_core_mod:Think()
    local now = GameRules:GetGameTime()
    if now >= self.endTime then
        local status, nextCall = pcall(self.BigThink, self)
        --self.endTime = self.endTime + 1
        if status then
            if nextCall then
                self.endTime = self.endTime + nextCall
                return 0.1
            end
            return 0.1
        else
            pcall(_G.HandleEventError, _G, self, "barrack_core_timer", nextCall)
        end
    else
        return 0.1
    end
    return 0.1
end

function unit_barrack_core_mod:BigThink()
    local caster = self:GetCaster()
    if caster:IsAlive() and _G.playersinfo[caster:GetPlayerOwnerID()].alive then
        caster.localtimer = caster.localtimer - 1
        local player = caster:GetPlayerOwner()
        -- if player then
        --     SendOverheadEventMessage(nill, OVERHEAD_ALERT_XP, caster, caster.localtimer, player)
        -- end


        local mod = caster:FindModifierByName("unit_barrack_core_mod")
        mod:SetStackCount(caster.localtimer)
        if caster.localtimer <= 0 then
            local status, err = pcall(self.SpawnUnits, self)--self:SpawnUnits()
            if not status then
                pcall(_G.HandleEventError, _G, unit_barrack_core_mod, "barrack_core", err)
            end
            caster.localtimer = caster.barrack_timer
        else
            -- [SCD-FIX] определение функции вынесено на уровень файла (см. выше):
            -- раньше оно выполнялось здесь каждый тик. Сама функция теперь
            -- освобождает индекс частицы, иначе за матч накапливались десятки тысяч.
            CustomFloatingText(caster, caster.localtimer, Vector(150, 150, 150))
        end
        --return 1
    end
    return 1
end

function unit_barrack_core_mod:SpawnUnits()
    local caster = self:GetCaster()
    -- [SCD-FIX] предохранитель против лавинообразного накопления крипов. Результаты
    -- замеров и отвергнутые варианты -- в комментарии к _G.SCD_CountAliveCreeps выше.
    if _G.SCD_CREEP_CAP_ENABLED and _G.SCD_CREEP_CAP_TOTAL then
        local alive = _G.SCD_CountAliveCreeps()
        if alive >= _G.SCD_CREEP_CAP_TOTAL then
            -- флаг ОБЩИЙ, а не на модификаторе: SpawnUnits вызывается на каждом бараке,
            -- и per-barrack флаг давал бы 9 одинаковых строк в консоль за один раунд
            -- (наблюдено в замере 03:29:52).
            if not _G.scd_creep_cap_noted then
                _G.scd_creep_cap_noted = true
                print(string.format(
                    "[SCD-FIX] creep cap: живых крипов %d >= порога %d, волны пропущены (спавн возобновится, когда крипы погибнут)",
                    alive, _G.SCD_CREEP_CAP_TOTAL))
            end
            return
        elseif _G.scd_creep_cap_noted then
            _G.scd_creep_cap_noted = nil
            print(string.format(
                "[SCD-FIX] creep cap: живых крипов %d < порога %d, спавн возобновлён",
                alive, _G.SCD_CREEP_CAP_TOTAL))
        end
    end
    local team = caster:GetTeam()
    local owner = caster:GetOwner()
    local function delayedSpawn(unitsToSpawn)
        for k, v in pairs(unitsToSpawn) do
            while v > 0 do
                v = v - 1
                local unit = CreateUnitByName(k, caster.creepspawnpoint, true, owner, owner, team)
                if unit:IsRangedAttacker() then
                    FindClearSpaceForUnit(unit, caster.herospawnpoint, false)
                end
                --if caster.mid_barrack and not _G.duos then
                --    unit:SetMinimumGoldBounty(unit:GetMinimumGoldBounty() * caster.mid_barrack_gold_bounty_mult)
                --    unit:SetMaximumGoldBounty(unit:GetMaximumGoldBounty() * caster.mid_barrack_gold_bounty_mult)
                --    unit:SetDeathXP(unit:GetDeathXP() * caster.mid_barrack_exp_bounty_mult)
                --end
                if caster:HasModifier("unit_destroyed_barrack_mod") and GameRules:GetDOTATime(false,false) <= 1200 then
                    unit:SetDeathXP(unit:GetDeathXP() * 0.2)
                    unit:SetMinimumGoldBounty(unit:GetMinimumGoldBounty() * 0.2)
                    unit:SetMaximumGoldBounty(unit:GetMaximumGoldBounty() * 0.2)
                end
                --FireGameEventLocal?
                FireGameEvent("custom_spawn_unit", {spawner_unit = caster:entindex(), spawner_ability = self:GetAbility():entindex(), unit = unit:entindex()})
            end
            --if v > 1 then
            --    unitsToSpawn[k] = v - 1
            --else
            --    unitsToSpawn[k] = nil
            --end
            --local unit = CreateUnitByName(k, caster.creepspawnpoint, true, owner, owner, team)
            --if unit:IsRangedAttacker() then
            --    FindClearSpaceForUnit(unit, caster.herospawnpoint, false)
            --end
            ----if caster.mid_barrack and not _G.duos then
            ----    unit:SetMinimumGoldBounty(unit:GetMinimumGoldBounty() * caster.mid_barrack_gold_bounty_mult)
            ----    unit:SetMaximumGoldBounty(unit:GetMaximumGoldBounty() * caster.mid_barrack_gold_bounty_mult)
            ----    unit:SetDeathXP(unit:GetDeathXP() * caster.mid_barrack_exp_bounty_mult)
            ----end
            --if caster:HasModifier("unit_destroyed_barrack_mod") and GameRules:GetDOTATime(false,false) <= 1200 then
            --    unit:SetDeathXP(unit:GetDeathXP() * 0.3)
            --end
            --FireGameEvent("custom_spawn_unit", {spawner_unit = caster:entindex(), spawner_ability = self:GetAbility():entindex(), unit = unit:entindex()})
            --if next then
            --    Timers:CreateTimer(0.1, function()
            --        delayedSpawn(unitsToSpawn)
            --    end)
            --end
            --return
        end
    end
    local unitsts = {}
    for k, v in pairs(caster.units) do
        unitsts[k] = v
    end
    delayedSpawn(unitsts)
    if caster.double_spawn then
        Timers:CreateTimer(1, function()
            self:SpawnUnits()
        end)
        caster.double_spawn = nil
    end
end

function unit_barrack_core_mod:OnCreated( kv )
    if IsServer() then
        self:GetCaster().barrack_timer = 45
        table.insert(_G.onstartgame, self)
    end
end

function unit_barrack_core_mod:IsHidden()
    --return true
    return false
end