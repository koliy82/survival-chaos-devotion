-- [SCD-FIX] / [SCD-DIAG] возврат золота за прерванный каст: телеметрия + защита от двойного
-- возврата. Через этот файл идёт 401 блок RunScript в KV - все channelled-способности БЕЗ
-- body-level ScriptFile (upgrade_ancient, upgrade_barrack и остальные).
--
-- ЧТО ДОКАЗАНО ЗАМЕРАМИ (7 архивов console.log* + 30 краш-дампов):
--   * за всю историю логов ровно ОДНО обращение к этому файлу: upgrade_ancient,
--     05.11 01:17:52, gold_before=750 -> gold_after=2000, то есть +1250 = цена 1-го уровня
--     (AbilityGoldCost "1250 2500 0", ReturnGold берёт GetGoldCost(GetLevel()-1) = элемент 0).
--     ОДИН enter на ОДНО прерывание, второго нет;
--   * все 6 строк "tower refund" в архивах пришли из фейл-ветки OnSpellStart, путь прерывания
--     канала башен не упражнялся ни разу;
--   * в краш-дампах маркеров dd_return_gold/tower refund нет вообще.
-- Значит утверждение "OnChannelInterrupted диспатчится дважды" НЕ ПОДТВЕРЖДЕНО: единственный
-- имеющийся замер показывает один диспатч. Выборка n=1, поэтому телеметрия ниже (счётчик #N)
-- и есть способ узнать правду в живом прогоне.
--
-- ПОСТОЯННОГО ФЛАГА (вида ability.scd_refunded) здесь НЕТ намеренно: сбрасывать его надо в
-- начале нового каста, а OnSpellStart этих способностей лежит в чужих файлах
-- (abilities/upgrade_ancient.lua, abilities/upgrade_barrack.lua, items/items_upgrades.lua) -
-- общего места нет. Не сброшенный флаг подавил бы ЗАКОННЫЙ возврат, а потерянный возврат
-- хуже двойного.
--
-- Вместо флага - короткое окно дедупликации по времени игры. Два диспатча ОДНОГО прерывания
-- приходят в одном кадре (единицы-десятки миллисекунд: серверный тик Dota 30 Гц = 0.033 с),
-- а законный повторный возврат требует нового каста: AbilityCooldown "1" у upgrade_ancient и
-- upgrade_barrack плюс время канала (30/60 с и 4 с), то есть не раньше ~1 с. Окно 0.25 с
-- примерно в 7 раз больше худшего разброса внутри одного кадра и в 4 раза меньше минимального
-- законного интервала - подавить законный возврат оно не может физически.
-- Ключ окна: тот же ЭКЗЕМПЛЯР способности (у трёх бараков три независимых upgrade_barrack)
-- + тот же caster + та же сумма. При ошибке возврата отметки снимаются.
local SCD_REFUND_DEDUPE_WINDOW = 0.25

function ReturnGold(event)
	-- [SCD-DIAG] телеметрия: enter #N / done #N / skipped #N / ERROR #N. Счётчик N живёт на
	-- экземпляре способности и растёт на КАЖДЫЙ вход (включая подавленный дедупликатором),
	-- поэтому по логам сразу видно, сколько раз движок дёрнул прерывание:
	-- "enter #1" + "done #1" и дальше тишина = один диспатч;
	-- "enter #1" + "done #1" + "skipped #2 (... 0.000 s ago)" = двойной диспатч, пойман.
	local ok, err = pcall(function()
		local ability = event and event.ability or nil
		local caster = event and event.caster or nil
		if ability == nil or caster == nil then
			print("[SCD-DIAG] dd_return_gold: skipped, event has no ability/caster")
			return
		end
		local name = ability:GetAbilityName()
		local casterIndex = caster:GetEntityIndex()
		local n = (ability.scd_refund_calls or 0) + 1
		ability.scd_refund_calls = n
		local gold = ability:GetGoldCost(ability:GetLevel() - 1)
		local now = GameRules:GetGameTime()
		local prev = ability.scd_last_refund_time
		if prev ~= nil
				and ability.scd_last_refund_caster == casterIndex
				and ability.scd_last_refund_gold == gold
				and (now - prev) < SCD_REFUND_DEDUPE_WINDOW then
			print("[SCD-DIAG] dd_return_gold: skipped #" .. n .. " (already refunded " .. tostring(gold)
				.. " gold " .. string.format("%.3f", now - prev) .. " s ago), ability=" .. tostring(name)
				.. " caster=" .. tostring(casterIndex))
			return
		end
		local id = caster:GetPlayerOwnerID()
		print("[SCD-DIAG] dd_return_gold: enter #" .. n .. ", ability=" .. tostring(name) ..
			" caster=" .. tostring(casterIndex) .. " gold_before=" .. PlayerResource:GetGold(id) ..
			" cost=" .. tostring(gold) .. " t=" .. string.format("%.3f", now))
		ability.scd_last_refund_time = now
		ability.scd_last_refund_caster = casterIndex
		ability.scd_last_refund_gold = gold
		local okRefund, errRefund = pcall(function()
			ability:ReturnGold()
		end)
		if not okRefund then
			-- возврат не состоялся - снимаем отметки, чтобы дедупликатор не подавил
			-- следующую законную попытку
			ability.scd_last_refund_time = nil
			ability.scd_last_refund_caster = nil
			ability.scd_last_refund_gold = nil
			print("[SCD-DIAG] dd_return_gold: ERROR #" .. n .. " " .. tostring(errRefund))
			return
		end
		print("[SCD-DIAG] dd_return_gold: done #" .. n .. ", gold_after=" .. PlayerResource:GetGold(id))
	end)
	if not ok then
		print("[SCD-DIAG] dd_return_gold: ERROR " .. tostring(err))
	end
end