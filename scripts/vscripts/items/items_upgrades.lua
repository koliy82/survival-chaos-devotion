item_grade_class = class({})

function item_grade_class:GetGoldCost(level)
    local caster = self:GetCaster()
    local id = caster:GetPlayerOwnerID()
    local grade_name = self:GetName()
    local level = self:GetLevel()
    if IsServer() then
        if _G.playersinfo[id] then
            local gradekv = _G.playersinfo[id].raceinfo["upgrades"][grade_name]
            if gradekv.gold_cost then
                local gold_cost = gradekv.gold_cost["default"]
                for mod, mod_gold_cost in pairs(gradekv.gold_cost) do
                    if mod ~= "default" and caster:HasModifier(mod) then
                        gold_cost = mod_gold_cost
                    end
                end
                return gold_cost[level]
            end
        end
    else
        local race_nt = CustomNetTables:GetTableValue("Player_Races", tostring(id))
        if race_nt and race_nt.race then
            local gradekv = _G.racestable[_G.racestable.races_names[tostring(race_nt.race)]].race_data.upgrades[grade_name]
            if gradekv.gold_cost then
                local gold_cost = gradekv.gold_cost["default"]
                for mod, mod_gold_cost in pairs(gradekv.gold_cost) do
                    if mod ~= "default" and caster:HasModifier(mod) then
                        gold_cost = mod_gold_cost
                    end
                end
                return gold_cost[level]
            end
        end
    end
    return 0
end

function item_grade_class:OnSpellStart()
    if IsServer() then
        local data = {}
        data.ability = self
        data.caster = self:GetCaster()
        OnSpellStart(data)
    end
end

function item_grade_class:OnChannelFinish(bInterrupted)
    if IsServer() then
        if bInterrupted then
            self:ReturnGold()
        else
            local data = {}
            data.ability = self
            data.caster = self:GetCaster()
            ApplyUpgrade(data)
        end
    end
end

--------------------------------------------------------------------------------

item_melee_upgrade = item_grade_class
item_range_upgrade = item_grade_class
item_mage_upgrade = item_grade_class
item_armor_upgrade = item_grade_class
item_buildings_upgrade = item_grade_class

--------------------------------------------------------------------------------

function OnSpellStart(event)
    local caster = event.caster
    if _G.polygon then
        ApplyUpgrade(event)
        caster:Stop()
        return
    end
    local castle_level = caster:GetLevel()
    local id = caster:GetPlayerOwnerID()
    local ability = event.ability
    local grade_name = ability:GetAbilityName()
    local level = ability:GetLevel()
    local gradekv = _G.playersinfo[id].raceinfo["upgrades"][grade_name]
    -- print("kakogo gold cost")
    -- print(ability:GetGoldCost(level))
    -- PlayerResource:SetGold(id, PlayerResource:GetGold(id) - ability:GetGoldCost(level), false)
    
    if not _G.playersinfo[id].spec.specpass then
        caster:Stop()
        ability:ReturnGold()
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#need_select_spec" })
        return
    end
    
    if castle_level < gradekv.need_castle_level[level] then
        caster:Stop()
        ability:ReturnGold()
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#need_ancient_level_"..gradekv.need_castle_level[level] })
        return
    end
    -- print("Robotnik kakogo lua 0")
    local fix = caster:AddAbility("fix_lua_item_channeling")
    fix.fixed_item = ability
    fix:SetLevel(ability:GetLevelSpecialValueFor("fixed_channel_time", level-1))
    caster:CastAbilityNoTarget(fix, id)
end

function ApplyUpgrade(event)
    -- print("Robotnik kakogo lua 1")
    local caster = event.caster
    local castle_level = caster:GetLevel()
    local id = caster:GetPlayerOwnerID()
    local ability = event.ability
    local grade_name = ability:GetAbilityName()
    local level = ability:GetLevel()
    local gradekv = _G.playersinfo[id].raceinfo["upgrades"][grade_name]
    
    _G.playerstats[id].castle_upgrades = _G.playerstats[id].castle_upgrades + 1
    
    if gradekv.gpt then
        _G.playersinfo[id].ancient.gpt = _G.playersinfo[id].ancient.gpt + gradekv.gpt
        _G.playersinfo[id].gpt = _G.playersinfo[id].gpt + gradekv.gpt
    end
    
    if gradekv.wave_cd_red then
        for k, v in pairs(_G.playersinfo[id].baracks) do
            v.barrack_timer = v.barrack_timer - gradekv.wave_cd_red
        end
    end

    if gradekv.units then
        local i = 1
        -- print("Robotnik kakogo lua 2")
        while gradekv.units[tostring(i)] do
            -- print("Robotnik kakogo lua 3")
            local unit_grade = gradekv.units[tostring(i)]
            local unit_name = unit_grade.unit

            if unit_grade.damage then
                _G.playersinfo[id].unitsinfo[unit_name].min_damage = _G.playersinfo[id].unitsinfo[unit_name].min_damage + unit_grade.damage[math.min(level, #unit_grade.damage)]
                _G.playersinfo[id].unitsinfo[unit_name].max_damage = _G.playersinfo[id].unitsinfo[unit_name].max_damage + unit_grade.damage[math.min(level, #unit_grade.damage)]
            end
            if unit_grade.health then
                _G.playersinfo[id].unitsinfo[unit_name].health = _G.playersinfo[id].unitsinfo[unit_name].health + unit_grade.health[math.min(level, #unit_grade.health)]
            end
            if unit_grade.mana then
                _G.playersinfo[id].unitsinfo[unit_name].mana = _G.playersinfo[id].unitsinfo[unit_name].mana + unit_grade.mana[math.min(level, #unit_grade.mana)]
            end
            if unit_grade.mana_regen then
                _G.playersinfo[id].unitsinfo[unit_name].bonus_mana_regen = (_G.playersinfo[id].unitsinfo[unit_name].bonus_mana_regen or 0) + unit_grade.mana_regen[math.min(level, #unit_grade.mana_regen)]
            end
            if unit_grade.health_regen then
                _G.playersinfo[id].unitsinfo[unit_name].bonus_health_regen = (_G.playersinfo[id].unitsinfo[unit_name].bonus_health_regen or 0) + unit_grade.health_regen[math.min(level, #unit_grade.health_regen)]
            end
            if unit_grade.armor then
                _G.playersinfo[id].unitsinfo[unit_name].armor = _G.playersinfo[id].unitsinfo[unit_name].armor + unit_grade.armor[math.min(level, #unit_grade.armor)]
            end
            if unit_grade.add_ability then
                _G.playersinfo[id].unitsinfo[unit_name].abilities[unit_grade.add_ability[math.min(level, #unit_grade.add_ability)]] = 1
            end
            if unit_grade.upgrade_ability then
                _G.playersinfo[id].unitsinfo[unit_name].abilities[unit_grade.upgrade_ability[math.min(level, #unit_grade.upgrade_ability)]] = (_G.playersinfo[id].unitsinfo[unit_name].abilities[unit_grade.upgrade_ability[math.min(level, #unit_grade.upgrade_ability)]] or 0) + 1
            end
            i = i + 1
        end
    end

    if gradekv.castle then
        UpgradeBuilding(level, _G.playersinfo[id].ancient, gradekv.castle)
    end
    
    if gradekv.barracks then
        for k, v in pairs(_G.playersinfo[id].baracks) do
            UpgradeBuilding(level, v, gradekv.barracks)
        end
    end
    
    if gradekv.towers then
        for k, v in pairs(_G.playersinfo[id].towers) do
            UpgradeBuilding(level, v, gradekv.towers)
        end
    end
    
    if level >= gradekv.max_level then
        caster:RemoveItem(ability)
    else
        ability:SetLevel(level+1)
        ability:SetCurrentCharges(level)
    end
    _G.playersinfo[id][grade_name] = level
end

function UpgradeBuilding(level, building, grade)
    if grade.damage then
        building:SetBaseDamageMin(building:GetBaseDamageMin() + grade.damage[math.min(level, #grade.damage)])
        building:SetBaseDamageMax(building:GetBaseDamageMax() + grade.damage[math.min(level, #grade.damage)])
    end
    if grade.health then
        local health_prc = building:GetHealthPercent()
        local newhealth = building:GetHealth() + grade.health[math.min(level, #grade.health)]
        building:SetBaseMaxHealth(building:GetBaseMaxHealth() + grade.health[math.min(level, #grade.health)])
        building:CalculateGenericBonuses()
        -- building:AddNewModifier(nil, nil, "fix_mod", {duration = 0.1})
        -- local newhealth = building:GetMaxHealth() * (health_prc/100)
        if newhealth <= 0 then
            newhealth = 1
        end
        building:SetHealth(newhealth)
    end
    if grade.armor then
        building:SetPhysicalArmorBaseValue(building:GetPhysicalArmorBaseValue() + grade.armor[math.min(level, #grade.armor)])
    end
end