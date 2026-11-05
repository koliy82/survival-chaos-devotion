function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
  end

-- [SCD-FIX] Общий возврат золота за несостоявшуюся покупку способности.
-- Делает ОБЕ операции, которые делает авторский CDOTABaseAbility:ReturnGold:
--   1) возвращает золото игроку;
--   2) вычитает его из _G.playerstats[id].goldspend.
-- Без второго шага "Счет" (goldspend + PlayerResource:GetGold(id) - та же формула, что
-- в Ends_Stats.gold и в поле networth net-таблицы SCD_TopBar) содержит возвращенную сумму
-- ДВАЖДЫ: один раз в невычтенном goldspend и второй раз в вернувшемся золоте.
-- Цену задает вызывающий код, потому что логика цены разная: башни читают
-- GetGoldCost(lvl-1) с откатом на GetGoldCost(lvl), "Мини взрыв" - GetGoldCost(lvl-1).
-- Возвращает реально возвращенную сумму (0, если возврат не состоялся).
-- DOTA_ModifyGold_Unspecified == 0, поэтому параметры ModifyGold совпадают с теми, что
-- были в обоих прежних местах возврата (tower_upgrades.lua и spec_abilities.lua).
function _G.SCD_RefundAbilityGold(ability, id, cost)
	if ability == nil or id == nil then
		return 0
	end
	cost = tonumber(cost)
	if cost == nil or cost <= 0 then
		return 0
	end
	if not PlayerResource:IsValidPlayerID(id) then
		return 0
	end
	PlayerResource:ModifyGold(id, cost, false, DOTA_ModifyGold_Unspecified)
	-- guard: _G.playerstats[id] создается в OnNPCSpawned и может отсутствовать
	local stats = nil
	if _G.playerstats ~= nil then
		stats = _G.playerstats[id]
	end
	if stats ~= nil then
		if type(stats.goldspend) == "number" then
			stats.goldspend = stats.goldspend - cost
		end
		-- суб-счетчики вычитаются только там, где они и начислялись
		-- (addon_game_mode.lua:933-938, ровно те же два условия), иначе уйдут в минус
		if ability.creep_spawn_item and type(stats.goldspend_to_summon_creeps) == "number" then
			stats.goldspend_to_summon_creeps = stats.goldspend_to_summon_creeps - cost
		end
		local ability_name = nil
		if ability.GetAbilityName ~= nil then
			ability_name = ability:GetAbilityName()
		end
		if ability_name ~= nil and string.find(ability_name, "spawn_hero_") ~= nil
				and type(stats.goldspend_to_summon_heroes) == "number" then
			stats.goldspend_to_summon_heroes = stats.goldspend_to_summon_heroes - cost
		end
	end
	return cost
end

function CDOTABaseAbility:ReturnGold()
    local caster = self:GetCaster()
    local id = caster:GetPlayerOwnerID()

    local gold = self:GetGoldCost(self:GetLevel()-1)
    -- [SCD-FIX] guard: GetGoldCost может вернуть nil, тогда арифметика ниже падала
    if type(gold) ~= "number" then
        gold = 0
    end
    PlayerResource:SetGold(id, PlayerResource:GetGold(id) + gold, false)
    -- [SCD-FIX] guard от nil-индексации: _G.playerstats[id] может не существовать
    -- (возврат до создания базы). Механику возврата золота НЕ меняем - она рабочая.
    local stats = nil
    if _G.playerstats ~= nil then
        stats = _G.playerstats[id]
    end
    if stats == nil then
        return
    end
    if type(stats.goldspend) == "number" then
        stats.goldspend = stats.goldspend - gold
    end
	if self.creep_spawn_item and type(stats.goldspend_to_summon_creeps) == "number" then
		stats.goldspend_to_summon_creeps = stats.goldspend_to_summon_creeps - gold
	end
	if string.find(self:GetAbilityName(), "spawn_hero_") ~= nil and type(stats.goldspend_to_summon_heroes) == "number" then
		stats.goldspend_to_summon_heroes = stats.goldspend_to_summon_heroes - gold
	end
end

function CDOTA_BaseNPC:FixAnims()
	local model_name = self:GetModelName()
	if model_name == "models/heroes/juggernaut/juggernaut.vmdl" then
		self:AddActivityModifier("run")
	elseif model_name == "models/heroes/snapfire/snapfire.vmdl" then
		self:AddActivityModifier("run")
	elseif model_name == "models/heroes/snapfire/snapfire_customgame.vmdl" then
		self:AddActivityModifier("run")
	elseif model_name == "models/heroes/void_spirit/void_spirit.vmdl" then
		self:AddActivityModifier("run")
	elseif model_name == "models/heroes/abyssal_underlord/abyssal_underlord_v2.vmdl" then
		self:AddActivityModifier("run")
	elseif model_name == "models/items/tiny/frozen_stonehenge/frozen_stonehenge_lvl_04.vmdl" then
		self:AddActivityModifier("tree")
		self:AddActivityModifier("ultimate_scepter")
	elseif model_name == "models/heroes/monkey_king/monkey_king.vmdl" then
		self:AddActivityModifier("run")
		self:AddActivityModifier("attack_normal_range")
	elseif model_name == "models/heroes/dawnbreaker/dawnbreaker.vmdl" then
		self:AddActivityModifier("run")
		self:AddActivityModifier("attack_long_range")
	elseif model_name == "models/heroes/mars/mars.vmdl" then
		self:AddActivityModifier("attack_close_range")
	elseif model_name == "models/heroes/siltbreaker/siltbreaker.vmdl" then
		self:AddActivityModifier("attack_close_range")
	elseif model_name == "models/heroes/troll_warlord/troll_warlord.vmdl" then
		self:AddActivityModifier("run")
	elseif model_name == "models/heroes/pangolier/pangolier.vmdl" then
		self:AddActivityModifier("run")
	elseif model_name == "models/items/wraith_king/arcana/wraith_king_arcana.vmdl" then
		self:AddActivityModifier("run")
	elseif model_name == "models/heroes/juggernaut/juggernaut_arcana.vmdl" then
		self:AddActivityModifier("run")
	elseif model_name == "models/heroes/crystal_maiden_persona/crystal_maiden_persona.vmdl" then
		self:AddActivityModifier("run")
	end
end

function CDOTA_BaseNPC:HaveCustomXP()
    return self.hero_xp ~= nil
end