-- [SCD-FIX] идемпотентность возврата золота за прерванный каст.
--
-- Зачем: авторский CDOTABaseAbility:ReturnGold() (utils.lua) делает
-- SetGold(id, GetGold(id) + gold), то есть ПРИБАВЛЯЕТ к текущему золоту. Вызванный дважды на
-- одно прерывание, он вернул бы стоимость дважды - бесплатное золото. По AGENTS.md
-- OnChannelInterrupted у channelled-способностей диспатчится движком дважды; именно поэтому
-- в RefundTowerCast (abilities/tower_upgrades.lua) появился флаг scd_refunded. Через этот
-- файл идёт 401 блок RunScript в KV - все способности БЕЗ body-level ScriptFile
-- (upgrade_ancient, upgrade_barrack и остальные), поэтому защита нужна здесь.
--
-- Почему НЕ постоянный флаг: сбрасывать его надо в начале нового каста, а OnSpellStart этих
-- способностей лежит в чужих файлах (abilities/upgrade_ancient.lua, upgrade_barrack.lua,
-- items/items_upgrades.lua). Без сброса второй прерванный каст той же способности не вернул
-- бы НИЧЕГО, а потеря законного возврата хуже двойного.
--
-- Поэтому - окно дедупликации по времени игры. Двойной диспатч происходит в том же кадре
-- (единицы миллисекунд), а легитимный повторный возврат требует нового каста: у
-- upgrade_ancient/upgrade_barrack AbilityCooldown "1" плюс время канала (30/60 с и 4 с),
-- то есть не менее ~1 с. Окно 0.5 с ловит двойной диспатч и гарантированно не подавляет
-- законный возврат. Состояние живёт на экземпляре способности (у каждого барака свой
-- экземпляр upgrade_barrack), поэтому соседние постройки друг другу не мешают.
local SCD_REFUND_DEDUPE_WINDOW = 0.5

function ReturnGold(event)
	-- [SCD-DIAG] телеметрия сохранена и дополнена: enter/done/ERROR + skipped, чтобы в живом
	-- прогоне было видно и число диспатчей движка, и срабатывание дедупликатора
	local ok, err = pcall(function()
		local ability = event and event.ability or nil
		local caster = event and event.caster or nil
		if ability == nil or caster == nil then
			print("[SCD-DIAG] dd_return_gold: skipped, event has no ability/caster")
			return
		end
		local name = ability:GetAbilityName()
		local gold = ability:GetGoldCost(ability:GetLevel() - 1)
		local now = GameRules:GetGameTime()
		if ability.scd_last_refund_time ~= nil
				and ability.scd_last_refund_gold == gold
				and (now - ability.scd_last_refund_time) < SCD_REFUND_DEDUPE_WINDOW then
			print("[SCD-DIAG] dd_return_gold: skipped (already refunded " .. tostring(gold)
				.. " gold " .. string.format("%.3f", now - ability.scd_last_refund_time)
				.. " s ago), ability=" .. tostring(name))
			return
		end
		local id = caster:GetPlayerOwnerID()
		print("[SCD-DIAG] dd_return_gold: enter, ability=" .. tostring(name) ..
			" caster=" .. caster:GetEntityIndex() .. " gold_before=" .. PlayerResource:GetGold(id))
		ability.scd_last_refund_time = now
		ability.scd_last_refund_gold = gold
		local okRefund, errRefund = pcall(function()
			ability:ReturnGold()
		end)
		if not okRefund then
			-- возврат не состоялся - снимаем отметку, чтобы дедупликатор не подавил
			-- следующую законную попытку
			ability.scd_last_refund_time = nil
			ability.scd_last_refund_gold = nil
			print("[SCD-DIAG] dd_return_gold: ERROR " .. tostring(errRefund))
			return
		end
		print("[SCD-DIAG] dd_return_gold: done, gold_after=" .. PlayerResource:GetGold(id))
	end)
	if not ok then
		print("[SCD-DIAG] dd_return_gold: ERROR " .. tostring(err))
	end
end