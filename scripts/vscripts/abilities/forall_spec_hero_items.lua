-- [SCD-FIX] Дооснастить героев, созданных ДО выбора «Артефактов».
-- SpawnUnit (hero_creater.lua) навешивает метод GiveRandomItem только если флаг
-- items_spec уже стоял в момент создания героя, а сам флаг ставится здесь, в Init.
-- Поэтому без этого прохода герои, заспавненные раньше выбора спец-способности,
-- не собирали предметы ВОВСЕ и не начинали собирать потом - ровно та жалоба,
-- которую мы чиним. Идиома поиска своих героев взята из spec_items.lua:14-20.
local function SCD_RetrofitExistingHeroes(id)
    if type(_G.SCD_AttachHeroItems) ~= "function"
            or type(_G.SCD_HeroItemsEnabled) ~= "function" then
        -- hero_creater.lua ещё не загружался -> героев не создавали, оснащать нечего
        return 0
    end
    local info = _G.playersinfo and _G.playersinfo[id]
    if info == nil or info.spec == nil then
        return 0
    end
    local spec = info.spec
    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
            + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
    local units = FindUnitsInRadius(spec:GetTeam(), spec:GetAbsOrigin(), nil, 999999,
            DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
    local attached = 0
    for _, unit in pairs(units) do
        if unit ~= nil and not unit:IsIllusion()
                and unit:GetPlayerOwnerID() == id
                and unit:FindAbilityByName("hero_core") ~= nil then
            if _G.SCD_HeroItemsEnabled(id, unit:GetUnitName()) then
                if _G.SCD_AttachHeroItems(unit) then
                    attached = attached + 1
                end
            end
        end
    end
    return attached
end

-- [SCD-FIX] «Артефакты» не работали: движок выполняет ТОЛЬКО ПОСЛЕДНИЙ RunScript
-- в одном событии datadriven. В KV-блоке модификатора
-- modifiers_forall_spec_hero_items_pass событие OnCreated содержало ДВА RunScript:
-- первым шёл Init (именно он заполняет items_spec и net-таблицу Hero_Items),
-- вторым - AddBonusAbilities. Выполнялся только второй, поэтому Init не вызывался
-- НИКОГДА и герои не собирали предметы.
--
-- Доказано контролируемым экспериментом в живой игре (06.11.2026): после перестановки
-- блоков местами сработал Init, а AddBonusAbilities - нет. Замер также показал, что
-- ScriptFile выполняется в ОТДЕЛЬНОМ окружении: внутри него type(Init) == "function",
-- но _G.Init == nil, то есть функции файла не становятся глобалами и резолвятся
-- движком по имени внутри этого окружения.
--
-- AddBonusAbilities и RemoveBonusAbilities не существуют нигде в scripts/vscripts:
-- grep находит только AddBonusAbility / RemoveBonusAbility (ЕДИНСТВЕННОЕ число) в
-- abilities/spec_abilities.lua, и они требуют event.ability_name, которого этот KV
-- не передаёт. Обе ссылки мертвы у автора изначально, поэтому из KV удалены, а Init
-- оставлен единственным RunScript в OnCreated (пустой OnDestroy удалён целиком).
--
-- ВАЖНО ДЛЯ ПРОЕКТА: таких мест в npc_abilities_custom.txt 372 (реестр -
-- _dsh/RUNSCRIPT_DUPES.md, инструмент _dsh/audit_runscript_dupes.py). Среди
-- теряемых функций ReturnGold (306, возврат золота башен), SpawnUnit (6),
-- ApplyDamage (5), CustomCleaveAttack (2), MakeHeroIllusions и расовые апгрейды.
-- Здесь исправлено только то, что относится к «Артефактам»: массовая правка
-- включила бы давно не работающие механики и изменила бы баланс, поэтому она
-- требует решения владельца.
function Init(event)
    if not _G.spec_items then
        _G.spec_items = require( 'spec_items' )
    end
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    local invs = CustomNetTables:GetTableValue("Hero_Items",tostring(id))
    if invs == nil then
        invs = {}
    end
    local race_name = _G.racetable.races_names[tostring(_G.playersinfo[id].race)]
    invs["enable"] = 1
    if event.Hero then
        invs["heroes"] = {
            {event.Hero, event.HeroAbility}
        }
        _G.playersinfo[id].spec.items_spec = {
            [event.Hero] = true
        }
    else
        invs["heroes"] = {
            {"npc_dota_"..race_name.."_hero_tank", "spawn_hero_"..race_name.."_tank"},
            {"npc_dota_"..race_name.."_hero_mage", "spawn_hero_"..race_name.."_mage"},
            {"npc_dota_"..race_name.."_hero_asassin", "spawn_hero_"..race_name.."_asassin"},
            {"npc_dota_"..race_name.."_hero_pusher", "spawn_hero_"..race_name.."_pusher"}
        }
        _G.playersinfo[id].spec.items_spec = {
            ["npc_dota_"..race_name.."_hero_tank"] = true,
            ["npc_dota_"..race_name.."_hero_mage"] = true,
            ["npc_dota_"..race_name.."_hero_asassin"] = true,
            ["npc_dota_"..race_name.."_hero_pusher"] = true
        }
    end
    CustomNetTables:SetTableValue("Hero_Items", tostring(id), invs)
    -- [SCD-FIX] флаг стоит - теперь дооснащаем уже живых героев этого игрока.
    -- Печатаем один раз на выбор спец-способности, не в цикле.
    local attached = SCD_RetrofitExistingHeroes(id)
    print("[SCD-FIX] hero_items Init: player " .. tostring(id)
            .. " race " .. tostring(race_name)
            .. " heroes retrofitted " .. tostring(attached))
end