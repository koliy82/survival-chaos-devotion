LinkLuaModifier( "units_core_mod", "units_core.lua", LUA_MODIFIER_MOTION_NONE )
units_core = class({})

function units_core:GetIntrinsicModifierName()
	return "units_core_mod"
end

units_core_mod = class({})

-- [SCD-FIX] Создавать ли декоративные пропы (def_wearables из races.kv) на НЕ-героях.
-- false = оптимизация включена, true = вид как в оригинале. Обоснование и цифры --
-- у блока war_table ниже.
_G.SCD_CREEP_COSMETICS = false

function units_core_mod:OnCreated( kv )
    if IsServer() then
        local caster = self:GetCaster()
        local unit_name = caster:GetUnitName()
        local id = caster:GetPlayerOwnerID()
        -- print(id)
        if id == -1 then
            id = 0
        end
        
        Timers:CreateTimer(0, function()
            if _G.playersinfo[id].unitsinfo[unit_name].store_model then
                caster:SetModel(_G.playersinfo[id].unitsinfo[unit_name].store_model)
                caster:SetOriginalModel(_G.playersinfo[id].unitsinfo[unit_name].store_model)
            end
            if _G.playersinfo[id].unitsinfo[unit_name].store_model_scale then
                caster:SetModelScale(_G.playersinfo[id].unitsinfo[unit_name].store_model_scale)
            end
            local war_table = _G.playersinfo[id].unitsinfo[unit_name].store_wearables or _G.playersinfo[id].unitsinfo[unit_name].def_wearables
            -- [SCD-FIX] Косметика НЕ-героев отключена. Замер 07.11 (duos, 4 игрока,
            -- настоящий SpawnUnits): на каждого крипа навешивалось ~2.6 prop_dynamic
            -- (в races.kv 50 не-геройских блоков def_wearables по 4-5 предметов).
            -- 282 крипа -> 731 проп -> клиентский FPS 14.5; после снятия 717 слотов
            -- 303 крипа -> 126 пропов -> FPS 21.6 (+49%) и ~20.2 ещё три минуты.
            -- Геймплей не меняется: пропы декоративные, урон/HP/броня/способности
            -- задаются ниже из races.kv. Утечки на смерть нет (пропы умирают вместе с
            -- владельцем: после ForceKill 369 крипов пропов стало 111, сирот 0),
            -- поэтому стоимость пропорциональна числу ЖИВЫХ крипов.
            -- Герои косметику СОХРАНЯЮТ. Критерий -- ИМЯ, а не только IsRealHero():
            -- герои рас объявлены в npc_units_custom.txt как npc_dota_<race>_hero_*
            -- и относятся к npc_dota_creature, поэтому IsRealHero() ("настоящий герой
            -- Dota") для них, скорее всего, false -- по нему фикс срезал бы косметику
            -- и с героев тоже. Сверка npc_units_custom.txt с races.kv: units_core висит
            -- на 95 юнитах с "_hero" в имени и на 163 без него; def_wearables есть у
            -- 77 героев и 50 НЕ-героев, причём все 77 содержат "_hero". То есть
            -- признак разделяет множества точно. IsRealHero() оставлен страховкой.
            if war_table ~= nil and (_G.SCD_CREEP_COSMETICS
                    or string.find(unit_name, "_hero", 1, true)
                    or (caster.IsRealHero and caster:IsRealHero())) then
                Wearable:WearDefaults(caster)
                for _, wearable in pairs(war_table) do
                    Wearable:Wear(caster, wearable)
                end
            end
            caster:FixAnims()
        end)


        -- if not id then
        --     id = caster:GetPlayerID()
            -- caster:SetBaseMaxHealth(_G.playersinfo[id].unitsinfo[unit_name].health)
        -- else
        -- end
        -- print("units_core")
        self:SetStackCount(id)
        caster:SetBaseDamageMin(_G.playersinfo[id].unitsinfo[unit_name].min_damage)
        caster:SetBaseDamageMax(_G.playersinfo[id].unitsinfo[unit_name].max_damage)
        caster:SetBaseManaRegen(caster:GetManaRegen() + (_G.playersinfo[id].unitsinfo[unit_name].bonus_mana_regen or 0))
        caster:SetBaseHealthRegen(caster:GetBaseHealthRegen() + (_G.playersinfo[id].unitsinfo[unit_name].bonus_health_regen or 0))
        if caster.mana then
            caster.mana = caster.mana + _G.playersinfo[id].unitsinfo[unit_name].mana
        else
            caster.mana = _G.playersinfo[id].unitsinfo[unit_name].mana
        end
        caster:CalculateGenericBonuses()
        -- caster:SetManaGain(_G.playersinfo[id].unitsinfo[unit_name].mana)
        -- caster:CreatureLevelUp(1)
        -- caster:SetManaGain(0)
        -- caster:CreatureLevelUp(-1)
        Timers:CreateTimer(0, function()
            caster:SetPhysicalArmorBaseValue(_G.playersinfo[id].unitsinfo[unit_name].armor + caster:GetPhysicalArmorBaseValue())
            caster:SetMana(caster.mana)
            for k, v in pairs(_G.playersinfo[id].unitsinfo[unit_name].abilities) do
                local ability = caster:AddAbility(k)
                ability:SetLevel(v)
            end
            -- print(_G.playersinfo[id].unitsinfo[unit_name].health)
            if not caster:HasAbility("elite_unit_pass") then
                caster:SetBaseMaxHealth(_G.playersinfo[id].unitsinfo[unit_name].health)
                caster:SetMaxHealth(_G.playersinfo[id].unitsinfo[unit_name].health)
                caster:CalculateGenericBonuses()
                caster:SetHealth(_G.playersinfo[id].unitsinfo[unit_name].health)
            end
        end)
        if unit_name == "npc_dota_elves_siege" then
            caster:SetRenderColor(100, 255, 255)
        end
        if unit_name == "npc_dota_dragons_arme" then
            caster:SetRenderColor(107, 183, 255)
        end
    end
end

function units_core_mod:IsHidden()
    return true
end

-- function units_core_mod:CheckState()
-- 	local state = {}
-- 	state[MODIFIER_STATE_ROOTED] = true
--     state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
-- 	return state
-- end

function units_core_mod:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_MANA_BONUS
	}
	return funcs
end

function units_core_mod:GetModifierManaBonus()
    return self:GetCaster().mana
end