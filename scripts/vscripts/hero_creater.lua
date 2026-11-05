-- [SCD-FIX] «Артефакты» (forall_spec_hero_items) не работали: герои не собирали
-- предметы. Причина - порядок и снимок состояния. Флаг items_spec читался ОДИН раз
-- в момент создания героя (SpawnUnit) и захватывался замыканием OnLevelChanged, а
-- сам метод GiveRandomItem определялся только если флаг УЖЕ стоял. Поэтому герои,
-- созданные ДО выбора спец-способности, не получали предметы вообще и не начинали
-- получать их потом (исключение - смерть героя и повторный спавн).
--
-- Теперь: (1) тело выдачи предмета - глобальная функция, (2) метод навешивается
-- отдельной функцией, которую Init из forall_spec_hero_items.lua зовёт и для уже
-- существующих героев, (3) проверка флага при выдаче на уровне - ЖИВАЯ.
--
-- Метод по-прежнему существует ТОЛЬКО у героев с включённым сбором: в
-- addon_game_mode.lua (OnEntityKilled) наличие v.GiveRandomItem используется как
-- признак права на предмет, и предмет выдаётся одному герою. Определи мы метод
-- всем и проверяй флаг внутри - первый же герой без «Артефактов» съедал бы выдачу.

-- Живая проверка: включён ли сбор предметов для героя данного игрока.
-- Guard'ы на nil обязательны: .spec и .items_spec существуют не всегда.
function _G.SCD_HeroItemsEnabled(id, unit_name)
    if id == nil or unit_name == nil then return false end
    local info = _G.playersinfo and _G.playersinfo[id]
    if info == nil then return false end
    local spec = info.spec
    if spec == nil then return false end
    local items_spec = spec.items_spec
    if items_spec == nil then return false end
    return items_spec[unit_name] == true
end

-- Навешивает метод выдачи предмета на героя. Идемпотентна: повторный вызов
-- ничего не делает. Возвращает true, если метод был добавлен этим вызовом.
function _G.SCD_AttachHeroItems(hero)
    if hero == nil then return false end
    if hero.GiveRandomItem ~= nil then return false end
    function hero:GiveRandomItem()
        return _G.SCD_GiveRandomItem(hero)
    end
    return true
end

-- Тело выдачи случайного предмета. Вынесено из замыкания SpawnUnit без изменения
-- логики: список предметов, классовые предметы и публикация инвентаря в
-- net-таблицу Hero_Items - авторские.
function _G.SCD_GiveRandomItem(hero)

    local unit_name = hero:GetUnitName()
    local items = {
        -- "item_spec_energy_booster",
        -- "item_spec_vitality_booster",
        -- "item_spec_sage_mask",
        -- "item_spec_chainmail",
        -- "item_spec_ring_of_regen",
        -- "item_spec_gloves",
        -- "item_spec_broadsword"
        "item_spec_ring_of_basilius",
        "item_spec_buckler",
        "item_spec_ring_of_tarrasque",
        "item_spec_point_booster",
        "item_spec_urn_of_shadows",
        "item_spec_crystalys",
        "item_spec_claymore"
    }
    local class_items = {
        tank = {"item_spec_chipped_vest","item_spec_crown","item_spec_cloak"},
        mage = {"item_spec_void_stone","item_spec_mystic_staff","item_spec_tome_of_knowledge"},
        asassin = {"item_spec_mithril_hammer","item_spec_crown","item_spec_void_stone"},
        pusher = {"item_spec_crown","item_spec_elven_tunic","item_spec_bogduggs_baldric"}
    }
    for hero_class, hero_class_items in pairs(class_items) do
        if string.find( unit_name, hero_class ) then

            for _, class_item_name in pairs(hero_class_items) do
                local Fffff = false
                
                for i=0,5 do
                    local item = hero:GetItemInSlot(i)
                    if item ~= nil then
                         -- if по каждому классовому предмету
                        if class_item_name == "item_spec_chipped_vest" then-- == название классового предмета
                            -- смотрим есть ли в инвенторе этот предмет с грейдами                                  
                            if item:GetAbilityName() == "item_spec_chipped_vest" then
                                Fffff = true
                            end
                            if item:GetAbilityName() == "item_spec_blade_mail" then
                                Fffff = true
                            end
                            if item:GetAbilityName() == "item_spec_arcanists_armor" then
                                Fffff = true
                            end
                            
                        end
                        if class_item_name == "item_spec_crown" then-- == название классового предмета
                            -- смотрим есть ли в инвенторе этот предмет с грейдами                                   
                            if item:GetAbilityName() == "item_spec_crown" then
                                Fffff = true
                            end
                            if item:GetAbilityName() == "item_spec_ultimate_orb" then
                                Fffff = true
                            end
                            if item:GetAbilityName() == "item_spec_apex" then
                                Fffff = true
                            end
                            
                        end
                        if class_item_name == "item_spec_cloak" then-- == название классового предмета
                            -- смотрим есть ли в инвенторе этот предмет с грейдами                                 
                            if item:GetAbilityName() == "item_spec_cloak" then
                                Fffff = true
                            end
                            if item:GetAbilityName() == "item_spec_hood_of_defiance" then
                                Fffff = true
                            end
                            if item:GetAbilityName() == "item_spec_pipe" then
                                Fffff = true
                            end
                        end
                        if class_item_name == "item_spec_void_stone" then-- == название классового предмета
                            -- смотрим есть ли в инвенторе этот предмет с грейдами                                
                            if item:GetAbilityName() == "item_spec_void_stone" then
                                Fffff = true
                            end
                            if item:GetAbilityName() == "item_spec_perseverance" then
                                Fffff = true
                            end
                            if item:GetAbilityName() == "item_spec_stormcrafter" then
                                Fffff = true
                            end
                        end
                        if class_item_name == "item_spec_mystic_staff" then-- == название классового предмета
                            -- смотрим есть ли в инвенторе этот предмет с грейдами                                
                            if item:GetAbilityName() == "item_spec_mystic_staff" then
                                Fffff = true
                            end
                            if item:GetAbilityName() == "item_spec_meteor_hammer" then
                                Fffff = true
                            end
                            if item:GetAbilityName() == "item_spec_scythe_of_vyse" then
                                Fffff = true
                            end
                        end
                        if class_item_name == "item_spec_tome_of_knowledge" then-- == название классового предмета
                            -- смотрим есть ли в инвенторе этот предмет с грейдами                                 
                            if item:GetAbilityName() == "item_spec_tome_of_knowledge" then
                                Fffff = true
                            end
                            if item:GetAbilityName() == "item_spec_necronomicon" then
                                Fffff = true
                            end
                            if item:GetAbilityName() == "item_spec_book_of_the_dead" then
                                Fffff = true
                            end
                        end
                        if class_item_name == "item_spec_mithril_hammer" then-- == название классового предмета
                            -- смотрим есть ли в инвенторе этот предмет с грейдами                                   
                            if item:GetAbilityName() == "item_spec_mithril_hammer" then
                                Fffff = true
                            end
                            if item:GetAbilityName() == "item_spec_skull_basher" then
                                Fffff = true
                            end
                            if item:GetAbilityName() == "item_spec_abyssal_blade" then
                                Fffff = true
                            end
                        end
                        if class_item_name == "item_spec_elven_tunic" then-- == название классового предмета
                            -- смотрим есть ли в инвенторе этот предмет с грейдами                                 
                            if item:GetAbilityName() == "item_spec_elven_tunic" then
                                Fffff = true
                            end
                            if item:GetAbilityName() == "item_spec_pelt_of_the_old_wolf" then
                                Fffff = true
                            end
                            if item:GetAbilityName() == "item_spec_assault_cuirass" then
                                Fffff = true
                            end
                        end
                        if class_item_name == "item_spec_bogduggs_baldric" then-- == название классового предмета
                            -- смотрим есть ли в инвенторе этот предмет с грейдами                                   
                            if item:GetAbilityName() == "item_spec_bogduggs_baldric" then
                                Fffff = true
                            end
                            if item:GetAbilityName() == "item_spec_unhallowed_icon" then
                                Fffff = true
                            end
                            if item:GetAbilityName() == "item_spec_watchers_gaze" then
                                Fffff = true
                            end
                        end

                    end
                end             

                if Fffff == false then
                    table.insert( items, class_item_name )
                end
            end
        end
    end
    -- [SCD-FIX] диагностика: одна строка на выдачу (событие редкое - каждый 4-й
    -- уровень героя и смерть вражеского героя), чтобы в живом прогоне отличить
    -- «флаг не выставился» от «выдача не сработала».
    local granted = items[RandomInt(1, #items)]
    hero:AddItemByName(granted)
    print("[SCD-FIX] hero_items grant: " .. tostring(hero:GetPlayerOwnerID())
            .. " " .. unit_name .. " lvl " .. tostring(hero:GetLevel())
            .. " -> " .. tostring(granted))

    local inventory = {}
    for i=0,5 do
        local item = hero:GetItemInSlot(i)
        if item ~= nil then
            inventory[tostring(i)] = item:GetAbilityName()
        end
    end
    local invs = CustomNetTables:GetTableValue("Hero_Items",tostring(hero:GetPlayerOwnerID()))
    if invs == nil then
        invs = {}
    end
    invs[unit_name] = inventory
    CustomNetTables:SetTableValue("Hero_Items", tostring(hero:GetPlayerOwnerID()), invs)
end

function SpawnUnit(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    local ability = event.ability
    local ability_name = ability:GetAbilityName()
    if caster:GetLevel() >= event.barrack_level and _G.playersinfo[id].ancient and _G.playersinfo[id].ancient:GetLevel() >= event.ancient_level then
        local team = caster:GetTeam()
        local owner = caster:GetOwner()
        local unit_name = event.unit_name

        -- [SCD-FIX] живая проверка вместо снимка (см. комментарий в начале файла)
        local items_spec = _G.SCD_HeroItemsEnabled(id, unit_name)

        local hero = CreateUnitByName(unit_name, caster.herospawnpoint, true, owner, owner, team)

        hero.ability = ability
        for k, v in pairs(_G.playersinfo[id].baracks) do
            v:FindAbilityByName(ability_name):SetActivated(false)
        end

        LinkLuaModifier( "modifier_heroes_phase", "modifiers/modifier_heroes_phase.lua", LUA_MODIFIER_MOTION_NONE )
        if not hero:IsRangedAttacker() then
            hero:AddNewModifier(caster, ability, "modifier_heroes_phase", { Duration = 7 })
        end

        function hero:OnLevelChanged(onspawn)
            local level = hero:GetLevel()
            local ability1 = hero:GetAbilityByIndex(0)
            if ability1 then
                ability1:SetLevel(math.min(math.floor((level+3)/4),4))
            end
            local ability2 = hero:GetAbilityByIndex(1)
            if ability2 then
                ability2:SetLevel(math.min(math.floor((level+2)/4),4))
            end
            local ability3 = hero:GetAbilityByIndex(2)
            if ability3 then
                ability3:SetLevel(math.min(math.floor((level+1)/4),4))
            end
            local ability4 = hero:GetAbilityByIndex(3)
            if ability4 then
                ability4:SetLevel(math.min(math.floor((level)/4),4))
            end
            local pfx = ParticleManager:CreateParticle("particles/econ/events/fall_2021/hero_levelup_fall_2021.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
            ParticleManager:ReleaseParticleIndex(pfx)
            
            if not onspawn and _G.SCD_HeroItemsEnabled(id, unit_name) then
                if level % 4 == 0 then
                    hero:GiveRandomItem()
                end
            end
        end

        function hero:AddCustomXP(xp_count)
            xp_count = xp_count * (hero.xp_mult or 1)
            hero.hero_xp = hero.hero_xp + xp_count
            local id = hero:GetPlayerOwnerID()
            local hero_name = hero:GetUnitName()
			local need = 100 * hero:GetLevel()
			while hero.hero_xp > need do
				hero.hero_xp = hero.hero_xp - need
				-- local oldmaxhp = hero:GetMaxHealth()
				local oldhpp = hero:GetHealthPercent()
				local oldmanap = hero:GetManaPercent()
				hero:CreatureLevelUp(1)
				hero.mana = hero.mana + _G.playersinfo[id].unitsinfo[hero_name].manapl
				if oldhpp <= 0 then
					oldhpp = 1
				end
				-- hero:SetHealth(oldhp + hero:GetMaxHealth() - oldmaxhp)
				hero:SetHealth(hero:GetMaxHealth() * oldhpp / 100)
				hero:SetMana(hero.mana * oldmanap / 100)
                hero:OnLevelChanged(false)
                local hero_level = hero:GetLevel()
                --Challenges:TriggerEvent(id, "hero_get_level", {hero_name = hero_name, level = hero_level})
				need = 100 * hero_level
                hero:CalculateGenericBonuses()
			end
			CustomNetTables:SetTableValue( 'Hero_Levels', tostring( hero:entindex() ), {
				xp = hero.hero_xp / need
			})
        end

        if items_spec then
            _G.SCD_AttachHeroItems(hero)
        end

        if _G.playersinfo[id].unitsinfo[unit_name].inventory ~= nil then
            for _, item_name in pairs(_G.playersinfo[id].unitsinfo[unit_name].inventory) do
                hero:AddItemByName(item_name)
            end
        end
        
        if _G.playersinfo[id].unitsinfo[unit_name].hero_xp == nil then
            _G.playersinfo[id].unitsinfo[unit_name].hero_xp = 0
        end

        --if items_spec then
        --    if _G.playersinfo[id].unitsinfo[unit_name].give_hero_item then
        --        hero:GiveRandomItem()
        --        _G.playersinfo[id].unitsinfo[unit_name].give_hero_item = false
        --    else
        --        _G.playersinfo[id].unitsinfo[unit_name].give_hero_item = true
        --    end
        --end

        hero.hero_xp = _G.playersinfo[id].unitsinfo[unit_name].hero_xp
        local needxp = 100
        local lvlup = 0
        while hero.hero_xp > needxp do
            lvlup = lvlup + 1
            hero.hero_xp = hero.hero_xp - needxp
            needxp = 100 + 100 * lvlup
        end
        
        Timers:CreateTimer(0.05, function()
            hero:CreatureLevelUp(lvlup)
            if hero.mana then
                hero.mana = hero.mana + _G.playersinfo[id].unitsinfo[unit_name].manapl * lvlup
            else
                hero.mana = _G.playersinfo[id].unitsinfo[unit_name].manapl * lvlup
            end
            hero:OnLevelChanged(true)
            
            if caster.mid_barrack and not _G.duos then
                hero:SetMinimumGoldBounty(hero:GetMinimumGoldBounty()*caster.mid_barrack_gold_bounty_mult)
                hero:SetMaximumGoldBounty(hero:GetMaximumGoldBounty()*caster.mid_barrack_gold_bounty_mult)
                hero:SetDeathXP(hero:GetDeathXP()*caster.mid_barrack_exp_bounty_mult)
            end

            CustomNetTables:SetTableValue( 'Hero_Levels', tostring( hero:entindex() ), {
                xp = hero.hero_xp / needxp
            })
            -- print("hero stats")
            -- print(hero:GetMaxHealth())
            -- print(hero:GetBaseMaxHealth())
            -- print(hero:GetHealth())
            -- print(hero.mana)
            hero:CalculateGenericBonuses()
            -- print(hero:GetMaxHealth())
            -- print(hero:GetBaseMaxHealth())
            -- print(hero:GetHealth())
            -- print(hero.mana)
            hero:SetMana(hero.mana)
        end)
        
        --Challenges:TriggerEvent(id, "spawn_hero", {hero_name = unit_name})
        FireGameEvent("custom_spawn_unit", {spawner_unit = caster:entindex(), spawner_ability = ability:entindex(), unit = hero:entindex()})
        Timers:CreateTimer(0.1, function()
            if caster:HasModifier("modifier_neutrals_buids_16_buff") then
                local cd_red = caster:FindModifierByName("modifier_neutrals_buids_16_buff"):GetStackCount()
                ability:EndCooldown()
                ability:StartCooldown( ability:GetCooldown(ability:GetLevel()-1) * (100 - cd_red) / 100 )
            end
        end)
        hero:CalculateGenericBonuses()
    else
        ability:EndCooldown()
        ability:ReturnGold()
        if event.barrack_level == 2 then
            CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#need_builds_level_2" })
        else
            CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#need_builds_level_3" })
        end
    end
end