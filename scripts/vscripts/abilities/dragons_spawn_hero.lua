-- [SCD-FIX] Раса «Драконы»: герои НЕ призывались из казарм вообще.
--
-- ПРИЧИНА. В npc_abilities_custom.txt у всех пяти способностей
-- spawn_hero_dragons_* событие OnSpellStart содержало ДВА блока RunScript:
--     1) hero_creater.lua            / SpawnUnit   -- СОЗДАЁТ героя
--     2) abilities/dragons_spawn_hero.lua / SpawnHero -- вешает расовый бонус на замок
-- Движок в этой кастомке выполняет только ПОСЛЕДНИЙ RunScript в событии (доказано
-- контролируемым экспериментом на «Артефактах», см. AGENTS.md и _dsh/RUNSCRIPT_DUPES.md).
-- То есть выполнялся SpawnHero, а SpawnUnit -- никогда, и герой не появлялся.
--
-- МАСШТАБ. Из 90 способностей spawn_hero_* ровно 85 имеют ОДИН RunScript (SpawnUnit)
-- и работают нормально. Отличаются только 5 драконьих -- ровно та раса, на которую
-- пожаловался владелец.
--
-- РЕШЕНИЕ. В KV оставлен ОДИН RunScript, указывающий на этот файл, а SpawnUnit
-- вызывается отсюда явно. Так логика драконов остаётся в файле драконов, и общий
-- hero_creater.lua (его используют все 90 способностей) не трогается вовсе.
--
-- ПОЧЕМУ ЧЕРЕЗ require. ScriptFile у datadriven выполняется в ОТДЕЛЬНОМ окружении:
-- его функции не попадают в _G (замер: type(Init)=="function", но _G.Init==nil).
-- require('hero_creater') выполняет файл в обычном окружении, после чего SpawnUnit
-- становится настоящим глобалом и его можно вызвать. Это безопасно: в
-- hero_creater.lua нет ни top-level локальных переменных, ни return, ни условного
-- кода -- только четыре определения функций (_G.SCD_HeroItemsEnabled,
-- _G.SCD_AttachHeroItems, _G.SCD_GiveRandomItem и SpawnUnit), поэтому повторная
-- загрузка ничего не ломает и идемпотентна.
local function SCD_GetSpawnUnit()
	if type(_G.SpawnUnit) == "function" then
		return _G.SpawnUnit
	end
	local ok, err = pcall(require, 'hero_creater')
	if not ok then
		print("[SCD-FIX] dragons SpawnHero: require('hero_creater') не удался: " .. tostring(err))
		return nil
	end
	if type(_G.SpawnUnit) ~= "function" then
		print("[SCD-FIX] dragons SpawnHero: после require SpawnUnit не стал глобальным")
		return nil
	end
	return _G.SpawnUnit
end

function SpawnHero(event)
	-- [SCD-FIX] СНАЧАЛА призыв героя (то, что потерялось из-за второго RunScript),
	-- ПОТОМ расовый бонус. Порядок важен: бонус применяется к замку и не должен
	-- мешать появлению героя, а ошибка в нём не должна отменять призыв.
	local spawn = SCD_GetSpawnUnit()
	if spawn then
		local ok, err = pcall(spawn, event)
		if not ok then
			print("[SCD-FIX] dragons SpawnHero: SpawnUnit завершился ошибкой: " .. tostring(err))
		end
	else
		print("[SCD-FIX] dragons SpawnHero: SpawnUnit недоступен, герой НЕ призван")
	end

	local caster = event.caster
	local ability = event.ability
	local hero = event.hero

    local id = caster:GetPlayerOwnerID()
	if caster:GetLevel() >= event.barrack_level and _G.playersinfo[id].ancient and _G.playersinfo[id].ancient:GetLevel() >= event.ancient_level then
    	local race_bonus = _G.playersinfo[id].ancient:FindAbilityByName("dragons_race_bonus")
	
		if race_bonus then
			local level = race_bonus:GetLevel()
    	    if level > 0 then
				race_bonus:ApplyDataDrivenModifier(_G.playersinfo[id].ancient, _G.playersinfo[id].ancient, "modifier_dragons_race_bonus_"..hero.."_buff", {})
				if _G.playersinfo[id].ancient:FindAbilityByName("dragons_ancient_race_aura") then
					race_bonus:ApplyDataDrivenModifier(_G.playersinfo[id].ancient, _G.playersinfo[id].ancient, "modifier_dragons_race_bonus_"..hero.."_debuff", {})
				end
			end
		end
	end
end
