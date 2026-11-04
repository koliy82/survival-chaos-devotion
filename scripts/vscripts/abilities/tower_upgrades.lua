function OnSpellStart(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    if _G.playersinfo[id].ancient and _G.playersinfo[id].ancient:GetLevel() > 1 then
        if _G.playersinfo[id].spec.specpass then
            local ability = event.ability
            local ability_name = ability:GetAbilityName()
            for k, v in pairs(_G.playersinfo[id].towers) do
                v:FindAbilityByName(ability_name):SetActivated(false)
            end
        else
            caster:Stop()
            CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#need_select_spec" })
        end
    else
        caster:Stop()
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#need_ancient_level_2" })
    end
end

function OnChannelInterrupted(event)
    local caster = event.caster
    local ability = event.ability
    local ability_name = ability:GetAbilityName()
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:FindAbilityByName(ability_name):SetActivated(true)
    end
end

function ApplyTowerUpgrade(event)
    local caster = event.caster
    local castle_level = caster:GetLevel()
    local id = caster:GetPlayerOwnerID()
    local ability = event.ability
    local grade_name = ability:GetAbilityName()
    local level = ability:GetLevel()
    local gradekv = _G.playersinfo[id].raceinfo["tower_upgrades"][grade_name]
    
    _G.playerstats[id].tower_upgrades = _G.playerstats[id].tower_upgrades + 1
    
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
        while gradekv.units[tostring(i)] do
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
            if unit_grade.armor then
                _G.playersinfo[id].unitsinfo[unit_name].armor = _G.playersinfo[id].unitsinfo[unit_name].armor + unit_grade.armor[math.min(level, #unit_grade.armor)]
            end
            if unit_grade.ats then
                _G.playersinfo[id].unitsinfo[unit_name].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo[unit_name].abilities["attack_speed_pass"] or 0) + unit_grade.ats[math.min(level, #unit_grade.ats)]
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
    
    if level < gradekv.max_level then
		for k, v in pairs(_G.playersinfo[id].towers) do
            v:FindAbilityByName(grade_name):SetActivated(true)
            v:FindAbilityByName(grade_name):SetLevel(level+1)
        end
    else
		for k, v in pairs(_G.playersinfo[id].towers) do
            v:RemoveAbility(grade_name)
        end
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
        building:SetBaseMaxHealth(building:GetBaseMaxHealth() + grade.health[math.min(level, #grade.health)])
        building:CalculateGenericBonuses()
        -- building:AddNewModifier(nil, nil, "fix_mod", {duration = 0.1})
        local newhealth = building:GetMaxHealth() * (health_prc/100)
        if newhealth <= 0 then
            newhealth = 1
        end
        building:SetHealth(newhealth)
    end
    if grade.armor then
        building:SetPhysicalArmorBaseValue(building:GetPhysicalArmorBaseValue() + grade.armor[math.min(level, #grade.armor)])
    end
    if grade.add_ability then
        local building_ability = building:FindAbilityByName(grade.add_ability[math.min(level, #grade.add_ability)])
        if building_ability then
            building_ability:SetLevel(building_ability:GetLevel()+1)
        else
            building:AddAbility(grade.add_ability[math.min(level, #grade.add_ability)]):SetLevel(1)
        end
    end
    if grade.upgrade_ability then
        local building_ability = building:FindAbilityByName(grade.upgrade_ability[math.min(level, #grade.upgrade_ability)])
        if building_ability then
            building_ability:SetLevel(building_ability:GetLevel()+1)
        else
            building:AddAbility(grade.upgrade_ability[math.min(level, #grade.upgrade_ability)]):SetLevel(1)
        end
    end
end