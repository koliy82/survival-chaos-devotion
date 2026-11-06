--treants

function BarracksEfficiency(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    --_G.playersinfo[id].unitsinfo["npc_dota_treants_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_melee"].health + 34
    --_G.playersinfo[id].unitsinfo["npc_dota_treants_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_range"].health + 32
    --_G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].health + 24
    --_G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].health + 38
    --_G.playersinfo[id].unitsinfo["npc_dota_treants_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_air"].health + 66
    --_G.playersinfo[id].unitsinfo["npc_dota_treants_siege"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_siege"].health + 54
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:FindAbilityByName("spawn_hero_treants_tank"):SetLevel(2)
        v:FindAbilityByName("spawn_hero_treants_mage"):SetLevel(2)
        v:FindAbilityByName("spawn_hero_treants_asassin"):SetLevel(2)
        v:FindAbilityByName("spawn_hero_treants_pusher"):SetLevel(2)
        v.barrack_timer = v.barrack_timer - 4
        --local health_prc = v:GetHealthPercent()
        --v:SetBaseMaxHealth(v:GetBaseMaxHealth() + 700)
        --v:CalculateGenericBonuses()
        --local newhealth = v:GetMaxHealth() * (health_prc/100)
        --if newhealth <= 0 then
        --    newhealth = 1
        --end
        --v:SetHealth(newhealth)
        --v:SetPhysicalArmorBaseValue(v:GetPhysicalArmorBaseValue() + 3)
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("treants_tower_range_upgrade")
        v:AddAbility("treants_tower_range_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("treants_tower_barrack_cd_upgrade")
        v:AddAbility("treants_tower_barrack_cd_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
    --for k, v in pairs(_G.playersinfo[id].baracks) do
    --    _G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, v, "modifier_treants_spec_barracks_efficiency_pass_regen", {})
    --end
    --for k, v in pairs(_G.playersinfo[id].towers) do
    --    _G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, v, "modifier_treants_spec_barracks_efficiency_pass_regen", {})
    --end
    --_G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, _G.playersinfo[id].ancient, "modifier_treants_spec_barracks_efficiency_pass_regen", {})
end

function SwapMelee(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v.units["npc_dota_treants_melee_v2"] = v.units["npc_dota_treants_melee"]
        v.units["npc_dota_treants_melee"] = nil
        local charges = 2
        for x=0, 5 do
            local item = v:GetItemInSlot(x)
            if item and item:GetAbilityName() == "item_treants_melee" then
                charges = item:GetCurrentCharges()
                v:RemoveItem(item)
            end
        end
        local new_item = v:AddItemByName("item_treants_melee_v2")
        new_item:SetCurrentCharges(charges)
    end
    
    _G.playersinfo[id].unitsinfo["npc_dota_treants_melee_v2"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_treants_melee_v2"].abilities["attack_speed_pass"] or 0) + 12
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("treants_tower_melee_upgrade")
        v:AddAbility("treants_tower_melee_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function StumpsSquad(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_treants_treant"].health = 550
    _G.playersinfo[id].unitsinfo["npc_dota_treants_treant"].armor = 4
    _G.playersinfo[id].unitsinfo["npc_dota_treants_treant"].min_damage = 30
    _G.playersinfo[id].unitsinfo["npc_dota_treants_treant"].max_damage = 36
    RemoveSpecAbilities(event)
    caster.timer = 115
    caster.treants = 7
    if GameRules:State_Get() < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        function caster:StartGame()
            caster.specpass:StartCooldown(caster.timer)
            Timers:CreateTimer(caster.timer, function()
                local id = caster:GetPlayerOwnerID()
                if _G.playersinfo[id].alive then
                    local owner = caster:GetOwner()
                    if caster.x2treants then
                        local random = RandomInt(1, #_G.additional_building_triggers)
                        local random2 = RandomInt(1, #_G.additional_building_triggers-1)
                        if random2 >= random then
                            random2 = random2 + 1
                        end
                        local point = _G.additional_building_triggers[random]:GetCenter()
                        local point2 = _G.additional_building_triggers[random2]:GetCenter()
                        for i=1, caster.treants do
                            local ent = CreateUnitByName("npc_dota_treants_treant", point, true, owner, owner, owner:GetTeam())
                            FindClearSpaceForUnit( ent, point+RandomVector( 100 ), false )
                        end
                        for i=1, caster.treants do
                            local ent = CreateUnitByName("npc_dota_treants_treant", point2, true, owner, owner, owner:GetTeam())
                            FindClearSpaceForUnit( ent, point2+RandomVector( 100 ), false )
                        end
                    else
                        local random = RandomInt(1, #_G.additional_building_triggers)
                        local point = _G.additional_building_triggers[random]:GetCenter()
                        for i=1, caster.treants do
                            local ent = CreateUnitByName("npc_dota_treants_treant", point, true, owner, owner, owner:GetTeam())
                            FindClearSpaceForUnit( ent, point+RandomVector( 100 ), false )
                        end
                    end
                    caster.specpass:StartCooldown(caster.timer)
                    return caster.timer
                end
            end)
        end
        table.insert(_G.onstartgame, caster)
    else
        local nowtime = GameRules:GetDOTATime(false, true)
        local loc_timer = caster.timer - (nowtime - caster.timer*math.floor(nowtime/caster.timer))
        caster.specpass:StartCooldown(loc_timer)
        Timers:CreateTimer(loc_timer, function()
            local id = caster:GetPlayerOwnerID()
            if _G.playersinfo[id].alive then
                local owner = caster:GetOwner()
                if caster.x2treants then
                    local random = RandomInt(1, #_G.additional_building_triggers)
                    local random2 = RandomInt(1, #_G.additional_building_triggers-1)
                    if random2 >= random then
                        random2 = random2 + 1
                    end
                    local point = _G.additional_building_triggers[random]:GetCenter()
                    local point2 = _G.additional_building_triggers[random2]:GetCenter()
                    for i=1, caster.treants do
                        local ent = CreateUnitByName("npc_dota_treants_treant", point, true, owner, owner, owner:GetTeam())
                        FindClearSpaceForUnit( ent, point+RandomVector( 100 ), false )
                    end
                    for i=1, caster.treants do
                        local ent = CreateUnitByName("npc_dota_treants_treant", point2, true, owner, owner, owner:GetTeam())
                        FindClearSpaceForUnit( ent, point2+RandomVector( 100 ), false )
                    end
                else
                    local random = RandomInt(1, #_G.additional_building_triggers)
                    local point = _G.additional_building_triggers[random]:GetCenter()
                    for i=1, caster.treants do
                        local ent = CreateUnitByName("npc_dota_treants_treant", point, true, owner, owner, owner:GetTeam())
                        FindClearSpaceForUnit( ent, point+RandomVector( 100 ), false )
                    end
                end
                caster.specpass:StartCooldown(caster.timer)
                return caster.timer
            end
        end)
    end
end

function StumpsSquadColUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    caster.timer = caster.timer - 10
    caster.treants = caster.treants + 2
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function StumpsSquadTreantUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_treants_treant"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_treant"].health + 125
    _G.playersinfo[id].unitsinfo["npc_dota_treants_treant"].armor = _G.playersinfo[id].unitsinfo["npc_dota_treants_treant"].armor + 3
    _G.playersinfo[id].unitsinfo["npc_dota_treants_treant"].min_damage = _G.playersinfo[id].unitsinfo["npc_dota_treants_treant"].min_damage + 10
    _G.playersinfo[id].unitsinfo["npc_dota_treants_treant"].max_damage = _G.playersinfo[id].unitsinfo["npc_dota_treants_treant"].max_damage + 10
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function StumpsSquadX2Upgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    caster.x2treants = true
    local ability = event.ability
    local level = ability:GetLevel()
    caster:RemoveAbility(ability:GetAbilityName())
end

function SplitShotUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_treants_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_range"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_treants_range"].abilities["treants_creeps_range_split_shot"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_treants_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_treants_range"].abilities["attack_speed_pass"] or 0) + 12
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("treants_tower_range_upgrade")
        v:AddAbility("treants_tower_range_upgrade_spec_no_buildings"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function UpgradedRoots(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_treants_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_melee"].health + 60
    _G.playersinfo[id].unitsinfo["npc_dota_treants_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_range"].health + 60
    _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].health + 60
    _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].health + 60
    _G.playersinfo[id].unitsinfo["npc_dota_treants_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_treants_melee"].armor + 2
    _G.playersinfo[id].unitsinfo["npc_dota_treants_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_treants_range"].armor + 2
    _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].armor + 2
    _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].armor + 2
    --_G.playersinfo[id].unitsinfo["npc_dota_treants_melee"].abilities["treants_creeps_t1t2_pass"] = 1
    --_G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].abilities["treants_creeps_t1t2_pass"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("treants_tower_melee_and_arme_upgrade")
        v:AddAbility("treants_tower_melee_and_arme_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("treants_tower_melee_upgrade")
        v:AddAbility("treants_tower_melee_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function UpgradedRootsUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_treants_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_melee"].health + 60
    _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].health + 60
    _G.playersinfo[id].unitsinfo["npc_dota_treants_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_treants_melee"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].armor + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function TreantsSwapHeroMage(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:RemoveAbility("spawn_hero_treants_mage")
        v:AddAbility("spawn_hero_treants_mage_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function TreantsSiegeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_treants_siege"].abilities["treants_creeps_siege_acorn"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_treants_siege"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_siege"].health + 500
    _G.playersinfo[id].unitsinfo["npc_dota_treants_siege"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_treants_siege"].abilities["attack_speed_pass"] or 0) + 30
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("treants_tower_siege_upgrade")
        v:AddAbility("treants_tower_siege_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function TreantsArmeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].mana = _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].mana + 50
    _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].bonus_mana_regen = (_G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].bonus_mana_regen or 0) + 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].abilities["treants_creeps_arme_death_pass"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("treants_tower_arme_upgrade")
        v:AddAbility("treants_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function TreantsArmeBuffUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].abilities["treants_creeps_arme_death_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].abilities["treants_creeps_arme_death_pass"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function TreantsAirBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_treants_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_air"].health + 700
    _G.playersinfo[id].unitsinfo["npc_dota_treants_air"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_treants_air"].abilities["attack_speed_pass"] or 0) + 30
    _G.playersinfo[id].unitsinfo["npc_dota_treants_air"].abilities["treants_creeps_spec_shackles"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("treants_tower_air_upgrade")
        v:AddAbility("treants_tower_air_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function AddSpawnTiny(event)
    local target = event.target
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    if target:GetUnitName() ~= "npc_dota_custom_barrack" or caster:GetPlayerOwnerID() ~= target:GetPlayerOwnerID() then
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#dota_hud_error_cant_cast_on_other" })
        return
    end
    target.units["npc_dota_treants_tiny_spec"] = 2

    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("treants_tower_melee_upgrade")
        v:AddAbility("treants_tower_melee_upgrade_spec"):SetLevel(1)
    end

    RemoveSpecAbilities(event)
end

function TreantsMageBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].health + 150
    _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].mana = _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].mana + 75
    _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].abilities["attack_speed_pass"] or 0) + 20
    _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].abilities["treants_creeps_mage_spec_skill"] = 1
    RemoveSpecAbilities(event)
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("treants_tower_mage_upgrade")
        v:AddAbility("treants_tower_mage_upgrade_spec"):SetLevel(1)
    end
end

function TreantsMageBuffUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    local ability = event.ability
    local level = ability:GetLevel()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].abilities["treants_creeps_mage_spec_skill"] = _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].abilities["treants_creeps_mage_spec_skill"] + 1
    if level == 1 then 
        _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].abilities["treants_creeps_mage_roots"] = _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].abilities["treants_creeps_mage_roots"] + 1 
    elseif level == 2 then 
        _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].abilities["treants_creeps_mage_roots"] = _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].abilities["treants_creeps_mage_roots"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].abilities["treants_creeps_mage_split_shot"] = _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].abilities["treants_creeps_mage_split_shot"] + 1
    elseif level == 3 then
        _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].abilities["treants_creeps_mage_roots"] = _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].abilities["treants_creeps_mage_roots"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].abilities["treants_creeps_mage_split_shot"] = _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].abilities["treants_creeps_mage_split_shot"] + 1
        _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].abilities["treants_creeps_mage_bonds"] = _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].abilities["treants_creeps_mage_bonds"] + 1
    end
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

--undead

function TowersAttackSpeed(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:AddAbility("attack_speed_pass"):SetLevel(105)
        v:RemoveAbility("undead_tower_range_upgrade")
        v:AddAbility("undead_tower_range_upgrade_spec"):SetLevel(1)
        --v:AddAbility("undead_towers_gold"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function TowersAttackSpeedUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:AddAbility("attack_speed_pass"):SetLevel(105)
        --local abil = v:FindAbilityByName("undead_towers_gold")
        --abil:SetLevel(abil:GetLevel()+1)
    end
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 2 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function HealOnKill_OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()

    ability:SetLevel(_G.playersinfo[id].ancient:GetLevel()) 

    function ability:OnBuildingUpgrade(keys)
        local building = EntIndexToHScript( keys.building )
        if id == building:GetPlayerOwnerID() and building:GetUnitName() == "npc_dota_custom_ancient" then
            ability:SetLevel(building:GetLevel())
        end
    end

    ListenToGameEvent('building_upgrade', ability.OnBuildingUpgrade, ability)
end

function HealOnKill_OnDestroy(event)
    local ability = event.ability
    
    StopListeningToAllGameEvents(ability)
end

function HealAttacker(event)
    if event.attacker and not event.attacker:IsNull() and event.attacker:IsAlive() and event.attacker ~= event.target and event.ability and not event.ability:IsNull() then
        event.attacker:Heal(event.ability:GetLevelSpecialValueFor("heal", event.ability:GetLevel()-1), event.ability)
    end
end

function HealOnKillUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].spec.specpass:SetLevel(_G.playersinfo[id].spec.specpass:GetLevel()+1)
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function AddSpawnDog(event)
    local target = event.target
    local caster = event.caster
    -- local id = caster:GetPlayerOwnerID()
    if target:GetUnitName() ~= "npc_dota_custom_barrack" or caster:GetPlayerOwnerID() ~= target:GetPlayerOwnerID() then
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#dota_hud_error_cant_cast_on_other" })
        return
    end
    target.units["npc_dota_undead_dog"] = 2

    RemoveSpecAbilities(event)
end

function SwapCreepRangeToMelee(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v.units["npc_dota_undead_melee_v2"] = v.units["npc_dota_undead_range"]
        v.units["npc_dota_undead_range"] = nil
        local charges = 2
        for x=0, 5 do
            local item = v:GetItemInSlot(x)
            if item and item:GetAbilityName() == "item_undead_range" then
                charges = item:GetCurrentCharges()
                v:RemoveItem(item)
            end
        end
        local new_item = v:AddItemByName("item_undead_melee_v2")
        new_item:SetCurrentCharges(charges)
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("undead_tower_range_upgrade")
    end
    RemoveSpecAbilities(event)
end

function MoreFlesh(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_undead_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_undead_melee"].health + 40
    _G.playersinfo[id].unitsinfo["npc_dota_undead_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_undead_range"].health + 40
    _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].health + 40
    _G.playersinfo[id].unitsinfo["npc_dota_undead_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_undead_arme"].health + 40
    _G.playersinfo[id].unitsinfo["npc_dota_undead_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_undead_melee"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_undead_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_undead_range"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_undead_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_undead_arme"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("undead_tower_melee_and_arme_upgrade")
        v:AddAbility("undead_tower_melee_and_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function MoreFleshUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].spec.specpass:SetLevel(_G.playersinfo[id].spec.specpass:GetLevel()+1)
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function UndeadArmeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_undead_arme"].abilities["undead_creeps_arme_aura"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_undead_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_undead_arme"].health + 105
    _G.playersinfo[id].unitsinfo["npc_dota_undead_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_undead_arme"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("undead_tower_arme_upgrade")
        v:AddAbility("undead_tower_arme_upgrade_spec2"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function UndeadArmeUpgradeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_undead_arme"].abilities["undead_creeps_arme_aura"] = _G.playersinfo[id].unitsinfo["npc_dota_undead_arme"].abilities["undead_creeps_arme_aura"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function UndeadAirSwap(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v.units["npc_dota_undead_air_spec"] = v.units["npc_dota_undead_air"]
        v.units["npc_dota_undead_air"] = nil
        local charges = 2
        for x=0, 5 do
            local item = v:GetItemInSlot(x)
            if item and item:GetAbilityName() == "item_undead_air" then
                charges = item:GetCurrentCharges()
                v:RemoveItem(item)
            end
        end
        if v:GetLevel() > 2 then
            local new_item = v:AddItemByName("item_undead_air_spec")
            new_item:SetCurrentCharges(charges)
        end
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("undead_tower_air_frost_upgrade")
        v:AddAbility("undead_tower_air_frost_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("undead_tower_air_upgrade")
        v:AddAbility("undead_tower_air_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function UndeadMageSwap(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].abilities["attack_speed_pass"] or 0) + 10
    _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].health + 70
    _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].mana = _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].mana + 140
    _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].abilities["undead_creeps_mage_mana"] = 1

    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("undead_tower_mage_upgrade")
        v:AddAbility("undead_tower_mage_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function UndeadMageSwapUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    local ability = event.ability
    local level = ability:GetLevel()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].abilities["undead_creeps_mage_mana"] = _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].abilities["undead_creeps_mage_mana"] + 1
    if level == 1 then 
        _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].abilities["undead_creeps_mage_lifesteal"] = _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].abilities["undead_creeps_mage_lifesteal"] + 1 
    elseif level == 2 then 
        _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].abilities["undead_creeps_mage_lifesteal"] = _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].abilities["undead_creeps_mage_lifesteal"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].abilities["undead_creeps_mage_cooldown_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].abilities["undead_creeps_mage_cooldown_pass"] + 1
    elseif level == 3 then
        _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].abilities["undead_creeps_mage_lifesteal"] = _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].abilities["undead_creeps_mage_lifesteal"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].abilities["undead_creeps_mage_cooldown_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].abilities["undead_creeps_mage_cooldown_pass"] + 1
        _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].abilities["undead_creeps_mage_summon"] = _G.playersinfo[id].unitsinfo["npc_dota_undead_mage"].abilities["undead_creeps_mage_summon"] + 1
    end
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function UndeadSwapHeroMage(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:RemoveAbility("spawn_hero_undead_mage")
        v:AddAbility("spawn_hero_undead_mage_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function UndeadRangeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_undead_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_undead_range"].health + 110
    _G.playersinfo[id].unitsinfo["npc_dota_undead_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_undead_range"].abilities["attack_speed_pass"] or 0) + 13
    _G.playersinfo[id].unitsinfo["npc_dota_undead_range"].abilities["undead_creeps_range_death_mark"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("undead_tower_range_upgrade")
        v:AddAbility("undead_tower_range_upgrade_spec2"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function UndeadRangeUpgradeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_undead_range"].abilities["undead_creeps_range_death_mark"] = _G.playersinfo[id].unitsinfo["npc_dota_undead_range"].abilities["undead_creeps_range_death_mark"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_undead_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_undead_range"].abilities["attack_speed_pass"] or 0) + 8
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function UndeadMeleeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_undead_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_undead_melee"].health + 110
    _G.playersinfo[id].unitsinfo["npc_dota_undead_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_undead_melee"].abilities["attack_speed_pass"] or 0) + 15
    _G.playersinfo[id].unitsinfo["npc_dota_undead_melee"].abilities["undead_creeps_melee_berserk_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_undead_melee"].abilities["undead_creeps_melee_berserk_resist"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("undead_tower_melee_upgrade")
        v:AddAbility("undead_tower_melee_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function UndeadMeleeUpgradeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_undead_melee"].abilities["undead_creeps_melee_berserk_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_undead_melee"].abilities["undead_creeps_melee_berserk_pass"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 2 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function UndeadSiegeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_undead_siege"].health = _G.playersinfo[id].unitsinfo["npc_dota_undead_siege"].health + 600
    _G.playersinfo[id].unitsinfo["npc_dota_undead_siege"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_undead_siege"].abilities["attack_speed_pass"] or 0) + 15
    _G.playersinfo[id].unitsinfo["npc_dota_undead_siege"].abilities["undead_creeps_siege_wraith"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("undead_tower_siege_upgrade")
        v:AddAbility("undead_tower_siege_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

--humans

function AddMiliUnit(event)
    local target = event.target
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    if target:GetUnitName() ~= "npc_dota_custom_barrack" or caster:GetPlayerOwnerID() ~= target:GetPlayerOwnerID() then
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#dota_hud_error_cant_cast_on_other" })
        return
    end
    target.units["npc_dota_humans_milic"] = 2
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("humans_tower_melee_upgrade")
        v:AddAbility("humans_tower_melee_upgrade_spec"):SetLevel(1)
    end

    RemoveSpecAbilities(event)
end

function SwapSiegeToMorph(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_humans_morph"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_humans_morph"].abilities["attack_speed_pass"] or 0) + 36
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v.units["npc_dota_humans_morph"] = v.units["npc_dota_humans_siege"]
        v.units["npc_dota_humans_siege"] = nil
        local charges = 2
        for x=0, 5 do
            local item = v:GetItemInSlot(x)
            if item and item:GetAbilityName() == "item_humans_siege" then
                charges = item:GetCurrentCharges()
                v:RemoveItem(item)
                local new_item = v:AddItemByName("item_humans_morph")
                new_item:SetCurrentCharges(charges)
            end
        end
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("humans_tower_range_and_siege_upgrade")
        v:AddAbility("humans_tower_range_and_siege_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function TemplarOrder(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_humans_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_humans_melee"].health + 20
    _G.playersinfo[id].unitsinfo["npc_dota_humans_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_humans_range"].health + 20
    _G.playersinfo[id].unitsinfo["npc_dota_humans_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_humans_mage"].health + 20
    _G.playersinfo[id].unitsinfo["npc_dota_humans_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_humans_arme"].health + 20
    -- _G.playersinfo[id].unitsinfo["npc_dota_humans_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_humans_melee"].armor + 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_humans_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_humans_range"].armor + 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_humans_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_humans_mage"].armor + 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_humans_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_humans_arme"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_humans_melee"].abilities["humans_creeps_melee_arme_manaburn"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_humans_arme"].abilities["humans_creeps_melee_arme_manaburn"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("humans_tower_melee_upgrade")
        v:AddAbility("humans_tower_melee_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function TemplarOrderUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_humans_melee"].abilities["humans_creeps_melee_arme_manaburn"] = _G.playersinfo[id].unitsinfo["npc_dota_humans_melee"].abilities["humans_creeps_melee_arme_manaburn"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_humans_arme"].abilities["humans_creeps_melee_arme_manaburn"] = _G.playersinfo[id].unitsinfo["npc_dota_humans_arme"].abilities["humans_creeps_melee_arme_manaburn"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function HumansMageSwap(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v.units["npc_dota_humans_mage_spec"] = v.units["npc_dota_humans_mage"]
        v.units["npc_dota_humans_mage"] = nil
        local charges = 2
        for x=0, 5 do
            local item = v:GetItemInSlot(x)
            if item and item:GetAbilityName() == "item_humans_mage" then
                charges = item:GetCurrentCharges()
                v:RemoveItem(item)
            end
        end
        local new_item = v:AddItemByName("item_humans_mage_spec")
        new_item:SetCurrentCharges(charges)
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("humans_tower_mage_upgrade")
        v:AddAbility("humans_tower_mage_upgrade_spec"):SetLevel(1)
    end
    --_G.playersinfo[id].unitsinfo["npc_dota_humans_mage_spec"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_humans_mage_spec"].abilities["attack_speed_pass"] or 0) + 5
    RemoveSpecAbilities(event)
end

function HumansMageSwapUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_humans_mage_spec"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_humans_mage_spec"].abilities["attack_speed_pass"] or 0) + 5
    _G.playersinfo[id].unitsinfo["npc_dota_humans_mage_spec"].abilities["humans_creeps_mage_mana_recovery"] = _G.playersinfo[id].unitsinfo["npc_dota_humans_mage_spec"].abilities["humans_creeps_mage_mana_recovery"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level == 1 then 
        _G.playersinfo[id].unitsinfo["npc_dota_humans_mage_spec"].abilities["humans_creeps_mage_heal"] = _G.playersinfo[id].unitsinfo["npc_dota_humans_mage_spec"].abilities["humans_creeps_mage_heal"] + 1 
    elseif level == 2 then 
        _G.playersinfo[id].unitsinfo["npc_dota_humans_mage_spec"].abilities["humans_creeps_mage_heal"] = _G.playersinfo[id].unitsinfo["npc_dota_humans_mage_spec"].abilities["humans_creeps_mage_heal"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_humans_mage_spec"].abilities["humans_creeps_mage_blizzard"] = _G.playersinfo[id].unitsinfo["npc_dota_humans_mage_spec"].abilities["humans_creeps_mage_blizzard"] + 1
    elseif level == 3 then
        _G.playersinfo[id].unitsinfo["npc_dota_humans_mage_spec"].abilities["humans_creeps_mage_heal"] = _G.playersinfo[id].unitsinfo["npc_dota_humans_mage_spec"].abilities["humans_creeps_mage_heal"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_humans_mage_spec"].abilities["humans_creeps_mage_blizzard"] = _G.playersinfo[id].unitsinfo["npc_dota_humans_mage_spec"].abilities["humans_creeps_mage_blizzard"] + 1
        _G.playersinfo[id].unitsinfo["npc_dota_humans_mage_spec"].abilities["humans_creeps_mage_reincarnation"] = _G.playersinfo[id].unitsinfo["npc_dota_humans_mage_spec"].abilities["humans_creeps_mage_reincarnation"] + 1
    end
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function HumansArmeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_humans_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_humans_arme"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_humans_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_humans_arme"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_humans_arme"].abilities["humans_creeps_arme_spec_death_pass"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("humans_tower_arme_and_air_upgrade")
        v:AddAbility("humans_tower_arme_and_air_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function HumansArmeBuffUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_humans_arme"].abilities["humans_creeps_arme_spec_death_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_humans_arme"].abilities["humans_creeps_arme_spec_death_pass"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function HumansMeleeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_humans_melee"].abilities["humans_creeps_melee_spec_damage_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_humans_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_humans_melee"].health + 90
    -- _G.playersinfo[id].unitsinfo["npc_dota_humans_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_humans_melee"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_humans_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_humans_melee"].abilities["attack_speed_pass"] or 0) + 15
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("humans_tower_melee_shield_upgrade")
        v:AddAbility("humans_tower_melee_shield_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function HumansSwapHeroAsassin(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:RemoveAbility("spawn_hero_humans_asassin")
        v:AddAbility("spawn_hero_humans_asassin_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function HumansAirBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_humans_air"].abilities["humans_creeps_air_salo_obet"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_humans_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_humans_air"].health + 200
    _G.playersinfo[id].unitsinfo["npc_dota_humans_air"].mana = _G.playersinfo[id].unitsinfo["npc_dota_humans_air"].mana + 125
    _G.playersinfo[id].unitsinfo["npc_dota_humans_air"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_humans_air"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("humans_tower_air_heal_upgrade")
        v:AddAbility("humans_tower_air_heal_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function HumansT1T2Buff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_humans_melee"].abilities["humans_divine_grace"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_humans_range"].abilities["humans_divine_grace"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_humans_mage"].abilities["humans_divine_grace"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_humans_arme"].abilities["humans_divine_grace"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("humans_tower_arme_upgrade")
        v:AddAbility("humans_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function HumanWisdom(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
	local team = PlayerResource:GetTeam(id)
	-- AddFOWViewer(team, Entities:FindByName( nil, "corner9"):GetAbsOrigin(), 99999, 99999, true)
	-- for i=1,#_G.additional_building_triggers do
	-- 	AddFOWViewer(team, _G.additional_building_triggers[i]:GetAbsOrigin(), 99999, 99999, true)
	-- end
	-- for i=1, 4 do
	-- 	AddFOWViewer(team, Entities:FindByName( nil, "corner"..(i*2)):GetAbsOrigin(), 99999, 99999, true)
	-- end
    AddFOWViewer(team, Entities:FindByName( nil, "corner9"):GetAbsOrigin(), 5500, 99999, true)
	-- for i=1,#_G.additional_building_triggers do
	-- 	AddFOWViewer(team, _G.additional_building_triggers[i]:GetAbsOrigin(), 2000, 99999, true)
	-- end
    for i=1, 4 do
		AddFOWViewer(team, Entities:FindByName( nil, "corner"..(i*2 - 1)):GetAbsOrigin(), 5000, 99999, true)
	end
	for i=1, 4 do
		AddFOWViewer(team, Entities:FindByName( nil, "corner"..(i*2)):GetAbsOrigin(), 1750, 99999, true)
	end
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:FindAbilityByName("spawn_hero_humans_tank"):SetLevel(2)
        v:FindAbilityByName("spawn_hero_humans_mage"):SetLevel(2)
        v:FindAbilityByName("spawn_hero_humans_asassin"):SetLevel(2)
        v:FindAbilityByName("spawn_hero_humans_pusher"):SetLevel(2)
        local health_prc = v:GetHealthPercent()
        v:SetBaseMaxHealth(v:GetBaseMaxHealth() + 500)
        v:CalculateGenericBonuses()
        local newhealth = v:GetMaxHealth() * (health_prc/100)
        if newhealth <= 0 then
            newhealth = 1
        end
        v:SetHealth(newhealth)
        --v:SetPhysicalArmorBaseValue(v:GetPhysicalArmorBaseValue() + 2)
    end
    RemoveSpecAbilities(event)
    for k, v in pairs(_G.playersinfo[id].baracks) do
       _G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, v, "modifier_humans_wisdom_pass_ancient_regen", {})
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        local health_prc = v:GetHealthPercent()
        v:SetBaseMaxHealth(v:GetBaseMaxHealth() + 500)
        v:CalculateGenericBonuses()
        local newhealth = v:GetMaxHealth() * (health_prc/100)
        if newhealth <= 0 then
            newhealth = 1
        end
        v:SetHealth(newhealth)
        --v:SetPhysicalArmorBaseValue(v:GetPhysicalArmorBaseValue() + 2)
        _G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, v, "modifier_humans_wisdom_pass_ancient_regen", {})
    end
    _G.playersinfo[id].ancient:AddAbility("humans_spec_wisdom_push"):SetLevel(1)
    _G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, _G.playersinfo[id].ancient, "modifier_humans_wisdom_pass_ancient", {})
    _G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, _G.playersinfo[id].ancient, "modifier_humans_wisdom_pass_ancient_regen", {})
end

function HumansRangeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_humans_range"].abilities["humans_creeps_range_rage"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_humans_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_humans_range"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_humans_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_humans_range"].abilities["attack_speed_pass"] or 0) + 12
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("humans_tower_range_and_towers_upgrade")
        v:AddAbility("humans_tower_range_and_towers_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function HumansRangeBuffUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_humans_range"].abilities["humans_creeps_range_rage"] = _G.playersinfo[id].unitsinfo["npc_dota_humans_range"].abilities["humans_creeps_range_rage"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

--orcs

function T1T2CreepsBonus(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].health + 70
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_orcs_range"].health + 70
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].health + 70
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].health + 70
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].armor + 2
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_orcs_range"].armor + 2
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].armor + 2
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].armor + 2
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("orcs_tower_melee_upgrade")
        v:AddAbility("orcs_tower_melee_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("orcs_tower_melee_range_upgrade")
        v:AddAbility("orcs_tower_melee_range_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function AddSpawnWolfs(event)
    local target = event.target
    local caster = event.caster
    -- local id = caster:GetPlayerOwnerID()
    if target:GetUnitName() ~= "npc_dota_custom_barrack" or caster:GetPlayerOwnerID() ~= target:GetPlayerOwnerID() then
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#dota_hud_error_cant_cast_on_other" })
        return
    end
    target.units["npc_dota_orcs_wolf"] = 2

    RemoveSpecAbilities(event)
end

function OrcsLightnings(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].abilities["attack_speed_pass"] or 0) + 7
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].abilities["attack_speed_pass"] or 0) + 7
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["attack_speed_pass"] or 0) + 7
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].abilities["orcs_creeps_spec_lightnings"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].abilities["orcs_creeps_spec_lightnings"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_spec_lightnings"] = 1
    RemoveSpecAbilities(event)
end

function OrcsLightningsUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].abilities["attack_speed_pass"] or 0) + 5
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].abilities["attack_speed_pass"] or 0) + 5
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["attack_speed_pass"] or 0) + 5
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].abilities["orcs_creeps_spec_lightnings"] = _G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].abilities["orcs_creeps_spec_lightnings"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].abilities["orcs_creeps_spec_lightnings"] = _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].abilities["orcs_creeps_spec_lightnings"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_spec_lightnings"] = _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_spec_lightnings"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function OrcsMeleeBonus(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].abilities["orcs_creeps_spec_self_heal"] = 1 --changes armor type
    --_G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].abilities["orcs_creeps_spec_ministun"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].health + 65
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("orcs_tower_melee_upgrade")
        v:AddAbility("orcs_tower_melee_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function OrcsMageBonus(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    --_G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_mage_antiair_bolt"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_mage_healing_ward"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].health + 75
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].mana = _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].mana + 75
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["attack_speed_pass"] or 0) + 8
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("orcs_tower_mage_upgrade")
        v:AddAbility("orcs_tower_mage_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function OrcsMageBonusUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_mage_healing_ward"] = _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_mage_healing_ward"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level == 1 then 
        _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_mage_bolt"] = _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_mage_bolt"] + 1 
    elseif level == 2 then 
        _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_mage_bolt"] = _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_mage_bolt"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_mage_lightnings_shield"] = _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_mage_lightnings_shield"] + 1
    elseif level == 3 then
        _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_mage_bolt"] = _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_mage_bolt"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_mage_lightnings_shield"] = _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_mage_lightnings_shield"] + 1
        _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_mage_shake"] = _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_mage_shake"] + 1
    end
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function OrcsArmeBonus(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].abilities["orcs_creeps_arme_spec_battle"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].health + 135
    -- _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("orcs_tower_arme_upgrade")
        v:AddAbility("orcs_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function OrcsArmeBonusUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].abilities["orcs_creeps_arme_spec_battle"] = _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].abilities["orcs_creeps_arme_spec_battle"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function OrcsSwapSiege(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_siege_spec"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_orcs_siege_spec"].abilities["attack_speed_pass"] or 0) + 45
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v.units["npc_dota_orcs_siege_spec"] = v.units["npc_dota_orcs_siege"]
        v.units["npc_dota_orcs_siege"] = nil
        local charges = 2
        for x=0, 5 do
            local item = v:GetItemInSlot(x)
            if item and item:GetAbilityName() == "item_orcs_siege" then
                charges = item:GetCurrentCharges()
                v:RemoveItem(item)
                local new_item = v:AddItemByName("item_orcs_siege_spec")
                new_item:SetCurrentCharges(charges)
            end
        end
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("orcs_tower_siege_upgrade")
        v:AddAbility("orcs_tower_siege_upgrade_spec"):SetLevel(1)
    end
    ability:ApplyDataDrivenModifier(caster, _G.playersinfo[id].ancient, "modifiers_orcs_spec_siege_swap_grade_gold", {})
    RemoveSpecAbilities(event)
end

function OrcsSwapHeroTank(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:RemoveAbility("spawn_hero_orcs_tank")
        v:AddAbility("spawn_hero_orcs_tank_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function OrcsRangeBonus(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_range"].abilities["orcs_creeps_range_rage_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_orcs_range"].health + 200
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_orcs_range"].abilities["attack_speed_pass"] or 0) + 15
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("orcs_tower_range_upgrade")
        v:AddAbility("orcs_tower_range_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function OrcsSpecBerserk(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_range"].abilities["orcs_creeps_battletoend_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].abilities["orcs_creeps_battletoend_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].abilities["orcs_creeps_battletoend_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_battletoend_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_air"].abilities["orcs_creeps_battletoend_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_orcs_range"].abilities["attack_speed_pass"] or 0) + 5
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].abilities["attack_speed_pass"] or 0) + 5
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].abilities["attack_speed_pass"] or 0) + 5
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["attack_speed_pass"] or 0) + 5
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_air"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_orcs_air"].abilities["attack_speed_pass"] or 0) + 5
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("orcs_tower_arme_upgrade")
        v:AddAbility("orcs_tower_arme_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("orcs_tower_melee_upgrade")
        v:AddAbility("orcs_tower_melee_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function OrcsSpecBerserkUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].abilities["orcs_creeps_battletoend_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_orcs_melee"].abilities["orcs_creeps_battletoend_pass"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_range"].abilities["orcs_creeps_battletoend_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_orcs_range"].abilities["orcs_creeps_battletoend_pass"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_battletoend_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_orcs_mage"].abilities["orcs_creeps_battletoend_pass"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].abilities["orcs_creeps_battletoend_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_orcs_arme"].abilities["orcs_creeps_battletoend_pass"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_air"].abilities["orcs_creeps_battletoend_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_orcs_air"].abilities["orcs_creeps_battletoend_pass"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function OrcsAirBonus(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_air"].abilities["orcs_creeps_air_molotoff"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_orcs_air"].health + 200
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_air"].mana = _G.playersinfo[id].unitsinfo["npc_dota_orcs_air"].mana + 100
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_air"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_orcs_air"].abilities["attack_speed_pass"] or 0) + 18
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("orcs_tower_air_upgrade")
        v:AddAbility("orcs_tower_air_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function OrcsAirBonusUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_orcs_air"].abilities["orcs_creeps_air_molotoff"] = _G.playersinfo[id].unitsinfo["npc_dota_orcs_air"].abilities["orcs_creeps_air_molotoff"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

--dwarfs

function EliteClock(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_melee"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_melee"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("dwarfs_tower_melee_upgrade")
        v:AddAbility("dwarfs_tower_melee_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function EliteClockUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_melee"].health + 100
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function DwarfsMiniStun(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].abilities["attack_speed_pass"] or 0) + 6
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_arme"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_dwarfs_arme"].abilities["attack_speed_pass"] or 0) + 6
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_air"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_dwarfs_air"].abilities["attack_speed_pass"] or 0) + 6
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].abilities["dwarfs_creeps_spec_ministun"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_arme"].abilities["dwarfs_creeps_spec_ministun"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_air"].abilities["dwarfs_creeps_spec_ministun"] = 1
    RemoveSpecAbilities(event)
end

function DwarfsMiniStunUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].abilities["attack_speed_pass"] or 0) + 6
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_arme"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_dwarfs_arme"].abilities["attack_speed_pass"] or 0) + 6
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_air"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_dwarfs_air"].abilities["attack_speed_pass"] or 0) + 6
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].abilities["dwarfs_creeps_spec_ministun"] = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].abilities["dwarfs_creeps_spec_ministun"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_arme"].abilities["dwarfs_creeps_spec_ministun"] = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_arme"].abilities["dwarfs_creeps_spec_ministun"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_air"].abilities["dwarfs_creeps_spec_ministun"] = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_air"].abilities["dwarfs_creeps_spec_ministun"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function DeathFromAbove(event)
    --local caster = event.caster
    --local ability = event.ability
    --local id = caster:GetPlayerOwnerID()
    --for k, v in pairs(_G.playersinfo[id].baracks) do
    --    v:FindAbilityByName("spawn_hero_dwarfs_tank"):SetLevel(2)
    --    v:FindAbilityByName("spawn_hero_dwarfs_mage"):SetLevel(2)
    --    v:FindAbilityByName("spawn_hero_dwarfs_asassin"):SetLevel(2)
    --    v:FindAbilityByName("spawn_hero_dwarfs_pusher"):SetLevel(2)
    --end
    local caster = event.caster
    local team = caster:GetTeam()
    -- AddFOWViewer(team, Entities:FindByName( nil, "corner9"):GetAbsOrigin(), 5500, 99999, true)
    -- for i=1, 4 do
	-- 	AddFOWViewer(team, Entities:FindByName( nil, "corner"..(i*2 - 1)):GetAbsOrigin(), 5000, 99999, true)
	-- end
	-- for i=1, 4 do
	-- 	AddFOWViewer(team, Entities:FindByName( nil, "corner"..(i*2)):GetAbsOrigin(), 1750, 99999, true)
	-- end

    RemoveSpecAbilities(event)

    --caster.timer = 300
    --
    --if GameRules:State_Get() < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    --    function caster:StartGame()
    --        caster.specpass:StartCooldown(caster.timer)
    --        Timers:CreateTimer(caster.timer, function()
    --            local this_id = caster:GetPlayerOwnerID()
    --            if _G.playersinfo[this_id].alive then
    --
    --                EmitSoundOn("Hero_Rattletrap.Rocket_Flare.Fire", caster)
    --                for id, playerdata in pairs(_G.playersinfo) do
    --                    if PlayerResource:GetTeam(this_id) ~= PlayerResource:GetTeam(id) and playerdata.alive then
    --                        if playerdata.ancient then
    --
    --                            local projectile = {
    --                                Target = playerdata.ancient,
    --                                Source = caster,
    --                                Ability = caster.specpass,
    --                                EffectName = "particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf",
    --                                bDodgable = false,
    --                                iMoveSpeed = 2000,
    --                            }
    --                            ProjectileManager:CreateTrackingProjectile(projectile)
    --                        end
    --                    end
    --                end
    --
    --                caster.specpass:StartCooldown(caster.timer)
    --                return caster.timer
    --            end
    --        end)
    --    end
    --    table.insert(_G.onstartgame, caster)
    --else
    --    local nowtime = GameRules:GetDOTATime(false, true)
    --    local loc_timer = caster.timer - (nowtime - caster.timer*math.floor(nowtime/caster.timer))
    --    caster.specpass:StartCooldown(loc_timer)
    --    Timers:CreateTimer(loc_timer, function()
    --        local this_id = caster:GetPlayerOwnerID()
    --        if _G.playersinfo[this_id].alive then
    --            
    --            EmitSoundOn("Hero_Rattletrap.Rocket_Flare.Fire", caster)
    --            for id, playerdata in pairs(_G.playersinfo) do
    --                if PlayerResource:GetTeam(this_id) ~= PlayerResource:GetTeam(id) and playerdata.alive then
    --                    if playerdata.ancient then
    --
    --                        local projectile = {
    --                            Target = playerdata.ancient,
    --                            Source = caster,
    --                            Ability = caster.specpass,
    --                            EffectName = "particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf",
    --                            bDodgable = false,
    --                            iMoveSpeed = 2000,
    --                        }
    --                        ProjectileManager:CreateTrackingProjectile(projectile)
    --                    end
    --                end
    --            end
    --
    --            caster.specpass:StartCooldown(caster.timer)
    --            return caster.timer
    --        end
    --    end)
    --end
    --local loc_id = caster:GetPlayerOwnerID()
    --_G.playersinfo[loc_id].spec.specpass:ApplyDataDrivenModifier(caster, _G.playersinfo[loc_id].ancient, "modifier_dwarfs_spec_death_from_above_pass_ancient", {})
end

function DeathFromAboveOnProjectileHitUnit(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local damage = ability:GetSpecialValueFor("damage")
    if target then
        EmitSoundOn("Hero_Rattletrap.Rocket_Flare.Explode", target)
        local target_id = target:GetPlayerOwnerID()
        if _G.playersinfo[target_id].alive then
            if _G.playersinfo[target_id].ancient then
                ApplyCustomDamage(_G.playersinfo[target_id].ancient, caster, damage, 6, nil)
            end
            for k, v in pairs(_G.playersinfo[target_id].baracks) do
                ApplyCustomDamage(v, caster, damage, 6, nil)
            end
            for k, v in pairs(_G.playersinfo[target_id].towers) do
                ApplyCustomDamage(v, caster, damage, 6, nil)
            end
        end
    end
end

function DeathFromAboveUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].spec.specpass:SetLevel(_G.playersinfo[id].spec.specpass:GetLevel()+1)
    local ability = event.ability
    local spec_ability = caster:FindAbilityByName("dwarfs_spec_death_from_above_rocket")
    local level = ability:GetLevel()
    --caster.timer = caster.timer - 25
    if level >= 2 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
    spec_ability:SetLevel(level+1)
end

function DeathFromAboveVision(event)
    local caster = event.caster
    local team = caster:GetTeam()
    -- AddFOWViewer(team,Vector(0,5000,0), 10000, 30,false)
    -- AddFOWViewer(team,Vector(0,-5000,0), 10000, 30,false)
    -- AddFOWViewer(team,Vector(5000,0,0), 10000, 30,false)
    -- AddFOWViewer(team,Vector(5000,-5000,0), 10000, 30,false)
    -- AddFOWViewer(team,Vector(5000,5000,0), 10000, 30,false)
    -- AddFOWViewer(team,Vector(-5000,-5000,0), 10000, 30,false)
    -- AddFOWViewer(team,Vector(-5000,5000,0), 10000, 30,false)
    -- AddFOWViewer(team,Vector(-5000,0,0), 10000, 30,false)
    -- AddFOWViewer(team,Vector(0,0,0), 10000, 30,false)
    AddFOWViewer(team, Entities:FindByName( nil, "corner9"):GetAbsOrigin(), 5500, 30, true)
	-- for i=1,#_G.additional_building_triggers do
	-- 	AddFOWViewer(team, _G.additional_building_triggers[i]:GetAbsOrigin(), 2000, 99999, true)
	-- end
    for i=1, 4 do
		AddFOWViewer(team, Entities:FindByName( nil, "corner"..(i*2 - 1)):GetAbsOrigin(), 5000, 30, true)
	end
	for i=1, 4 do
		AddFOWViewer(team, Entities:FindByName( nil, "corner"..(i*2)):GetAbsOrigin(), 1750, 30, true)
	end
end

function DwarfsSiegeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_siege"].health = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_siege"].health + 800
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_siege"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_dwarfs_siege"].abilities["attack_speed_pass"] or 0) + 45
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_siege"].abilities["dwarfs_creeps_siege_missile_spec"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("dwarfs_tower_siege_upgrade")
        v:AddAbility("dwarfs_tower_siege_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function AddSpawnTimbers(event)
    local target = event.target
    local caster = event.caster
    -- local id = caster:GetPlayerOwnerID()
    if target:GetUnitName() ~= "npc_dota_custom_barrack" or caster:GetPlayerOwnerID() ~= target:GetPlayerOwnerID() then
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#dota_hud_error_cant_cast_on_other" })
        return
    end
    target.units["npc_dota_dwarfs_timber"] = 2

    RemoveSpecAbilities(event)
end

function DwarfsT1T2Buff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_melee"].abilities["dwarfs_creeps_spec_death_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].abilities["dwarfs_creeps_spec_death_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].abilities["dwarfs_creeps_spec_death_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_arme"].abilities["dwarfs_creeps_spec_death_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_melee"].health + 50
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].health + 50
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].health + 50
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_arme"].health + 50
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_melee"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_arme"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("dwarfs_tower_arme_aura_upgrade")
        v:AddAbility("dwarfs_tower_arme_aura_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DwarfsT1T2BuffUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_melee"].abilities["dwarfs_creeps_spec_death_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_melee"].abilities["dwarfs_creeps_spec_death_pass"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].abilities["dwarfs_creeps_spec_death_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].abilities["dwarfs_creeps_spec_death_pass"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].abilities["dwarfs_creeps_spec_death_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].abilities["dwarfs_creeps_spec_death_pass"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_arme"].abilities["dwarfs_creeps_spec_death_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_arme"].abilities["dwarfs_creeps_spec_death_pass"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function DwarfsAirBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    --_G.playersinfo[id].unitsinfo["npc_dota_dwarfs_air"].abilities["dwarfs_creeps_air_napalm_damage"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_air"].health + 600
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("dwarfs_tower_air_upgrade")
        v:AddAbility("dwarfs_tower_air_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("dwarfs_tower_air_speed_upgrade")
        v:AddAbility("dwarfs_tower_air_speed_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DwarfsSwapHeroMage(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:RemoveAbility("spawn_hero_dwarfs_mage")
        v:AddAbility("spawn_hero_dwarfs_mage_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DwarfsRangeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].abilities["attack_speed_pass"] or 0) + 10
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].health + 105
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].abilities["dwarfs_creeps_range_impetus"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("dwarfs_tower_range_upgrade")
        v:AddAbility("dwarfs_tower_range_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DwarfsRangeBuffUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].abilities["dwarfs_creeps_range_impetus"] = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_range"].abilities["dwarfs_creeps_range_impetus"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function DwarfsMageBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].bonus_mana_regen = (_G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].bonus_mana_regen or 0) + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].health + 80
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].mana = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].mana + 50
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].abilities["dwarfs_creeps_mage_spec_gear"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("dwarfs_tower_mage_upgrade")
        v:AddAbility("dwarfs_tower_mage_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DwarfsMageBuffUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].abilities["dwarfs_creeps_mage_spec_gear"] = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].abilities["dwarfs_creeps_mage_spec_gear"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level == 1 then 
        _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].abilities["dwarfs_creeps_mage_seeking_missile"] = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].abilities["dwarfs_creeps_mage_seeking_missile"] + 1 
    elseif level == 2 then 
        _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].abilities["dwarfs_creeps_mage_seeking_missile"] = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].abilities["dwarfs_creeps_mage_seeking_missile"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].abilities["dwarfs_creeps_mage_rearm_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].abilities["dwarfs_creeps_mage_rearm_pass"] + 1
    elseif level == 3 then
        _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].abilities["dwarfs_creeps_mage_seeking_missile"] = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].abilities["dwarfs_creeps_mage_seeking_missile"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].abilities["dwarfs_creeps_mage_rearm_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].abilities["dwarfs_creeps_mage_rearm_pass"] + 1
        _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].abilities["dwarfs_creeps_mage_multicast"] = _G.playersinfo[id].unitsinfo["npc_dota_dwarfs_mage"].abilities["dwarfs_creeps_mage_multicast"] + 1
    end
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

--elves

function LanternElune(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
	local team = PlayerResource:GetTeam(id)
	AddFOWViewer(team, Entities:FindByName( nil, "corner9"):GetAbsOrigin(), 5500, 99999, true)
	-- for i=1,#_G.additional_building_triggers do
	-- 	AddFOWViewer(team, _G.additional_building_triggers[i]:GetAbsOrigin(), 2000, 99999, true)
	-- end
    for i=1, 4 do
		AddFOWViewer(team, Entities:FindByName( nil, "corner"..(i*2 - 1)):GetAbsOrigin(), 5000, 99999, true)
	end
	for i=1, 4 do
		AddFOWViewer(team, Entities:FindByName( nil, "corner"..(i*2)):GetAbsOrigin(), 1750, 99999, true)
	end
    RemoveSpecAbilities(event)
    _G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, _G.playersinfo[id].ancient, "modifier_elves_spec_lantern_elune_pass_ancient", {})
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:FindAbilityByName("spawn_hero_elves_tank"):SetLevel(2)
        v:FindAbilityByName("spawn_hero_elves_mage"):SetLevel(2)
        v:FindAbilityByName("spawn_hero_elves_asassin"):SetLevel(2)
        v:FindAbilityByName("spawn_hero_elves_pusher"):SetLevel(2)
        --_G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, v, "modifier_elves_spec_lantern_elune_pass_barrack", {})
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("elves_tower_all_upgrade")
        v:AddAbility("elves_tower_all_upgrade_spec"):SetLevel(1)
    end
    _G.playersinfo[id].ancient:FindAbilityByName("elves_race_bonus"):SetLevel(2)
end

function AddSpawnTemplars(event)
    local target = event.target
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    if target:GetUnitName() ~= "npc_dota_custom_barrack" or caster:GetPlayerOwnerID() ~= target:GetPlayerOwnerID() then
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#dota_hud_error_cant_cast_on_other" })
        return
    end
    target.units["npc_dota_elves_spec_templar"] = 2
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("elves_tower_melee_manaburn_upgrade")
        v:AddAbility("elves_tower_melee_manaburn_upgrade_spec"):SetLevel(1)
    end

    RemoveSpecAbilities(event)
end

LinkLuaModifier( "modifier_elves_spec_dexterity", "modifiers/modifier_elves_spec_dexterity.lua", LUA_MODIFIER_MOTION_NONE )
function ElvesDexterity(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_elves_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_elves_melee"].health + 50
    _G.playersinfo[id].unitsinfo["npc_dota_elves_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_elves_range"].health + 50
    _G.playersinfo[id].unitsinfo["npc_dota_elves_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_elves_mage"].health + 50
    _G.playersinfo[id].unitsinfo["npc_dota_elves_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_elves_arme"].health + 50
    _G.playersinfo[id].unitsinfo["npc_dota_elves_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_elves_melee"].armor + 2
    _G.playersinfo[id].unitsinfo["npc_dota_elves_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_elves_range"].armor + 2
    _G.playersinfo[id].unitsinfo["npc_dota_elves_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_elves_mage"].armor + 2
    _G.playersinfo[id].unitsinfo["npc_dota_elves_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_elves_arme"].armor + 2
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("elves_tower_melee_manaburn_upgrade")
        v:AddAbility("elves_tower_melee_manaburn_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("elves_tower_arme_upgrade")
        v:AddAbility("elves_tower_arme_upgrade_spec"):SetLevel(1)
    end
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:AddNewModifier(caster, event.ability, "modifier_elves_spec_dexterity", {})
    end
    RemoveSpecAbilities(event)
end

function ElvesUntouchable(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_elves_mage_spec"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_elves_mage_spec"].abilities["attack_speed_pass"] or 0) + 8
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v.units["npc_dota_elves_mage_spec"] = v.units["npc_dota_elves_mage"]
        v.units["npc_dota_elves_mage"] = nil
        local charges = 2
        for x=0, 5 do
            local item = v:GetItemInSlot(x)
            if item and item:GetAbilityName() == "item_elves_mage" then
                charges = item:GetCurrentCharges()
                v:RemoveItem(item)
            end
        end
        local new_item = v:AddItemByName("item_elves_mage_spec")
        new_item:SetCurrentCharges(charges)
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("elves_tower_mage_upgrade")
        v:AddAbility("elves_tower_mage_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function ElvesUntouchableUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_elves_mage_spec"].health = _G.playersinfo[id].unitsinfo["npc_dota_elves_mage_spec"].health + 75
    _G.playersinfo[id].unitsinfo["npc_dota_elves_mage_spec"].abilities["elves_creeps_mage_spec_untouchable"] = _G.playersinfo[id].unitsinfo["npc_dota_elves_mage_spec"].abilities["elves_creeps_mage_spec_untouchable"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level == 1 then 
        _G.playersinfo[id].unitsinfo["npc_dota_elves_mage_spec"].abilities["elves_creeps_mage_starfall"] = _G.playersinfo[id].unitsinfo["npc_dota_elves_mage_spec"].abilities["elves_creeps_mage_starfall"] + 1 
    elseif level == 2 then 
        _G.playersinfo[id].unitsinfo["npc_dota_elves_mage_spec"].abilities["elves_creeps_mage_starfall"] = _G.playersinfo[id].unitsinfo["npc_dota_elves_mage_spec"].abilities["elves_creeps_mage_starfall"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_elves_mage_spec"].abilities["elves_creeps_mage_aoe_debuff"] = _G.playersinfo[id].unitsinfo["npc_dota_elves_mage_spec"].abilities["elves_creeps_mage_aoe_debuff"] + 1
    elseif level == 3 then
        _G.playersinfo[id].unitsinfo["npc_dota_elves_mage_spec"].abilities["elves_creeps_mage_starfall"] = _G.playersinfo[id].unitsinfo["npc_dota_elves_mage_spec"].abilities["elves_creeps_mage_starfall"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_elves_mage_spec"].abilities["elves_creeps_mage_aoe_debuff"] = _G.playersinfo[id].unitsinfo["npc_dota_elves_mage_spec"].abilities["elves_creeps_mage_aoe_debuff"] + 1
        _G.playersinfo[id].unitsinfo["npc_dota_elves_mage_spec"].abilities["elves_creeps_mage_blessing"] = _G.playersinfo[id].unitsinfo["npc_dota_elves_mage_spec"].abilities["elves_creeps_mage_blessing"] + 1
    end
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function ElvesArmeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_elves_arme"].abilities["elves_creeps_arme_spec"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_elves_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_elves_arme"].health + 50
    _G.playersinfo[id].unitsinfo["npc_dota_elves_arme"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_elves_arme"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("elves_tower_arme_upgrade")
        v:AddAbility("elves_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function ElvesArmeBuffUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_elves_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_elves_arme"].health + 50
    _G.playersinfo[id].unitsinfo["npc_dota_elves_arme"].abilities["elves_creeps_arme_spec"] = _G.playersinfo[id].unitsinfo["npc_dota_elves_arme"].abilities["elves_creeps_arme_spec"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function ElvesMeleeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    --_G.playersinfo[id].unitsinfo["npc_dota_elves_melee"].abilities["elves_creeps_melee_arme_manaburn"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_elves_melee"].abilities["elves_creeps_melee_aura"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_elves_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_elves_melee"].armor + 2
    _G.playersinfo[id].unitsinfo["npc_dota_elves_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_elves_melee"].health + 80
    _G.playersinfo[id].unitsinfo["npc_dota_elves_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_elves_melee"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("elves_tower_melee_manaburn_upgrade")
        v:AddAbility("elves_tower_melee_manaburn_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function ElvesMeleeBuffUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_elves_melee"].abilities["elves_creeps_melee_aura"] = _G.playersinfo[id].unitsinfo["npc_dota_elves_melee"].abilities["elves_creeps_melee_aura"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function ElvesAirSwap(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v.units["npc_dota_elves_air_spec"] = v.units["npc_dota_elves_air"]
        v.units["npc_dota_elves_air"] = nil
        local charges = 2
        for x=0, 5 do
            local item = v:GetItemInSlot(x)
            if item and item:GetAbilityName() == "item_elves_air" then
                charges = item:GetCurrentCharges()
                v:RemoveItem(item)
            end
        end
        if v:GetLevel() > 2 then
            local new_item = v:AddItemByName("item_elves_air_spec")
            new_item:SetCurrentCharges(charges)
        end
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("elves_tower_air_upgrade")
        v:AddAbility("elves_tower_air_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function ElvesSwapHeroAsassin(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:RemoveAbility("spawn_hero_elves_tank")
        v:AddAbility("spawn_hero_elves_asassin_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function ElvesRangeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_elves_range"].abilities["elves_creeps_range_brave"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_elves_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_elves_range"].health + 125
    _G.playersinfo[id].unitsinfo["npc_dota_elves_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_elves_range"].abilities["attack_speed_pass"] or 0) + 15
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("elves_tower_range_upgrade")
        v:AddAbility("elves_tower_range_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function ElvesRangeBuffUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_elves_range"].abilities["elves_creeps_range_brave"] = _G.playersinfo[id].unitsinfo["npc_dota_elves_range"].abilities["elves_creeps_range_brave"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_elves_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_elves_range"].abilities["attack_speed_pass"] or 0) + 5
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

--spiders

function DarkObelisk(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_spiders_melee"].health + 60
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_spiders_range"].health + 60
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].health + 60
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_spiders_arme"].health + 60
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_spiders_melee"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_spiders_range"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_spiders_arme"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("spiders_tower_melee_upgrade")
        v:AddAbility("spiders_tower_melee_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("spiders_tower_melee_phobia_upgrade")
        v:AddAbility("spiders_tower_melee_phobia_upgrade_spec"):SetLevel(1)
    end
    --_G.playersinfo[id].ancient:SetModifierStackCount("modifier_spiders_race_bonus", _G.playersinfo[id].ancient, 1)
    if GameRules:State_Get() < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        function caster:StartGame()
            Timers:CreateTimer(420, function()
                GameRules:SetTimeOfDay(0.85)
                return 660
            end)
        end
        table.insert(_G.onstartgame, caster)
    else
        local nowtime = GameRules:GetDOTATime(false, true)
        Timers:CreateTimer(420 - nowtime, function()
            GameRules:SetTimeOfDay(0.85)
            return 660
        end)
    end
    -- Timers:CreateTimer(60, function()
    --     print(GameRules:GetTimeOfDay())
    --     return 60
    -- end)
    RemoveSpecAbilities(event)
end

function SpidersAddSpiders(event)
    local target = event.target
    local caster = event.caster
    -- local id = caster:GetPlayerOwnerID()
    if target:GetUnitName() ~= "npc_dota_custom_barrack" or caster:GetPlayerOwnerID() ~= target:GetPlayerOwnerID() then
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#dota_hud_error_cant_cast_on_other" })
        return
    end
    target.units["npc_dota_spiders_spec_spider"] = 2
    
    RemoveSpecAbilities(event)
end

function SpidersSiegeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_siege"].abilities["spiders_creeps_spec_siege_cocoon_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_siege"].health = _G.playersinfo[id].unitsinfo["npc_dota_spiders_siege"].health + 800
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_siege"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_spiders_siege"].abilities["attack_speed_pass"] or 0) + 50
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("spiders_tower_siege_upgrade")
        v:AddAbility("spiders_tower_siege_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function SpidersAbsorption(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_melee"].abilities["spiders_creeps_spec_absorption"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_arme"].abilities["spiders_creeps_spec_absorption"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_air"].abilities["spiders_creeps_spec_absorption"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_spiders_melee"].abilities["attack_speed_pass"] or 0) + 15
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_arme"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_spiders_arme"].abilities["attack_speed_pass"] or 0) + 15
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_air"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_spiders_air"].abilities["attack_speed_pass"] or 0) + 15
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("spiders_tower_air_scream_upgrade")
        v:AddAbility("spiders_tower_air_scream_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function SpidersAbsorptionUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_melee"].abilities["spiders_creeps_spec_absorption"] = _G.playersinfo[id].unitsinfo["npc_dota_spiders_melee"].abilities["spiders_creeps_spec_absorption"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_arme"].abilities["spiders_creeps_spec_absorption"] = _G.playersinfo[id].unitsinfo["npc_dota_spiders_arme"].abilities["spiders_creeps_spec_absorption"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_air"].abilities["spiders_creeps_spec_absorption"] = _G.playersinfo[id].unitsinfo["npc_dota_spiders_air"].abilities["spiders_creeps_spec_absorption"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function SpidersArmeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_arme"].abilities["spiders_creeps_arme_roar"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_spiders_arme"].health + 125
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_spiders_arme"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("spiders_tower_arme_upgrade")
        v:AddAbility("spiders_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function SpidersArmeBuffUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_arme"].abilities["spiders_creeps_arme_roar"] = _G.playersinfo[id].unitsinfo["npc_dota_spiders_arme"].abilities["spiders_creeps_arme_roar"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function SpidersRangeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_range"].abilities["spiders_creeps_range_antiair"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_spiders_range"].health + 220
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_range"].mana = _G.playersinfo[id].unitsinfo["npc_dota_spiders_range"].mana + 100
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_spiders_range"].abilities["attack_speed_pass"] or 0) + 40
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("spiders_tower_range_upgrade")
        v:AddAbility("spiders_tower_range_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function SpidersMeleeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_melee"].abilities["spiders_creeps_melee_spec_bite"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_melee"].abilities["spiders_creeps_melee_spec_damage_pass"] = 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_spiders_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_spiders_melee"].health + 60
    -- _G.playersinfo[id].unitsinfo["npc_dota_spiders_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_spiders_melee"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_spiders_melee"].abilities["attack_speed_pass"] or 0) + 8
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("spiders_tower_melee_upgrade")
        v:AddAbility("spiders_tower_melee_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function SpidersSwapHeroPusher(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:RemoveAbility("spawn_hero_spiders_pusher")
        v:AddAbility("spawn_hero_spiders_pusher_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function SpidersAirSwap(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_air_spec"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_spiders_air_spec"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v.units["npc_dota_spiders_air_spec"] = v.units["npc_dota_spiders_air"]
        v.units["npc_dota_spiders_air"] = nil
        local charges = 2
        for x=0, 5 do
            local item = v:GetItemInSlot(x)
            if item and item:GetAbilityName() == "item_spiders_air" then
                charges = item:GetCurrentCharges()
                v:RemoveItem(item)
            end
        end
        if v:GetLevel() > 2 then
            local new_item = v:AddItemByName("item_spiders_air_spec")
            new_item:SetCurrentCharges(charges)
        end
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("spiders_tower_air_upgrade")
        v:AddAbility("spiders_tower_air_upgrade_spec"):SetLevel(1)
    end
    ability:ApplyDataDrivenModifier(caster, _G.playersinfo[id].ancient, "modifiers_spiders_spec_air_swap_pass_grade_gold", {})
    RemoveSpecAbilities(event)
end

function SpidersMageBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].armor + 2
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].bonus_mana_regen = (_G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].bonus_mana_regen or 0) + 1
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].min_damage = _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].min_damage + 5
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].max_damage = _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].max_damage + 5
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].abilities["attack_speed_pass"] or 0) + 5
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].abilities["spiders_creeps_mage_kill"] = 1
    RemoveSpecAbilities(event)
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("spiders_tower_mage_upgrade")
        v:AddAbility("spiders_tower_mage_upgrade_spec"):SetLevel(1)
    end
end

function SpidersMageUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].bonus_mana_regen = (_G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].bonus_mana_regen or 0) + 1
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].min_damage = _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].min_damage + 5
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].max_damage = _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].max_damage + 5
    _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].abilities["spiders_creeps_mage_kill"] = _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].abilities["spiders_creeps_mage_kill"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level == 1 then
        _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].abilities["spiders_creeps_mage_visage"] = _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].abilities["spiders_creeps_mage_visage"] + 1 
    elseif level == 2 then
        _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].abilities["spiders_creeps_mage_visage"] = _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].abilities["spiders_creeps_mage_visage"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].abilities["spiders_creeps_mage_venomous_gale"] = _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].abilities["spiders_creeps_mage_venomous_gale"] + 1
    elseif level == 3 then
        _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].abilities["spiders_creeps_mage_visage"] = _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].abilities["spiders_creeps_mage_visage"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].abilities["spiders_creeps_mage_venomous_gale"] = _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].abilities["spiders_creeps_mage_venomous_gale"] + 1
        _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].abilities["spiders_creeps_mage_web"] = _G.playersinfo[id].unitsinfo["npc_dota_spiders_mage"].abilities["spiders_creeps_mage_web"] + 1
    end
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

--nagas

function MutatedCarapace(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_nagas_melee"].health + 75
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_nagas_range"].health + 75
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].health + 75
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].health + 75
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_nagas_melee"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_nagas_range"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("nagas_tower_melee_upgrade")
        v:AddAbility("nagas_tower_melee_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("nagas_tower_arme_upgrade")
        v:AddAbility("nagas_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
    for k, v in pairs(_G.playersinfo[id].baracks) do
        caster.specpass:ApplyDataDrivenModifier(caster, v, "modifiers_nagas_spec_mutated_carapace_pass", {})
        for i=0, 8 do
            local item = v:GetItemInSlot(i)
            if item and item.charge_restore_time then
                item.charge_restore_time = item.charge_restore_time * 0.6
                -- также менять в creep_spawn_items
            end
        end
    end
end

function NagasMurlocs(event)
    local caster = event.caster
    local target = event.target
    local id = caster:GetPlayerOwnerID()
    if target:GetUnitName() ~= "npc_dota_custom_barrack" or caster:GetPlayerOwnerID() ~= target:GetPlayerOwnerID() then
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#dota_hud_error_cant_cast_on_other" })
        return
    end
    target.units["npc_dota_nagas_murloc"] = 2
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("nagas_tower_melee_counterattack_upgrade")
        v:AddAbility("nagas_tower_melee_counterattack_upgrade_spec"):SetLevel(1)
    end
    
    RemoveSpecAbilities(event)
end

function NagasMeleeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    --_G.playersinfo[id].unitsinfo["npc_dota_nagas_melee"].abilities["nagas_creeps_melee_manaburn"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_melee"].abilities["nagas_creeps_melee_evasion_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_nagas_melee"].health + 100
    --_G.playersinfo[id].unitsinfo["npc_dota_nagas_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_nagas_melee"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("nagas_tower_melee_upgrade")
        v:AddAbility("nagas_tower_melee_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function NagasArmeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].abilities["nagas_creeps_spec_ministun"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].health + 130
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("nagas_tower_melee_counterattack_upgrade")
        v:AddAbility("nagas_tower_melee_counterattack_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function NagasArmeBuffUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].health + 50
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].abilities["nagas_creeps_spec_ministun"] = _G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].abilities["nagas_creeps_spec_ministun"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function NagasIceOrb(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_melee"].abilities["nagas_creeps_spec_ice_orb"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_range"].abilities["nagas_creeps_spec_ice_orb"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["nagas_creeps_spec_ice_orb"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].abilities["nagas_creeps_spec_ice_orb"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_nagas_melee"].abilities["attack_speed_pass"] or 0) + 10
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_nagas_range"].abilities["attack_speed_pass"] or 0) + 10
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["attack_speed_pass"] or 0) + 10
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("nagas_tower_arme_upgrade")
        v:AddAbility("nagas_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function NagasIceOrbUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_melee"].abilities["nagas_creeps_spec_ice_orb"] = _G.playersinfo[id].unitsinfo["npc_dota_nagas_melee"].abilities["nagas_creeps_spec_ice_orb"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_range"].abilities["nagas_creeps_spec_ice_orb"] = _G.playersinfo[id].unitsinfo["npc_dota_nagas_range"].abilities["nagas_creeps_spec_ice_orb"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["nagas_creeps_spec_ice_orb"] = _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["nagas_creeps_spec_ice_orb"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].abilities["nagas_creeps_spec_ice_orb"] = _G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].abilities["nagas_creeps_spec_ice_orb"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_nagas_melee"].abilities["attack_speed_pass"] or 0) + 12
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_nagas_range"].abilities["attack_speed_pass"] or 0) + 12
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["attack_speed_pass"] or 0) + 12
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_nagas_arme"].abilities["attack_speed_pass"] or 0) + 12
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function NagasRangeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_range"].abilities["nagas_creeps_range_split_shot"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_nagas_range"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_nagas_range"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("nagas_tower_range_upgrade")
        v:AddAbility("nagas_tower_range_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function NagasRangeBuffUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_range"].abilities["nagas_creeps_range_split_shot"] = _G.playersinfo[id].unitsinfo["npc_dota_nagas_range"].abilities["nagas_creeps_range_split_shot"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function NagasSiegeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_siege"].abilities["nagas_creeps_siege_split_shot"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_siege"].health = _G.playersinfo[id].unitsinfo["npc_dota_nagas_siege"].health + 500
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_siege"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_nagas_siege"].abilities["attack_speed_pass"] or 0) + 40
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("nagas_tower_siege_upgrade")
        v:AddAbility("nagas_tower_siege_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function NagasSwapHeroAsassin(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:RemoveAbility("spawn_hero_nagas_asassin")
        v:AddAbility("spawn_hero_nagas_asassin_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function NagasAirBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_air"].abilities["nagas_creeps_air_kill"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_nagas_air"].health + 500
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_air"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_nagas_air"].abilities["attack_speed_pass"] or 0) + 15
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("nagas_tower_air_skin_upgrade")
        v:AddAbility("nagas_tower_air_skin_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("nagas_tower_air_upgrade")
        v:AddAbility("nagas_tower_air_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function NagasMageBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].health + 50
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].mana = _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].mana + 50
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["attack_speed_pass"] or 0) + 5
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["nagas_creeps_mage_attack"] = 1
    RemoveSpecAbilities(event)
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("nagas_tower_mage_upgrade")
        v:AddAbility("nagas_tower_mage_upgrade_spec"):SetLevel(1)
    end
end

function NagasMageUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["nagas_creeps_mage_attack"] = _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["nagas_creeps_mage_attack"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level == 1 then
        _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["nagas_creeps_mage_adaptive_strike"] = _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["nagas_creeps_mage_adaptive_strike"] + 1 
    elseif level == 2 then
        _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["nagas_creeps_mage_adaptive_strike"] = _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["nagas_creeps_mage_adaptive_strike"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["nagas_creeps_mage_curse_of_the_sea"] = _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["nagas_creeps_mage_curse_of_the_sea"] + 1
    elseif level == 3 then
        _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["nagas_creeps_mage_adaptive_strike"] = _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["nagas_creeps_mage_adaptive_strike"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["nagas_creeps_mage_curse_of_the_sea"] = _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["nagas_creeps_mage_curse_of_the_sea"] + 1
        _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["nagas_creeps_mage_purge"] = _G.playersinfo[id].unitsinfo["npc_dota_nagas_mage"].abilities["nagas_creeps_mage_purge"] + 1
    end
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

--demons

function DemonsLegion(event)
    --local caster = event.caster
    --local id = caster:GetPlayerOwnerID()
    --_G.playersinfo[id].unitsinfo["npc_dota_demons_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_demons_melee"].health + 40
    --_G.playersinfo[id].unitsinfo["npc_dota_demons_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_demons_range"].health + 40
    --_G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].health + 40
    --_G.playersinfo[id].unitsinfo["npc_dota_demons_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_demons_arme"].health + 40
    --_G.playersinfo[id].unitsinfo["npc_dota_demons_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_demons_melee"].armor + 1
    --_G.playersinfo[id].unitsinfo["npc_dota_demons_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_demons_range"].armor + 1
    --_G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].armor + 1
    --_G.playersinfo[id].unitsinfo["npc_dota_demons_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_demons_arme"].armor + 1
    --for k, v in pairs(_G.playersinfo[id].towers) do
    --    v:RemoveAbility("demons_tower_range_upgrade")
    --    v:AddAbility("demons_tower_range_upgrade_spec"):SetLevel(1)
    --    v:RemoveAbility("demons_tower_arme_upgrade")
    --    v:AddAbility("demons_tower_arme_upgrade_spec"):SetLevel(1)
    --end
    --RemoveSpecAbilities(event)
end

function DemonsRiki(event)
    local caster = event.caster
    local target = event.target
    local id = caster:GetPlayerOwnerID()
    if target:GetUnitName() ~= "npc_dota_custom_barrack" or caster:GetPlayerOwnerID() ~= target:GetPlayerOwnerID() then
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#dota_hud_error_cant_cast_on_other" })
        return
    end
    target.units["npc_dota_demons_riki"] = 2

    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("demons_tower_melee_upgrade")
        v:AddAbility("demons_tower_melee_upgrade_spec_4lvl"):SetLevel(1)
    end
    
    RemoveSpecAbilities(event)
end

function DemonsCorruptionOrb(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    --_G.playersinfo[id].unitsinfo["npc_dota_demons_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_demons_melee"].health + 20
    --_G.playersinfo[id].unitsinfo["npc_dota_demons_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_demons_range"].health + 20
    --_G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].health + 20
    --_G.playersinfo[id].unitsinfo["npc_dota_demons_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_demons_arme"].health + 20
    --_G.playersinfo[id].unitsinfo["npc_dota_demons_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_demons_melee"].armor + 1
    --_G.playersinfo[id].unitsinfo["npc_dota_demons_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_demons_range"].armor + 1
    --_G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].armor + 1
    --_G.playersinfo[id].unitsinfo["npc_dota_demons_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_demons_arme"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_melee"].abilities["demons_creeps_spec_corruption_orb"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_range"].abilities["demons_creeps_spec_corruption_orb"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].abilities["demons_creeps_spec_corruption_orb"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_arme"].abilities["demons_creeps_spec_corruption_orb"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("demons_tower_range_upgrade")
        v:AddAbility("demons_tower_range_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("demons_tower_arme_upgrade")
        v:AddAbility("demons_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DemonsCorruptionOrbUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_melee"].abilities["demons_creeps_spec_corruption_orb"] = _G.playersinfo[id].unitsinfo["npc_dota_demons_melee"].abilities["demons_creeps_spec_corruption_orb"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_range"].abilities["demons_creeps_spec_corruption_orb"] = _G.playersinfo[id].unitsinfo["npc_dota_demons_range"].abilities["demons_creeps_spec_corruption_orb"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].abilities["demons_creeps_spec_corruption_orb"] = _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].abilities["demons_creeps_spec_corruption_orb"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_arme"].abilities["demons_creeps_spec_corruption_orb"] = _G.playersinfo[id].unitsinfo["npc_dota_demons_arme"].abilities["demons_creeps_spec_corruption_orb"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function DemonsArmeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_demons_arme"].abilities["demons_creeps_spec_arme_buff"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_demons_arme"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_demons_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_demons_arme"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("demons_tower_arme_upgrade")
        v:AddAbility("demons_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DemonsArmeBuffUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_arme"].abilities["demons_creeps_spec_arme_buff"] = _G.playersinfo[id].unitsinfo["npc_dota_demons_arme"].abilities["demons_creeps_spec_arme_buff"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function DemonsAirBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_demons_air"].abilities["demons_creeps_spec_astral"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_air"].abilities["demons_creeps_spec_air_mana_regen_aura"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_demons_air"].health + 220
    _G.playersinfo[id].unitsinfo["npc_dota_demons_air"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_demons_air"].abilities["attack_speed_pass"] or 0) + 7
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("demons_tower_air_upgrade")
        v:AddAbility("demons_tower_air_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DemonsSiegeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_demons_siege"].abilities["demons_creeps_spec_siege_debuff_aura"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_siege"].abilities["demons_creeps_spec_siege_evasion_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_siege"].health = _G.playersinfo[id].unitsinfo["npc_dota_demons_siege"].health + 400
    _G.playersinfo[id].unitsinfo["npc_dota_demons_siege"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_demons_siege"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("demons_tower_siege_upgrade")
        v:AddAbility("demons_tower_siege_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DemonsGolemsSquad(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    caster.golem_points = {}
    local center = Entities:FindByName( nil, "corner9"):GetCenter()
    local loc_arr = nil
    if _G.playersinfo[id].base_pos == 1 then
        loc_arr = {8,2,6,8}
    elseif _G.playersinfo[id].base_pos == 2 then
        loc_arr = {8,4,6,6}
    elseif _G.playersinfo[id].base_pos == 3 then
        loc_arr = {2,4,4,6}
    elseif _G.playersinfo[id].base_pos == 4 then
        loc_arr = {2,2,4,8}
    end
    for i=1, 4 do
        table.insert( caster.golem_points, { Entities:FindByName( nil, "corner"..(i*2-1)):GetCenter(), loc_arr[i], Entities:FindByName( nil, "corner"..(i*2-1)):GetCenter() })
        if _G.duos then
            table.insert( caster.golem_points, { Entities:FindByName( nil, "corner"..(i*2-1)):GetCenter(), loc_arr[i], Entities:FindByName( nil, "corner"..(i*2-1)):GetCenter() })
        else
            table.insert( caster.golem_points, { (center + Entities:FindByName( nil, "corner"..(i*2)):GetCenter()) / 2, i*2, center })
        end
    end
    caster.timer = 180
    caster.golems = 1
    RemoveSpecAbilities(event)
    if GameRules:State_Get() < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        function caster:StartGame()
            caster.specpass:StartCooldown(caster.timer)
            Timers:CreateTimer(caster.timer, function()
                local id = caster:GetPlayerOwnerID()
                if _G.playersinfo[id].alive then
                    local owner = caster:GetOwner()
                    local copy_golem_points = {}
                    for k, v in pairs(caster.golem_points) do
                        copy_golem_points[k] = v
                    end
                    for i=1, caster.golems do
                        local random = RandomInt(1, #copy_golem_points)
                        local point = copy_golem_points[random]
                        table.remove(copy_golem_points, random)
                        local golem = CreateUnitByName("npc_dota_demons_spec_golem", point[1], true, owner, owner, owner:GetTeam())
                        if point[2] ~= false then
                            golem.to_point = point[3]
                            golem.previous_point = point[2]
                        end
                        FindClearSpaceForUnit( golem, point[1], false )
                    end
                    caster.specpass:StartCooldown(caster.timer)
                    return caster.timer
                end
            end)
        end
        table.insert(_G.onstartgame, caster)
    else
        local nowtime = GameRules:GetDOTATime(false, true)
        local loc_timer = caster.timer - (nowtime - caster.timer*math.floor(nowtime/caster.timer))
        caster.specpass:StartCooldown(loc_timer)
        Timers:CreateTimer(loc_timer, function()
            local id = caster:GetPlayerOwnerID()
            if _G.playersinfo[id].alive then
                local id = caster:GetPlayerOwnerID()
                if _G.playersinfo[id].alive then
                    local owner = caster:GetOwner()
                    local copy_golem_points = {}
                    for k, v in pairs(caster.golem_points) do
                        copy_golem_points[k] = v
                    end
                    for i=1, caster.golems do
                        local random = RandomInt(1, #copy_golem_points)
                        local point = copy_golem_points[random]
                        table.remove(copy_golem_points, random)
                        local golem = CreateUnitByName("npc_dota_demons_spec_golem", point[1], true, owner, owner, owner:GetTeam())
                        if point[2] ~= false then
                            golem.to_point = point[3]
                            golem.previous_point = point[2]
                        end
                        FindClearSpaceForUnit( golem, point[1], false )
                    end
                end
                caster.specpass:StartCooldown(caster.timer)
                return caster.timer
            end
        end)
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("demons_tower_heroes_upgrade")
        v:AddAbility("demons_tower_heroes_upgrade_spec"):SetLevel(1)
    end
end

function DemonsGolemsSquadDamageAndTimerUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    caster.timer = caster.timer - 10
    _G.playersinfo[id].unitsinfo["npc_dota_demons_spec_golem"].min_damage = _G.playersinfo[id].unitsinfo["npc_dota_demons_spec_golem"].min_damage + 25
    _G.playersinfo[id].unitsinfo["npc_dota_demons_spec_golem"].max_damage = _G.playersinfo[id].unitsinfo["npc_dota_demons_spec_golem"].max_damage + 25
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function DemonsGolemsSquadArmorAndColUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    caster.golems = caster.golems + 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_spec_golem"].armor = _G.playersinfo[id].unitsinfo["npc_dota_demons_spec_golem"].armor + 4
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function DemonsGolemsSquadHealthAndColUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    caster.golems = caster.golems + 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_spec_golem"].health = _G.playersinfo[id].unitsinfo["npc_dota_demons_spec_golem"].health + 500
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function DemonsSwapHeroPusher(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:RemoveAbility("spawn_hero_demons_pusher")
        v:AddAbility("spawn_hero_demons_pusher_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DemonsMeleeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_demons_melee"].abilities["demons_creeps_spec_melee_buff"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_demons_melee"].health + 120
    _G.playersinfo[id].unitsinfo["npc_dota_demons_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_demons_melee"].abilities["attack_speed_pass"] or 0) + 20
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("demons_tower_melee_upgrade")
        v:AddAbility("demons_tower_melee_upgrade_spec_4lvl"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DemonsRangeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_demons_range"].abilities["demons_creeps_spec_range_buff"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_demons_range"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_demons_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_demons_range"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("demons_tower_range_damage_upgrade")
        v:AddAbility("demons_tower_range_damage_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DemonsRangeBuffUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_range"].abilities["demons_creeps_spec_range_buff"] = _G.playersinfo[id].unitsinfo["npc_dota_demons_range"].abilities["demons_creeps_spec_range_buff"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function DemonsMageBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].abilities["demons_creeps_mage_golem"] = 1
    RemoveSpecAbilities(event)
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("demons_tower_mage_upgrade")
        v:AddAbility("demons_tower_mage_upgrade_spec"):SetLevel(1)
    end
end

function DemonsMageUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].abilities["demons_creeps_mage_golem"] = _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].abilities["demons_creeps_mage_golem"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level == 1 then
        _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].abilities["demons_creeps_mage_shadow_word"] = _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].abilities["demons_creeps_mage_shadow_word"] + 1 
    elseif level == 2 then
        _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].abilities["demons_creeps_mage_shadow_word"] = _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].abilities["demons_creeps_mage_shadow_word"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].abilities["demons_creeps_mage_soul_siphon"] = _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].abilities["demons_creeps_mage_soul_siphon"] + 1
    elseif level == 3 then
        _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].abilities["demons_creeps_mage_shadow_word"] = _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].abilities["demons_creeps_mage_shadow_word"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].abilities["demons_creeps_mage_soul_siphon"] = _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].abilities["demons_creeps_mage_soul_siphon"] + 1
        _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].abilities["demons_creeps_mage_lifesteal"] = _G.playersinfo[id].unitsinfo["npc_dota_demons_mage"].abilities["demons_creeps_mage_lifesteal"] + 1
    end
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

--elementals

-- function ElementalsT1T2(event)
--     local caster = event.caster
--     local id = caster:GetPlayerOwnerID()
--     _G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].health + 40
--     _G.playersinfo[id].unitsinfo["npc_dota_elementals_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_elementals_range"].health + 40
--     _G.playersinfo[id].unitsinfo["npc_dota_elementals_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_elementals_mage"].health + 40
--     _G.playersinfo[id].unitsinfo["npc_dota_elementals_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_elementals_arme"].health + 40
--     _G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].armor + 2
--     _G.playersinfo[id].unitsinfo["npc_dota_elementals_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_elementals_range"].armor + 2
--     _G.playersinfo[id].unitsinfo["npc_dota_elementals_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_elementals_mage"].armor + 2
--     _G.playersinfo[id].unitsinfo["npc_dota_elementals_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_elementals_arme"].armor + 2
--     for k, v in pairs(_G.playersinfo[id].towers) do
--         v:RemoveAbility("elementals_tower_range_upgrade")
--         v:AddAbility("elementals_tower_range_upgrade_spec"):SetLevel(1)
--         v:RemoveAbility("elementals_tower_arme_upgrade")
--         v:AddAbility("elementals_tower_arme_upgrade_spec"):SetLevel(1)
--     end
--     RemoveSpecAbilities(event)
-- end

function ElementalsManaPower(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    -- _G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].abilities["elementals_creeps_spec_mana_power"] = 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_elementals_range"].abilities["elementals_creeps_spec_mana_power"] = 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_elementals_mage"].abilities["elementals_creeps_spec_mana_power"] = 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_elementals_arme"].abilities["elementals_creeps_spec_mana_power"] = 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_elementals_air"].abilities["elementals_creeps_spec_mana_power"] = 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_elementals_siege"].abilities["elementals_creeps_spec_mana_power"] = 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_elementals_mage_hero_summon"].abilities["elementals_creeps_spec_mana_power"] = 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_elementals_hero_tank"].abilities["elementals_creeps_spec_mana_power"] = 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_elementals_hero_mage"].abilities["elementals_creeps_spec_mana_power"] = 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_elementals_hero_asassin"].abilities["elementals_creeps_spec_mana_power"] = 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_elementals_hero_pusher"].abilities["elementals_creeps_spec_mana_power"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("elementals_tower_air_boom_upgrade")
        v:AddAbility("elementals_tower_air_boom_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function ElementalsDeathPass(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].abilities["elementals_creeps_spec_tiny_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].health + 160
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("elementals_tower_melee_upgrade")
        v:AddAbility("elementals_tower_melee_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function ElementalsDeathPassUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].abilities["elementals_creeps_spec_death_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].abilities["elementals_creeps_spec_death_pass"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].health + 60
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].abilities["attack_speed_pass"] or 0) + 5
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function ElementalsT2(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_elementals_arme"].health + 115
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_elementals_arme"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_arme"].abilities["elementals_creeps_spec_reflection"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("elementals_tower_arme_armor_upgrade")
        v:AddAbility("elementals_tower_arme_armor_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function ElementalsChaosElement(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].ancient:FindAbilityByName("elementals_race_bonus"):SetLevel(2)
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].health + 40
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_elementals_range"].health + 40
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_elementals_mage"].health + 40
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_elementals_arme"].health + 40
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_elementals_melee"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_elementals_range"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_elementals_mage"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_elementals_arme"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("elementals_tower_range_upgrade")
        v:AddAbility("elementals_tower_range_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("elementals_tower_arme_upgrade")
        v:AddAbility("elementals_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
	caster:AddAbility("elementals_spec_chaos_element_change"):SetLevel(1)
end

function ElementalsChaosElementChange(event)
    local caster = event.caster
    local effects ={"elementals_spec_chaos_element_elementals_fire",
					"elementals_spec_chaos_element_elementals_ice",
					"elementals_spec_chaos_element_elementals_earth",
					"elementals_spec_chaos_element_elementals_air",
					"elementals_spec_chaos_element_elementals_storm",
					"elementals_spec_chaos_element_elementals_void"}

    local random1 = RandomInt(1, #effects)
    local random2 = RandomInt(1, #effects-1)
    if random1 == random2 then
		random2 = random2 + 1
	end
    --local random3 = RandomInt(1, #effects-2)
    --if random3 == random1 then
	--	random3 = random3 + 1
    --    if random3 == random2 then
    --        random3 = random3 + 1
    --    end
    --elseif random3 == random2 then
	--	random3 = random3 + 1
    --    if random3 == random1 then
    --        random3 = random3 + 1
    --    end
	--end
    caster:AddAbility(effects[random1]):SetLevel(1)
    caster:AddAbility(effects[random2]):SetLevel(1)
    --caster:AddAbility(effects[random3]):SetLevel(1)
	caster:FindAbilityByName("elementals_spec_chaos_element_change"):SetLevel(0)
end

function ElementalsChaosElementOld(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
	-- если выбрать спец постройку после выхода крипов, то первый эффект начнётся после таймера
    local effects = {"modifier_elementals_spec_chaos_element_pass_as_buff",
		"modifier_elementals_spec_chaos_element_pass_armor_debuff",
		"modifier_elementals_spec_chaos_element_pass_armor_buff", 
		"modifier_elementals_spec_chaos_element_pass_damage_buff", 
		"modifier_elementals_spec_chaos_element_pass_damage_debuff", 
		"modifier_elementals_spec_chaos_element_pass_mana_castle_debuff", 
		"modifier_elementals_spec_chaos_element_pass_mana_castle_buff", 
		"modifier_elementals_spec_chaos_element_pass_as_towers_buff",
		"modifier_elementals_spec_chaos_element_pass_damage_buildings_debuff",
		"modifier_elementals_spec_chaos_element_pass_hero_armor_debuff",
		"modifier_elementals_spec_chaos_element_pass_hero_armor_buff",
        "modifier_elementals_spec_chaos_element_pass_armor_buildings_buff"}
	-- в таблицу добавляются модификаторы из главной пассивки спец постройки
    local random = RandomInt(1, #effects)
    caster.timer = 180
    RemoveSpecAbilities(event)
	
    if GameRules:State_Get() < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        function caster:StartGame()
            caster.specpass:StartCooldown(caster.timer)
			_G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, caster, effects[random], {})
			if random == 10 or random == 11 then
				_G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, caster, effects[random].."_nothero", {})
			end
            Timers:CreateTimer(caster.timer, function()
                local id = caster:GetPlayerOwnerID()
                if _G.playersinfo[id].alive then
                    random = RandomInt(1, #effects)
					for i = 1, #effects do
						caster:RemoveModifierByName(effects[i])
					end
					caster:RemoveModifierByName(effects[10].."_nothero")
					caster:RemoveModifierByName(effects[11].."_nothero")
					_G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, caster, effects[random], {})
					if random == 10 or random == 11 then
						_G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, caster, effects[random].."_nothero", {})
					end
                    caster.specpass:StartCooldown(caster.timer)
                    return caster.timer
                end
            end)
        end
        table.insert(_G.onstartgame, caster)
    else
        local nowtime = GameRules:GetDOTATime(false, true)
        caster.specpass:StartCooldown(caster.timer)
        Timers:CreateTimer(caster.timer - (nowtime - caster.timer*math.floor(nowtime/caster.timer)), function()
            local id = caster:GetPlayerOwnerID()
            if _G.playersinfo[id].alive then
                random = RandomInt(1, #effects)
				for i = 1, #effects do
					caster:RemoveModifierByName(effects[i])
				end
				caster:RemoveModifierByName(effects[10].."_nothero")
				caster:RemoveModifierByName(effects[11].."_nothero")
				_G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, caster, effects[random], {})
                if random == 10 or random == 11 then
					_G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, caster, effects[random].."_nothero", {})
				end
                caster.specpass:StartCooldown(caster.timer)
                return caster.timer
            end
        end)
    end
    
	caster:AddAbility("elementals_spec_chaos_element_change"):SetLevel(1)
	_G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, _G.playersinfo[id].ancient, "modifier_elementals_spec_chaos_element_pass_ancient", {})
    if _G.playersinfo[id].ancient then
        _G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, _G.playersinfo[id].ancient, "modifier_elementals_spec_chaos_element_pass_builds_regen_buff", {})
	end
    for k, v in pairs(_G.playersinfo[id].baracks) do
        _G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, v, "modifier_elementals_spec_chaos_element_pass_builds_regen_buff", {})
	end
    for k, v in pairs(_G.playersinfo[id].towers) do
        _G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, v, "modifier_elementals_spec_chaos_element_pass_builds_regen_buff", {})
	end
end

function ElementalsChaosElementChangeOld(event)
    -- при нажатии на кнопку смены эффекта
    local caster = event.caster
    local effects = {"elementals_spec_chaos_element_pass_as_buff",
	"elementals_spec_chaos_element_pass_armor_debuff",
	"elementals_spec_chaos_element_pass_armor_buff",
	"elementals_spec_chaos_element_pass_damage_buff",
	"elementals_spec_chaos_element_pass_damage_debuff",
	"elementals_spec_chaos_element_pass_mana_castle_debuff",
	"elementals_spec_chaos_element_pass_mana_castle_buff",
	"elementals_spec_chaos_element_pass_as_towers_buff",
	"elementals_spec_chaos_element_pass_damage_buildings_debuff",
	"elementals_spec_chaos_element_pass_hero_armor_debuff",
	"elementals_spec_chaos_element_pass_hero_armor_buff",
    "elementals_spec_chaos_element_pass_armor_buildings_buff"}

    local random1 = RandomInt(1, #effects)
    local random2 = RandomInt(1, #effects-1)
    if random1 == random2 then
		random2 = random2 + 1
	end
    local random3 = RandomInt(1, #effects-2)
    if random3 == random1 then
		random3 = random3 + 1
        if random3 == random2 then
            random3 = random3 + 1
        end
    elseif random3 == random2 then
		random3 = random3 + 1
        if random3 == random1 then
            random3 = random3 + 1
        end
	end
    caster:AddAbility(effects[random1]):SetLevel(1)
    caster:AddAbility(effects[random2]):SetLevel(1)
    caster:AddAbility(effects[random3]):SetLevel(1)
	caster:FindAbilityByName("elementals_spec_chaos_element_change"):SetLevel(0)
end

function ElementalsChaosElementRefreshOld(event)
    -- после того, как выбрали эффект. Убираем кнопки, предыдущие модификаторы и ставим новый
    local caster = event.caster
	local effect = event.Bonus
	local id = caster:GetPlayerOwnerID()

    local effects = {"elementals_spec_chaos_element_pass_as_buff",
	"elementals_spec_chaos_element_pass_armor_debuff",
	"elementals_spec_chaos_element_pass_armor_buff",
	"elementals_spec_chaos_element_pass_damage_buff",
	"elementals_spec_chaos_element_pass_damage_debuff",
	"elementals_spec_chaos_element_pass_mana_castle_debuff",
	"elementals_spec_chaos_element_pass_mana_castle_buff",
	"elementals_spec_chaos_element_pass_as_towers_buff",
	"elementals_spec_chaos_element_pass_damage_buildings_debuff",
	"elementals_spec_chaos_element_pass_hero_armor_debuff",
	"elementals_spec_chaos_element_pass_hero_armor_buff",
    "elementals_spec_chaos_element_pass_armor_buildings_buff"}
	for i = 1, #effects do
		caster:RemoveModifierByName("modifier_"..effects[i])
		caster:RemoveAbility(effects[i])
	end
	caster:RemoveModifierByName("modifier_"..effects[10].."_nothero")
	caster:RemoveModifierByName("modifier_"..effects[11].."_nothero")
	
	caster:FindAbilityByName("elementals_spec_chaos_element_change"):SetLevel(1)
	_G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, caster, "modifier_"..effect, {})
	if effect == effects[10] or effect == effects[11] then
		_G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, caster, "modifier_"..effect.."_nothero", {})
	end
end

function ElementalsChaosElementBuildingsCreatedOld(event)
	-- создание эффекта для зданий
    local caster = event.caster
	local effect = event.Bonus
	local affect = event.Affect
	local this_id = caster:GetPlayerOwnerID()
	
	for id, playerdata in pairs(_G.playersinfo) do
		if playerdata.alive then
			if affect == "castle" and playerdata.ancient then
				_G.playersinfo[this_id].spec.specpass:ApplyDataDrivenModifier(caster, playerdata.ancient, effect, {})
			elseif affect == "towers" then
				for k, v in pairs(playerdata.towers) do
					_G.playersinfo[this_id].spec.specpass:ApplyDataDrivenModifier(caster, v, effect, {})
				end
			else
				for k, v in pairs(playerdata.towers) do
					_G.playersinfo[this_id].spec.specpass:ApplyDataDrivenModifier(caster, v, effect, {})
				end
				for k, v in pairs(playerdata.baracks) do
					_G.playersinfo[this_id].spec.specpass:ApplyDataDrivenModifier(caster, v, effect, {})
				end
				if playerdata.ancient then
					_G.playersinfo[this_id].spec.specpass:ApplyDataDrivenModifier(caster, playerdata.ancient, effect, {})
				end
			end
		end
	end
end

function ElementalsChaosElementBuildingsDestroyOld(event)
	-- уничтожение эффекта для зданий
    local caster = event.caster
	local effect = event.Bonus
	--local affect = event.Affect
	
	for id, playerdata in pairs(_G.playersinfo) do
		if playerdata.alive then
			--if affect == "castle" and playerdata.ancient then
			--	playerdata.ancient:RemoveModifierByName(effect)
			--elseif affect == "towers" and playerdata.towers then
			--	_G.playersinfo[this_id].spec.specpass:ApplyDataDrivenModifier(caster, playerdata.towers, effect, {})
			--end
			for k, v in pairs(playerdata.towers) do
				v:RemoveModifierByNameAndCaster(effect, caster)
			end
			for k, v in pairs(playerdata.baracks) do
				v:RemoveModifierByNameAndCaster(effect, caster)
			end
			if playerdata.ancient then
				playerdata.ancient:RemoveModifierByNameAndCaster(effect, caster)
			end
		end
	end
end

function ElementalsChaosElementSendMessageOld(event)
    local caster = event.caster
    local ability = event.ability
    local message = event.Name
    
    Timers:CreateTimer(0.1, function()
            local gameEvent = {}
            gameEvent["player_id"] = caster:GetPlayerOwnerID()
            gameEvent["teamnumber"] = -1
            gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_" .. message
            gameEvent["message"] = "#Combat_Message_chaos_element"
            FireGameEvent( "dota_combat_event_message", gameEvent )
    end)
end

function ElementalsT3(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_air"].abilities["elementals_creeps_spec_nova"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_elementals_air"].health + 150
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_air"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_elementals_air"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("elementals_tower_air_upgrade")
        v:AddAbility("elementals_tower_air_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function ElementalsT4(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_siege"].abilities["elementals_creeps_spec_t4"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_siege"].health = _G.playersinfo[id].unitsinfo["npc_dota_elementals_siege"].health + 800
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_siege"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_elementals_siege"].abilities["attack_speed_pass"] or 0) + 15
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("elementals_tower_siege_upgrade")
        v:AddAbility("elementals_tower_siege_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function ElementalsTiny(event)
    local caster = event.caster
    local target = event.target
    local id = caster:GetPlayerOwnerID()
	for k, v in pairs(_G.playersinfo[id].baracks) do
        v.units["npc_dota_elementals_tiny"] = 1
    end

    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("elementals_tower_arme_upgrade")
        v:AddAbility("elementals_tower_arme_upgrade_spec"):SetLevel(1)
    end
    
    RemoveSpecAbilities(event)
end

function ElementalsAntiair(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_range"].abilities["elementals_creeps_range_split_shot"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_elementals_range"].abilities["attack_speed_pass"] or 0) + 30
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_elementals_range"].health + 170
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_range"].bonus_mana_regen = (_G.playersinfo[id].unitsinfo["npc_dota_elementals_range"].bonus_mana_regen or 0) + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("elementals_tower_range_upgrade")
        v:AddAbility("elementals_tower_range_upgrade_spec2"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function ElementalsAntiairUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_elementals_range"].abilities["elementals_creeps_range_split_shot"] = _G.playersinfo[id].unitsinfo["npc_dota_elementals_range"].abilities["elementals_creeps_range_split_shot"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

--diretide

function DiretideMoon(event)
    local caster = event.caster
    local ability = event.ability
    local target = event.target
    local id = caster:GetPlayerOwnerID()
    if target:GetUnitName() ~= "npc_dota_custom_barrack" or caster:GetPlayerOwnerID() ~= target:GetPlayerOwnerID() then
        ability:EndCooldown()
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#dota_hud_error_cant_cast_on_other" })
        return
    end
    target.double_spawn = true
end

function DiretideMoonAddArmor(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
	local team = PlayerResource:GetTeam(id)
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:SetPhysicalArmorBaseValue(v:GetPhysicalArmorBaseValue() + 2)
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("diretide_tower_melee_upgrade")
        v:AddAbility("diretide_tower_melee_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("diretide_tower_arme_upgrade")
        v:AddAbility("diretide_tower_arme_upgrade_spec"):SetLevel(1)
    end
end

function DiretideMoonUpgrade(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1

    local main_abil = caster:FindAbilityByName("diretide_spec_moon_pass")
    main_abil:SetLevel(main_abil:GetLevel()+1)

    if level >= ability:GetMaxLevel() then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function DiretideMeleeBuff(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_melee"].abilities["diretide_creeps_melee_crit"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_melee"].abilities["diretide_creeps_melee_rage"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_diretide_melee"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_diretide_melee"].abilities["attack_speed_pass"] or 0) + 17
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("diretide_tower_melee_upgrade")
        v:AddAbility("diretide_tower_melee_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DiretideT2(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_diretide_arme"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_arme"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_diretide_arme"].abilities["attack_speed_pass"] or 0) + 10
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_arme"].abilities["diretide_creeps_arme_hunger"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("diretide_tower_arme_upgrade")
        v:AddAbility("diretide_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DiretideT3(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_air"].abilities["diretide_creeps_air_siphon"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_diretide_air"].health + 250
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_air"].mana = _G.playersinfo[id].unitsinfo["npc_dota_diretide_air"].mana + 125
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_air"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_diretide_air"].abilities["attack_speed_pass"] or 0) + 12
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("diretide_tower_air_upgrade")
        v:AddAbility("diretide_tower_air_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("diretide_tower_range_upgrade")
        v:AddAbility("diretide_tower_range_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DiretideT3Upgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_air"].abilities["diretide_creeps_air_siphon"] = _G.playersinfo[id].unitsinfo["npc_dota_diretide_air"].abilities["diretide_creeps_air_siphon"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function DiretideT4(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_siege"].abilities["diretide_creeps_siege_void"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_siege"].health = _G.playersinfo[id].unitsinfo["npc_dota_diretide_siege"].health + 700
    -- _G.playersinfo[id].unitsinfo["npc_dota_diretide_siege"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_diretide_siege"].abilities["attack_speed_pass"] or 0) + 30
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("diretide_tower_siege_upgrade")
        v:AddAbility("diretide_tower_siege_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DiretideSplitShot(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_diretide_range"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_range"].abilities["diretide_creeps_range_split_shot"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_diretide_range"].abilities["attack_speed_pass"] or 0) + 15
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("diretide_tower_range_upgrade")
        v:AddAbility("diretide_tower_range_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DiretideT1T2(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("diretide_tower_melee_regen_upgrade")
        v:AddAbility("diretide_tower_melee_regen_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DiretideSouls(event)
    local caster = event.caster
	
    RemoveSpecAbilities(event)
    caster:AddAbility("diretide_spec_soul_exchanger_gold"):SetLevel(1)
    caster:AddAbility("diretide_spec_soul_exchanger_mana"):SetLevel(1)
    caster:AddAbility("diretide_spec_soul_exchanger_candy"):SetLevel(1)
end

function DiretideRiki(event)
    local caster = event.caster
    local target = event.target
    local id = caster:GetPlayerOwnerID()
    if target:GetUnitName() ~= "npc_dota_custom_barrack" or caster:GetPlayerOwnerID() ~= target:GetPlayerOwnerID() then
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#dota_hud_error_cant_cast_on_other" })
        return
    end
    target.units["npc_dota_diretide_riki"] = 2
    RemoveSpecAbilities(event)
end

--frostivus

function FrostivusT1T2(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_melee"].health + 20
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_range"].health + 20
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_mage"].health + 20
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_arme"].health + 20
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_melee"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_range"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_mage"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_arme"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("frostivus_tower_melee_upgrade")
        v:AddAbility("frostivus_tower_melee_upgrade_spec_4lvl"):SetLevel(1)
        v:RemoveAbility("frostivus_tower_arme_upgrade")
        v:AddAbility("frostivus_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function FrostivusMelee(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_melee"].abilities["frostivus_creeps_melee_cleave"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_melee"].health + 85
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_frostivus_melee"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("frostivus_tower_melee_armor_upgrade")
        v:AddAbility("frostivus_tower_melee_armor_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function FrostivusMeleeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_melee"].abilities["frostivus_creeps_melee_cleave"] = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_melee"].abilities["frostivus_creeps_melee_cleave"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 2 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function FrostivusAir(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_air"].health + 200
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_air"].mana = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_air"].mana + 200
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_air"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_frostivus_air"].abilities["attack_speed_pass"] or 0) + 8
    --_G.playersinfo[id].unitsinfo["npc_dota_frostivus_air"].abilities["frostivus_creeps_air_antiair"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_air"].abilities["frostivus_creeps_air_thunder_attack"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("frostivus_tower_air_upgrade")
        v:AddAbility("frostivus_tower_air_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function FrostivusAirUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_air"].abilities["frostivus_creeps_air_thunder_attack"] = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_air"].abilities["frostivus_creeps_air_thunder_attack"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function FrostivusSiege(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_siege"].health = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_siege"].health + 375
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_siege"].mana = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_siege"].mana + 50
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_siege"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_frostivus_siege"].abilities["attack_speed_pass"] or 0) + 40
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_siege"].abilities["frostivus_creeps_siege_damage_aura"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_siege"].abilities["frostivus_creeps_siege_aura"] = 1
    --_G.playersinfo[id].unitsinfo["npc_dota_frostivus_siege"].abilities["frostivus_creeps_siege_slow_attack"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("frostivus_tower_siege_upgrade")
        v:AddAbility("frostivus_tower_siege_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("frostivus_tower_siege_aoe_upgrade")
        v:AddAbility("frostivus_tower_siege_aoe_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function FrostivusRange(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_range"].abilities["frostivus_creeps_range_whirling_axes"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_range"].health + 150
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_range"].mana = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_range"].mana + 50
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_frostivus_range"].abilities["attack_speed_pass"] or 0) + 11
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("frostivus_tower_range_upgrade")
        v:AddAbility("frostivus_tower_range_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function FrostivusRangeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_range"].abilities["frostivus_creeps_range_whirling_axes"] = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_range"].abilities["frostivus_creeps_range_whirling_axes"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function FrostivusTusk(event)
    local caster = event.caster
    local target = event.target
    local id = caster:GetPlayerOwnerID()
    if target:GetUnitName() ~= "npc_dota_custom_barrack" or caster:GetPlayerOwnerID() ~= target:GetPlayerOwnerID() then
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#dota_hud_error_cant_cast_on_other" })
        return
    end
    target.units["npc_dota_frostivus_tusk"] = 2

    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("frostivus_tower_melee_upgrade")
        v:AddAbility("frostivus_tower_melee_upgrade_spec_4lvl"):SetLevel(1)
    end
    
    RemoveSpecAbilities(event)
end

function FrostivusArme(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_arme"].abilities["frostivus_creeps_arme_block_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_arme"].health + 115
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_arme"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("frostivus_tower_arme_upgrade")
        v:AddAbility("frostivus_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function FrostivusArmeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_frostivus_arme"].abilities["frostivus_creeps_arme_block_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_frostivus_arme"].abilities["frostivus_creeps_arme_block_pass"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

--dragons

function DragonsT1T2(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_dragons_melee"].health + 30
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_dragons_range"].health + 30
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].health + 30
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_dragons_arme"].health + 30
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_dragons_melee"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_dragons_range"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_dragons_arme"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("dragons_tower_melee_upgrade")
        v:AddAbility("dragons_tower_melee_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("dragons_tower_range_upgrade")
        v:AddAbility("dragons_tower_range_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DragonsT1T2Upgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    local ability = event.ability
    local level = ability:GetLevel()
    _G.playersinfo[id].ancient:FindAbilityByName("dragons_race_bonus"):SetLevel(level + 1)
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function DragonsMelee(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_melee"].abilities["dragons_creeps_melee_heal_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_dragons_melee"].armor + 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_dragons_melee"].abilities["dragons_creeps_melee_ministun"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_dragons_melee"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_dragons_melee"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("dragons_tower_melee_fire_upgrade")
        v:AddAbility("dragons_tower_melee_fire_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("dragons_tower_melee_upgrade")
        v:AddAbility("dragons_tower_melee_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DragonsMeleeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_melee"].abilities["dragons_creeps_melee_heal_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_dragons_melee"].abilities["dragons_creeps_melee_heal_pass"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_melee"].abilities["dragons_creeps_melee_ministun"] = _G.playersinfo[id].unitsinfo["npc_dota_dragons_melee"].abilities["dragons_creeps_melee_ministun"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function DragonsAir(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_dragons_air"].health + 400
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_air"].mana = _G.playersinfo[id].unitsinfo["npc_dota_dragons_air"].mana + 50
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_air"].bonus_mana_regen = (_G.playersinfo[id].unitsinfo["npc_dota_dragons_air"].bonus_mana_regen or 0) + 4
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_air"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_dragons_air"].abilities["attack_speed_pass"] or 0) + 20
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_air"].abilities["dragons_creeps_air_antiair"] = 1
    --_G.playersinfo[id].unitsinfo["npc_dota_dragons_air"].abilities["dragons_creeps_air_aoe_attack"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("dragons_tower_air_fireball_upgrade")
        v:AddAbility("dragons_tower_air_fireball_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DragonsDay(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    if GameRules:State_Get() < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        function caster:StartGame()
            Timers:CreateTimer(120, function()
                GameRules:SetTimeOfDay(0.35)
                return 660
            end)
        end
        table.insert(_G.onstartgame, caster)
    else
        local nowtime = GameRules:GetDOTATime(false, true)
        Timers:CreateTimer(120 - nowtime, function()
            GameRules:SetTimeOfDay(0.35)
            return 660
        end)
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("dragons_tower_air_upgrade")
        v:AddAbility("dragons_tower_air_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
    caster:AddAbility("dragons_spec_day_upgrade"):SetLevel(1)
end

function DragonsDayUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].spec.specpass:SetLevel(_G.playersinfo[id].spec.specpass:GetLevel()+1)
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function DragonsRange(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_range"].bonus_mana_regen = (_G.playersinfo[id].unitsinfo["npc_dota_dragons_range"].bonus_mana_regen or 0) + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_range"].abilities["dragons_creeps_range_fire_breathe"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_dragons_range"].health + 105
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_range"].mana = _G.playersinfo[id].unitsinfo["npc_dota_dragons_range"].mana + 50
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_dragons_range"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("dragons_tower_range_upgrade")
        v:AddAbility("dragons_tower_range_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DragonsRangeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_range"].abilities["dragons_creeps_range_fire_breathe"] = _G.playersinfo[id].unitsinfo["npc_dota_dragons_range"].abilities["dragons_creeps_range_fire_breathe"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function DragonsArme(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_dragons_arme"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_arme"].mana = _G.playersinfo[id].unitsinfo["npc_dota_dragons_arme"].mana + 50
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_dragons_arme"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_arme"].abilities["dragons_creeps_arme_cooldown"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_arme"].abilities["dragons_creeps_arme_helix"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("dragons_tower_arme_upgrade")
        v:AddAbility("dragons_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DragonsArmeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_dragons_arme"].health + 50
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_arme"].abilities["dragons_creeps_arme_cooldown"] = _G.playersinfo[id].unitsinfo["npc_dota_dragons_arme"].abilities["dragons_creeps_arme_cooldown"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_arme"].abilities["dragons_creeps_arme_helix"] = _G.playersinfo[id].unitsinfo["npc_dota_dragons_arme"].abilities["dragons_creeps_arme_helix"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function DragonsSwapHeroMage(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:RemoveAbility("spawn_hero_dragons_mage")
        v:AddAbility("spawn_hero_dragons_mage_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function DragonsMage(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].health + 80
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].mana = _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].mana + 50
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].abilities["dragons_creeps_mage_cleave"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].abilities["attack_speed_pass"] or 0) + 5
    RemoveSpecAbilities(event)
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("dragons_tower_mage_upgrade")
        v:AddAbility("dragons_tower_mage_upgrade_spec"):SetLevel(1)
    end
end

function DragonsMageUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].abilities["dragons_creeps_mage_cleave"] = _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].abilities["dragons_creeps_mage_cleave"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].abilities["attack_speed_pass"] or 0) + 5
    local ability = event.ability
    local level = ability:GetLevel()
    if level == 1 then 
        _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].abilities["dragons_creeps_mage_fire_attack"] = _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].abilities["dragons_creeps_mage_fire_attack"] + 1 
    elseif level == 2 then 
        _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].abilities["dragons_creeps_mage_fire_attack"] = _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].abilities["dragons_creeps_mage_fire_attack"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].abilities["dragons_creeps_mage_lifesteal"] = _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].abilities["dragons_creeps_mage_lifesteal"] + 1
    elseif level == 3 then
        _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].abilities["dragons_creeps_mage_fire_attack"] = _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].abilities["dragons_creeps_mage_fire_attack"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].abilities["dragons_creeps_mage_lifesteal"] = _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].abilities["dragons_creeps_mage_lifesteal"] + 1
        _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].abilities["dragons_creeps_mage_blizzard"] = _G.playersinfo[id].unitsinfo["npc_dota_dragons_mage"].abilities["dragons_creeps_mage_blizzard"] + 1
    end
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

--beastmen

function BeastmenT1T2(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_melee"].health + 20
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_range"].health + 20
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].health + 20
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_arme"].health + 20
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_melee"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_range"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_arme"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("beastmen_tower_air_attack_upgrade")
        v:AddAbility("beastmen_tower_air_attack_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("beastmen_tower_melee_arme_upgrade")
        v:AddAbility("beastmen_tower_melee_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function BeastmenT1T2Upgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    local ability = event.ability
    local level = ability:GetLevel()
    _G.playersinfo[id].ancient:SetModifierStackCount("modifier_beastmen_race_bonus", _G.playersinfo[id].ancient, level)
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function BeastmenMelee(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_melee"].abilities["beastmen_creeps_melee_quill"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_melee"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_beastmen_melee"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("beastmen_tower_melee_upgrade")
        v:AddAbility("beastmen_tower_melee_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function BeastmenMeleeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_melee"].abilities["beastmen_creeps_melee_quill"] = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_melee"].abilities["beastmen_creeps_melee_quill"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function BeastmenArme(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_arme"].bonus_mana_regen = (_G.playersinfo[id].unitsinfo["npc_dota_beastmen_arme"].bonus_mana_regen or 0) + 1
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_arme"].abilities["beastmen_creeps_arme_concentration"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_arme"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_arme"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("beastmen_tower_arme_upgrade")
        v:AddAbility("beastmen_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function BeastmenArmeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_arme"].abilities["beastmen_creeps_arme_concentration"] = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_arme"].abilities["beastmen_creeps_arme_concentration"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function BeastmenRange(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_range"].abilities["beastmen_creeps_range_boomerang"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_range"].bonus_mana_regen = (_G.playersinfo[id].unitsinfo["npc_dota_beastmen_range"].bonus_mana_regen or 0) + 0.5
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_range"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_beastmen_range"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("beastmen_tower_range_upgrade")
        v:AddAbility("beastmen_tower_range_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function BeastmenRangeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_range"].abilities["beastmen_creeps_range_boomerang"] = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_range"].abilities["beastmen_creeps_range_boomerang"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function BeastmenAir(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    --_G.playersinfo[id].unitsinfo["npc_dota_beastmen_air"].abilities["beastmen_creeps_air_seed"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_air"].abilities["beastmen_creeps_air_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_air"].abilities["beastmen_creeps_air_lifesteal"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_air"].health + 200
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_air"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_beastmen_air"].abilities["attack_speed_pass"] or 0) + 15
    RemoveSpecAbilities(event)
end

function BeastmenAirUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_air"].abilities["beastmen_creeps_air_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_air"].abilities["beastmen_creeps_air_pass"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_air"].abilities["beastmen_creeps_air_lifesteal"] = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_air"].abilities["beastmen_creeps_air_lifesteal"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function BeastmenMage(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].health + 50
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].mana = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].mana + 65
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].min_damage = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].min_damage + 8
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].max_damage = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].max_damage + 8
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].abilities["beastmen_creeps_mage_attack"] = 1
    RemoveSpecAbilities(event)
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("beastmen_tower_mage_upgrade")
        v:AddAbility("beastmen_tower_mage_upgrade_spec"):SetLevel(1)
    end
end

function BeastmenMageUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].bonus_mana_regen = (_G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].bonus_mana_regen or 0) + 1
    _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].abilities["beastmen_creeps_mage_attack"] = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].abilities["beastmen_creeps_mage_attack"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level == 1 then 
        _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].abilities["beastmen_creeps_mage_crit"] = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].abilities["beastmen_creeps_mage_crit"] + 1 
    elseif level == 2 then 
        _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].abilities["beastmen_creeps_mage_crit"] = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].abilities["beastmen_creeps_mage_crit"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].abilities["beastmen_creeps_mage_armor"] = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].abilities["beastmen_creeps_mage_armor"] + 1
    elseif level == 3 then
        _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].abilities["beastmen_creeps_mage_crit"] = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].abilities["beastmen_creeps_mage_crit"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].abilities["beastmen_creeps_mage_armor"] = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].abilities["beastmen_creeps_mage_armor"] + 1
        _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].abilities["beastmen_creeps_mage_roar"] = _G.playersinfo[id].unitsinfo["npc_dota_beastmen_mage"].abilities["beastmen_creeps_mage_roar"] + 1
    end
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function BeastmenSwapHeroMage(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:RemoveAbility("spawn_hero_beastmen_mage")
        v:AddAbility("spawn_hero_beastmen_mage_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

--primordials

function PrimordialsT1T2Mage(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].armor + 3
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].armor + 3
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_primordials_mage"].armor + 3
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].armor + 3
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].abilities["attack_speed_pass"] or 0) + 10
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].abilities["attack_speed_pass"] or 0) + 10
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_mage"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_primordials_mage"].abilities["attack_speed_pass"] or 0) + 10
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].abilities["attack_speed_pass"] or 0) + 10
    
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_hero_mage"].abilities["primordials_spec_hero_mage_damage_pass"] = 1
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:FindAbilityByName("spawn_hero_primordials_tank"):SetLevel(2)
        v:FindAbilityByName("spawn_hero_primordials_mage"):SetLevel(2)
        v:FindAbilityByName("spawn_hero_primordials_asassin"):SetLevel(2)
        v:FindAbilityByName("spawn_hero_primordials_pusher"):SetLevel(2)
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("primordials_tower_mage_upgrade")
        v:AddAbility("primordials_tower_mage_upgrade_spec"):SetLevel(1)
        -- v:RemoveAbility("primordials_tower_air_upgrade")
        -- v:AddAbility("primordials_tower_air_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function PrimordialsT1T2MageUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_hero_mage"].abilities["primordials_spec_hero_mage_damage_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_primordials_hero_mage"].abilities["primordials_spec_hero_mage_damage_pass"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].abilities["attack_speed_pass"] or 0) + 7
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].abilities["attack_speed_pass"] or 0) + 7
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_mage"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_primordials_mage"].abilities["attack_speed_pass"] or 0) + 7
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].abilities["attack_speed_pass"] or 0) + 7
    local ability = event.ability
    local level = ability:GetLevel()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:FindAbilityByName("spawn_hero_primordials_tank"):SetLevel(2 + level)
        v:FindAbilityByName("spawn_hero_primordials_mage"):SetLevel(2 + level)
        v:FindAbilityByName("spawn_hero_primordials_asassin"):SetLevel(2 + level)
        v:FindAbilityByName("spawn_hero_primordials_pusher"):SetLevel(2 + level)
    end
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function PrimordialsT1T2Tank(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].health + 70
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].health + 70
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_primordials_mage"].health + 70
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].health + 70
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].armor + 2
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].armor + 2
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_primordials_mage"].armor + 2
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].armor + 2
    
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_hero_tank"].abilities["primordials_spec_hero_tank_block_pass"] = 1
    RemoveSpecAbilities(event)
    for k, v in pairs(_G.playersinfo[id].towers) do
        _G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, v, "modifier_primordials_spec_t1t2_tank_pass_hp_regen", {})
    end
    for k, v in pairs(_G.playersinfo[id].baracks) do
        _G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, v, "modifier_primordials_spec_t1t2_tank_pass_hp_regen", {})
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("primordials_tower_melee_upgrade")
        v:AddAbility("primordials_tower_melee_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("primordials_tower_arme_upgrade")
        v:AddAbility("primordials_tower_arme_upgrade_spec"):SetLevel(1)
    end
    _G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, _G.playersinfo[id].ancient, "modifier_primordials_spec_t1t2_tank_pass_hp_regen", {})
end

function PrimordialsT1T2TankUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_hero_tank"].abilities["primordials_spec_hero_tank_block_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_primordials_hero_tank"].abilities["primordials_spec_hero_tank_block_pass"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].health + 25
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].health + 25
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_primordials_mage"].health + 25
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].health + 25
    
    _G.playersinfo[id].spec.specpass:SetLevel(_G.playersinfo[id].spec.specpass:GetLevel()+1)
    for k, v in pairs(_G.playersinfo[id].towers) do
        _G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, v, "modifier_primordials_spec_t1t2_tank_pass_hp_regen", {})
    end
    for k, v in pairs(_G.playersinfo[id].baracks) do
        _G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, v, "modifier_primordials_spec_t1t2_tank_pass_hp_regen", {})
    end
    _G.playersinfo[id].spec.specpass:ApplyDataDrivenModifier(caster, _G.playersinfo[id].ancient, "modifier_primordials_spec_t1t2_tank_pass_hp_regen", {})
    
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function PrimordialsT1T2Asassin(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].armor + 2
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].armor + 2
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_primordials_mage"].armor + 2
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].armor + 2
    
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_hero_asassin"].abilities["primordials_spec_hero_asassin_damage_pass"] = 1
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:FindAbilityByName("spawn_hero_primordials_tank"):SetLevel(6)
        v:FindAbilityByName("spawn_hero_primordials_mage"):SetLevel(6)
        v:FindAbilityByName("spawn_hero_primordials_asassin"):SetLevel(6)
        v:FindAbilityByName("spawn_hero_primordials_pusher"):SetLevel(6)
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("primordials_tower_range_upgrade")
        v:AddAbility("primordials_tower_range_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("primordials_tower_range_death_upgrade")
        v:AddAbility("primordials_tower_range_death_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
    caster:AddAbility("primordials_spec_t1t2_asassin_upgrade"):SetLevel(1)
end

function PrimordialsT1T2AsassinUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].spec.specpass:SetLevel(_G.playersinfo[id].spec.specpass:GetLevel()+1)
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_hero_asassin"].abilities["primordials_spec_hero_asassin_damage_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_primordials_hero_asassin"].abilities["primordials_spec_hero_asassin_damage_pass"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:FindAbilityByName("spawn_hero_primordials_tank"):SetLevel(6 + level)
        v:FindAbilityByName("spawn_hero_primordials_mage"):SetLevel(6 + level)
        v:FindAbilityByName("spawn_hero_primordials_asassin"):SetLevel(6 + level)
        v:FindAbilityByName("spawn_hero_primordials_pusher"):SetLevel(6 + level)
    end
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function PrimordialsMelee(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].abilities["primordials_creeps_melee_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].health + 150
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("primordials_tower_melee_upgrade")
        v:AddAbility("primordials_tower_melee_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function PrimordialsMeleeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].abilities["primordials_creeps_melee_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_primordials_melee"].abilities["primordials_creeps_melee_pass"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function PrimordialsRange(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    --_G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].abilities["primordials_creeps_range_terrorwave"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].abilities["primordials_creeps_range_illusion"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].health + 150
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].abilities["attack_speed_pass"] or 0) + 20
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("primordials_tower_range_upgrade")
        v:AddAbility("primordials_tower_range_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("primordials_tower_range_death_upgrade")
        v:AddAbility("primordials_tower_range_death_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function PrimordialsRangeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].abilities["primordials_creeps_range_illusion"] = _G.playersinfo[id].unitsinfo["npc_dota_primordials_range"].abilities["primordials_creeps_range_illusion"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function PrimordialsThunderGod(event)
    local caster = event.caster
    --local id = caster:GetPlayerOwnerID()
	--local team = PlayerResource:GetTeam(id)
    RemoveSpecAbilities(event)
    caster:AddAbility("primordials_spec_towers_thundergod"):SetLevel(1)
end

function PrimordialsThunderGod_OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()

    ability:SetLevel(_G.playersinfo[id].ancient:GetLevel())

    function ability:OnBuildingUpgrade(keys)
        local building = EntIndexToHScript( keys.building )
        if id == building:GetPlayerOwnerID() and building:GetUnitName() == "npc_dota_custom_ancient" then
            ability:SetLevel(building:GetLevel())
        end
    end

    ListenToGameEvent('building_upgrade', ability.OnBuildingUpgrade, ability)
end

function PrimordialsThunderGod_OnDestroy(event)
    local ability = event.ability
    
    StopListeningToAllGameEvents(ability)
end

function PrimordialsSwapHeroMage(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:RemoveAbility("spawn_hero_primordials_mage")
        v:AddAbility("spawn_hero_primordials_mage_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function PrimordialsArme(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].abilities["primordials_creeps_arme_rebuke"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("primordials_tower_arme_upgrade")
        v:AddAbility("primordials_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function PrimordialsArmeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].abilities["primordials_creeps_arme_rebuke"] = _G.playersinfo[id].unitsinfo["npc_dota_primordials_arme"].abilities["primordials_creeps_arme_rebuke"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function PrimordialsSiege(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_siege"].abilities["primordials_creeps_siege_spec"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_siege"].health = _G.playersinfo[id].unitsinfo["npc_dota_primordials_siege"].health + 350
    _G.playersinfo[id].unitsinfo["npc_dota_primordials_siege"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_primordials_siege"].abilities["attack_speed_pass"] or 0) + 30
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("primordials_tower_siege_upgrade")
        v:AddAbility("primordials_tower_siege_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

--invaders

function InvadersT1T2(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_invaders_melee"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_invaders_range"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].health +   100
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_invaders_arme"].health +   100
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_invaders_melee"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_invaders_range"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_invaders_arme"].armor + 1

    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:FindAbilityByName("spawn_hero_invaders_tank"):SetLevel(2)
        v:FindAbilityByName("spawn_hero_invaders_mage"):SetLevel(2)
        v:FindAbilityByName("spawn_hero_invaders_asassin"):SetLevel(2)
        v:FindAbilityByName("spawn_hero_invaders_pusher"):SetLevel(2)
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("invaders_tower_arme_upgrade")
        v:AddAbility("invaders_tower_arme_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("invaders_tower_range_upgrade")
        v:AddAbility("invaders_tower_range_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function InvadersMelee(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_melee"].abilities["invaders_creeps_melee_shield"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_invaders_melee"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_invaders_melee"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("invaders_tower_melee_upgrade")
        v:AddAbility("invaders_tower_melee_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function InvadersMeleeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_melee"].abilities["invaders_creeps_melee_shield"] = _G.playersinfo[id].unitsinfo["npc_dota_invaders_melee"].abilities["invaders_creeps_melee_shield"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function InvadersArme(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_arme"].abilities["invaders_creeps_arme_block_pass"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_invaders_arme"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_invaders_arme"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("invaders_tower_arme_upgrade")
        v:AddAbility("invaders_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function InvadersArmeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_arme"].abilities["invaders_creeps_arme_block_pass"] = _G.playersinfo[id].unitsinfo["npc_dota_invaders_arme"].abilities["invaders_creeps_arme_block_pass"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function InvadersAir(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_air"].abilities["invaders_creeps_air_stone"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_invaders_air"].health + 200
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_air"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_invaders_air"].abilities["attack_speed_pass"] or 0) + 15
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("invaders_tower_air_upgrade")
        v:AddAbility("invaders_tower_air_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("invaders_tower_air_blast_upgrade")
        v:AddAbility("invaders_tower_air_blast_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function InvadersRange(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_range"].abilities["invaders_creeps_range_armor"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_invaders_range"].health + 110
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_invaders_range"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("invaders_tower_range_upgrade")
        v:AddAbility("invaders_tower_range_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function InvadersRangeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_range"].abilities["invaders_creeps_range_armor"] = _G.playersinfo[id].unitsinfo["npc_dota_invaders_range"].abilities["invaders_creeps_range_armor"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function InvadersMage(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].health + 50
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].mana = _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].mana + 65
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].bonus_mana_regen = (_G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].bonus_mana_regen or 0) + 2
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].min_damage = _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].min_damage + 7
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].max_damage = _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].max_damage + 7
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].abilities["invaders_creeps_mage_armor"] = 1
    RemoveSpecAbilities(event)
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("invaders_tower_mage_upgrade")
        v:AddAbility("invaders_tower_mage_upgrade_spec"):SetLevel(1)
    end
end

function InvadersMageUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].abilities["invaders_creeps_mage_armor"] = _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].abilities["invaders_creeps_mage_armor"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].bonus_mana_regen = (_G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].bonus_mana_regen or 0) + 2
    local ability = event.ability
    local level = ability:GetLevel()
    if level == 1 then 
        _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].abilities["invaders_creeps_mage_brain_sap"] = _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].abilities["invaders_creeps_mage_brain_sap"] + 1 
    elseif level == 2 then 
        _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].abilities["invaders_creeps_mage_brain_sap"] = _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].abilities["invaders_creeps_mage_brain_sap"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].abilities["invaders_creeps_mage_surge"] = _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].abilities["invaders_creeps_mage_surge"] + 1
    elseif level == 3 then
        _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].abilities["invaders_creeps_mage_brain_sap"] = _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].abilities["invaders_creeps_mage_brain_sap"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].abilities["invaders_creeps_mage_surge"] = _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].abilities["invaders_creeps_mage_surge"] + 1
        _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].abilities["invaders_creeps_mage_nightmare"] = _G.playersinfo[id].unitsinfo["npc_dota_invaders_mage"].abilities["invaders_creeps_mage_nightmare"] + 1
    end
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function InvadersSwapHeroMage(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:RemoveAbility("spawn_hero_invaders_tank")
        v:AddAbility("spawn_hero_invaders_tank_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

--cultists

function CultistsMelee(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_melee"].abilities["cultists_creeps_melee_spec_heal"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_melee"].health + 175
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("cultists_tower_melee_upgrade")
        v:AddAbility("cultists_tower_melee_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function CultistsRange(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_range"].abilities["cultists_creeps_range_aoe"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_range"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_cultists_range"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("cultists_tower_range_upgrade")
        v:AddAbility("cultists_tower_range_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function CultistsRangeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_range"].abilities["cultists_creeps_range_aoe"] = _G.playersinfo[id].unitsinfo["npc_dota_cultists_range"].abilities["cultists_creeps_range_aoe"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function CultistsMage(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].health + 75
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].abilities["attack_speed_pass"] or 0) + 5
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].abilities["cultists_creeps_mage_death"] = 1
    RemoveSpecAbilities(event)
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("cultists_tower_mage_upgrade")
        v:AddAbility("cultists_tower_mage_upgrade_spec"):SetLevel(1)
    end
end

function CultistsMageUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].abilities["cultists_creeps_mage_death"] = _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].abilities["cultists_creeps_mage_death"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level == 1 then 
        _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].abilities["cultists_creeps_mage_brain_sap"] = _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].abilities["cultists_creeps_mage_brain_sap"] + 1 
    elseif level == 2 then 
        _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].abilities["cultists_creeps_mage_brain_sap"] = _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].abilities["cultists_creeps_mage_brain_sap"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].abilities["cultists_creeps_mage_aoe"] = _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].abilities["cultists_creeps_mage_aoe"] + 1
    elseif level == 3 then
        _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].abilities["cultists_creeps_mage_brain_sap"] = _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].abilities["cultists_creeps_mage_brain_sap"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].abilities["cultists_creeps_mage_aoe"] = _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].abilities["cultists_creeps_mage_aoe"] + 1
        _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].abilities["cultists_creeps_mage_denay"] = _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].abilities["cultists_creeps_mage_denay"] + 1
    end
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function CultistsArme(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme"].abilities["cultists_creeps_arme_rage"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme"].health + 150
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("cultists_tower_arme_upgrade")
        v:AddAbility("cultists_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function CultistsArmeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme"].abilities["cultists_creeps_arme_rage"] = _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme"].abilities["cultists_creeps_arme_rage"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function CultistsArmeSwap(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v.units["npc_dota_cultists_arme_spec"] = v.units["npc_dota_cultists_arme"]
        v.units["npc_dota_cultists_arme"] = nil
        local charges = 2
        for x=0, 5 do
            local item = v:GetItemInSlot(x)
            if item and item:GetAbilityName() == "item_cultists_arme" then
                charges = item:GetCurrentCharges()
                v:RemoveItem(item)
            end
        end
        if v:GetLevel() > 1 then
            local new_item = v:AddItemByName("item_cultists_arme_spec")
            new_item:SetCurrentCharges(charges)
        end
    end
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme_spec"].abilities["cultists_creeps_arme_swap_range"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme_spec"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_cultists_arme_spec"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("cultists_tower_arme_upgrade")
        v:AddAbility("cultists_tower_arme_upgrade_spec"):SetLevel(1)
    end
    ability:ApplyDataDrivenModifier(caster, _G.playersinfo[id].ancient, "modifiers_cultists_spec_arme_swap_pass_grade_gold", {})
    RemoveSpecAbilities(event)
end

function CultistsArmeSwapUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme_spec"].abilities["cultists_creeps_arme_swap_range"] = _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme_spec"].abilities["cultists_creeps_arme_swap_range"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function CultistsT1T2(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_melee"].health + 20
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_range"].health + 20
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].health + 20
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme"].health + 20
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_cultists_melee"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_cultists_range"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme"].armor + 1

    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("cultists_tower_melee_arme_upgrade")
        v:AddAbility("cultists_tower_melee_arme_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("cultists_tower_air_aura_upgrade")
        v:AddAbility("cultists_tower_air_aura_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function CultistsAir(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_air"].abilities["cultists_creeps_air_fear"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_air"].health + 250
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_air"].armor = _G.playersinfo[id].unitsinfo["npc_dota_cultists_air"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("cultists_tower_air_upgrade")
        v:AddAbility("cultists_tower_air_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function CultistsAirUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_air"].abilities["cultists_creeps_air_fear"] = _G.playersinfo[id].unitsinfo["npc_dota_cultists_air"].abilities["cultists_creeps_air_fear"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

--pirates

function PiratesMeleeSwap(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v.units["npc_dota_pirates_melee_spec"] = v.units["npc_dota_pirates_melee"]
        v.units["npc_dota_pirates_melee"] = nil
        local charges = 2
        for x=0, 5 do
            local item = v:GetItemInSlot(x)
            if item and item:GetAbilityName() == "item_pirates_melee" then
                charges = item:GetCurrentCharges()
                v:RemoveItem(item)
            end
        end
        local new_item = v:AddItemByName("item_pirates_melee_spec")
        new_item:SetCurrentCharges(charges)
    end
    --_G.playersinfo[id].unitsinfo["npc_dota_pirates_melee_spec"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_pirates_melee_spec"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("pirates_tower_melee_upgrade")
        v:AddAbility("pirates_tower_melee_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function PiratesMelee(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_melee"].abilities["pirates_creeps_melee_hook"] = 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_pirates_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_pirates_melee"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_pirates_melee"].health + 50
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_melee"].mana = _G.playersinfo[id].unitsinfo["npc_dota_pirates_melee"].mana + 100
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_melee"].bonus_mana_regen = (_G.playersinfo[id].unitsinfo["npc_dota_pirates_melee"].bonus_mana_regen or 0) + 2
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("pirates_tower_melee_ats_upgrade")
        v:AddAbility("pirates_tower_melee_ats_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function PiratesRange(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_range"].abilities["pirates_creeps_range_ats"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_pirates_range"].health + 80
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_pirates_range"].abilities["attack_speed_pass"] or 0) + 15
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("pirates_tower_range_upgrade")
        v:AddAbility("pirates_tower_range_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("pirates_tower_melee_arme_upgrade")
        v:AddAbility("pirates_tower_melee_arme_upgrade_spec_range"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function PiratesMage(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].health + 75
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].mana = _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].mana + 50
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].bonus_mana_regen = (_G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].bonus_mana_regen or 0) + 4
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].abilities["pirates_creeps_mage_molotov"] = 1
    RemoveSpecAbilities(event)
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("pirates_tower_mage_upgrade")
        v:AddAbility("pirates_tower_mage_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("pirates_tower_melee_arme_upgrade")
        v:AddAbility("pirates_tower_melee_arme_upgrade_spec_mage"):SetLevel(1)
    end
end

function PiratesMageUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].abilities["pirates_creeps_mage_molotov"] = _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].abilities["pirates_creeps_mage_molotov"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level == 1 then
        _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].abilities["pirates_creeps_mage_cask"] = _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].abilities["pirates_creeps_mage_cask"] + 1 
    elseif level == 2 then
        _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].abilities["pirates_creeps_mage_cask"] = _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].abilities["pirates_creeps_mage_cask"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].abilities["pirates_creeps_mage_dinner"] = _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].abilities["pirates_creeps_mage_dinner"] + 1
    elseif level == 3 then
        _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].abilities["pirates_creeps_mage_cask"] = _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].abilities["pirates_creeps_mage_cask"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].abilities["pirates_creeps_mage_dinner"] = _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].abilities["pirates_creeps_mage_dinner"] + 1
        _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].abilities["pirates_creeps_mage_chest"] = _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].abilities["pirates_creeps_mage_chest"] + 1
    end
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function PiratesArme(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_arme"].abilities["pirates_creeps_arme_cleave"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_pirates_arme"].health + 125
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_pirates_arme"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("pirates_tower_arme_upgrade")
        v:AddAbility("pirates_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function PiratesArmeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_pirates_arme"].health + 50
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_arme"].abilities["pirates_creeps_arme_cleave"] = _G.playersinfo[id].unitsinfo["npc_dota_pirates_arme"].abilities["pirates_creeps_arme_cleave"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function PiratesT1T2(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_pirates_melee"].health + 20
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_pirates_range"].health + 20
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].health + 20
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_pirates_arme"].health + 20
    -- _G.playersinfo[id].unitsinfo["npc_dota_pirates_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_pirates_melee"].armor + 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_pirates_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_pirates_range"].armor + 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_pirates_mage"].armor + 1
    -- _G.playersinfo[id].unitsinfo["npc_dota_pirates_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_pirates_arme"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_melee"].abilities["pirates_creeps_arme_marauder_spec"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_arme"].abilities["pirates_creeps_arme_marauder_spec"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("pirates_tower_melee_arme_upgrade")
        v:AddAbility("pirates_tower_melee_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function PiratesT1T2Upgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_melee"].abilities["pirates_creeps_arme_marauder_spec"] = _G.playersinfo[id].unitsinfo["npc_dota_pirates_melee"].abilities["pirates_creeps_arme_marauder_spec"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_arme"].abilities["pirates_creeps_arme_marauder_spec"] = _G.playersinfo[id].unitsinfo["npc_dota_pirates_arme"].abilities["pirates_creeps_arme_marauder_spec"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function PiratesAir(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_air"].abilities["pirates_creeps_air_antihero"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_pirates_air"].health + 150
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_air"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_pirates_air"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("pirates_tower_air_upgrade")
        v:AddAbility("pirates_tower_air_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("pirates_tower_melee_arme_upgrade")
        v:AddAbility("pirates_tower_melee_arme_upgrade_spec_air"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function PiratesAirUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_air"].abilities["pirates_creeps_air_antihero"] = _G.playersinfo[id].unitsinfo["npc_dota_pirates_air"].abilities["pirates_creeps_air_antihero"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function PiratesSiege(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_siege"].abilities["pirates_creeps_siege_spec"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_siege"].health = _G.playersinfo[id].unitsinfo["npc_dota_pirates_siege"].health + 450
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_siege"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_pirates_siege"].abilities["attack_speed_pass"] or 0) + 30
    _G.playersinfo[id].unitsinfo["npc_dota_pirates_siege"].bonus_mana_regen = (_G.playersinfo[id].unitsinfo["npc_dota_pirates_siege"].bonus_mana_regen or 0) + 2
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("pirates_tower_siege_upgrade")
        v:AddAbility("pirates_tower_siege_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("pirates_tower_melee_arme_upgrade")
        v:AddAbility("pirates_tower_melee_arme_upgrade_spec_siege"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

--nights

function NightsMeleeSwap(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v.units["npc_dota_nights_melee_spec"] = v.units["npc_dota_nights_melee"]
        v.units["npc_dota_nights_melee"] = nil
        local charges = 2
        for x=0, 5 do
            local item = v:GetItemInSlot(x)
            if item and item:GetAbilityName() == "item_nights_melee" then
                charges = item:GetCurrentCharges()
                v:RemoveItem(item)
            end
        end
        local new_item = v:AddItemByName("item_nights_melee_spec")
        new_item:SetCurrentCharges(charges)
    end
    --_G.playersinfo[id].unitsinfo["npc_dota_nights_melee_spec"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_nights_melee_spec"].abilities["attack_speed_pass"] or 0) + 10
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("nights_tower_melee_upgrade")
        v:AddAbility("nights_tower_melee_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function NightsMelee(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_nights_melee"].abilities["nights_creeps_melee_crit"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_nights_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_nights_melee"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_nights_melee"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_nights_melee"].abilities["attack_speed_pass"] or 0) + 15
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("nights_tower_melee_upgrade")
        v:AddAbility("nights_tower_melee_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function NightsRange(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_nights_range"].abilities["nights_creeps_range_spec"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_nights_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_nights_range"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_nights_range"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_nights_range"].abilities["attack_speed_pass"] or 0) + 12
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("nights_tower_range_upgrade")
        v:AddAbility("nights_tower_range_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function NightsRangeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_nights_range"].abilities["nights_creeps_range_spec"] = _G.playersinfo[id].unitsinfo["npc_dota_nights_range"].abilities["nights_creeps_range_spec"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function NightsMage(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].health + 80
    _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].mana = _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].mana + 50
    _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].bonus_mana_regen = (_G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].bonus_mana_regen or 0) + 1
    _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].abilities["nights_creeps_mage_spec"] = 1
    RemoveSpecAbilities(event)
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("nights_tower_mage_upgrade")
        v:AddAbility("nights_tower_mage_upgrade_spec"):SetLevel(1)
    end
end

function NightsMageUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].abilities["nights_creeps_mage_spec"] = _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].abilities["nights_creeps_mage_spec"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].bonus_mana_regen = (_G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].bonus_mana_regen or 0) + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level == 1 then
        _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].abilities["nights_creeps_mage_attack"] = _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].abilities["nights_creeps_mage_attack"] + 1 
    elseif level == 2 then
        _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].abilities["nights_creeps_mage_attack"] = _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].abilities["nights_creeps_mage_attack"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].abilities["nights_creeps_mage_ice_cover"] = _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].abilities["nights_creeps_mage_ice_cover"] + 1
    elseif level == 3 then
        _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].abilities["nights_creeps_mage_attack"] = _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].abilities["nights_creeps_mage_attack"] + 1 
        _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].abilities["nights_creeps_mage_ice_cover"] = _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].abilities["nights_creeps_mage_ice_cover"] + 1
        _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].abilities["nights_creeps_mage_mark"] = _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].abilities["nights_creeps_mage_mark"] + 1
    end
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function NightsArme(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_nights_arme"].abilities["nights_creeps_arme_charge"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_nights_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_nights_arme"].health + 100
    _G.playersinfo[id].unitsinfo["npc_dota_nights_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_nights_arme"].armor + 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("nights_tower_arme_upgrade")
        v:AddAbility("nights_tower_arme_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function NightsArmeUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_nights_arme"].abilities["nights_creeps_arme_charge"] = _G.playersinfo[id].unitsinfo["npc_dota_nights_arme"].abilities["nights_creeps_arme_charge"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function NightsT1T2T3(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_nights_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_nights_melee"].health + 80
    _G.playersinfo[id].unitsinfo["npc_dota_nights_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_nights_range"].health + 80
    _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].health + 80
    _G.playersinfo[id].unitsinfo["npc_dota_nights_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_nights_arme"].health + 80
    _G.playersinfo[id].unitsinfo["npc_dota_nights_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_nights_air"].health + 80
    _G.playersinfo[id].unitsinfo["npc_dota_nights_melee"].mana = _G.playersinfo[id].unitsinfo["npc_dota_nights_melee"].mana + 50
    _G.playersinfo[id].unitsinfo["npc_dota_nights_range"].mana = _G.playersinfo[id].unitsinfo["npc_dota_nights_range"].mana + 50
    _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].mana = _G.playersinfo[id].unitsinfo["npc_dota_nights_mage"].mana + 50
    _G.playersinfo[id].unitsinfo["npc_dota_nights_arme"].mana = _G.playersinfo[id].unitsinfo["npc_dota_nights_arme"].mana + 50
    _G.playersinfo[id].unitsinfo["npc_dota_nights_air"].mana = _G.playersinfo[id].unitsinfo["npc_dota_nights_air"].mana + 50
    _G.playersinfo[id].unitsinfo["npc_dota_nights_melee"].abilities["nights_creeps_t1t2_heal"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_nights_arme"].abilities["nights_creeps_t1t2_heal"] = 1
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("nights_tower_buildings_upgrade")
        v:AddAbility("nights_tower_buildings_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function NightsT1T2T3Upgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_nights_melee"].abilities["nights_creeps_t1t2_heal"] = _G.playersinfo[id].unitsinfo["npc_dota_nights_melee"].abilities["nights_creeps_t1t2_heal"] + 1
    _G.playersinfo[id].unitsinfo["npc_dota_nights_arme"].abilities["nights_creeps_t1t2_heal"] = _G.playersinfo[id].unitsinfo["npc_dota_nights_arme"].abilities["nights_creeps_t1t2_heal"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end

function NightsSiege(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_nights_siege"].abilities["nights_creeps_siege_armorred"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_nights_siege"].health = _G.playersinfo[id].unitsinfo["npc_dota_nights_siege"].health + 650
    _G.playersinfo[id].unitsinfo["npc_dota_nights_siege"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_nights_siege"].abilities["attack_speed_pass"] or 0) + 40
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("nights_tower_siege_upgrade")
        v:AddAbility("nights_tower_siege_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function NightsAir(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_nights_air"].abilities["nights_creeps_air_spec"] = 1
    _G.playersinfo[id].unitsinfo["npc_dota_nights_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_nights_air"].health + 150
    -- _G.playersinfo[id].unitsinfo["npc_dota_nights_air"].abilities["attack_speed_pass"] = (_G.playersinfo[id].unitsinfo["npc_dota_nights_air"].abilities["attack_speed_pass"] or 0) + 15
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveAbility("nights_tower_air_aura_upgrade")
        v:AddAbility("nights_tower_air_aura_upgrade_spec"):SetLevel(1)
        v:RemoveAbility("nights_tower_air_upgrade")
        v:AddAbility("nights_tower_air_upgrade_spec"):SetLevel(1)
    end
    RemoveSpecAbilities(event)
end

function NightsAirUpgrade(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playerstats[id].spec_upgrades = _G.playerstats[id].spec_upgrades + 1
    _G.playersinfo[id].unitsinfo["npc_dota_nights_air"].abilities["nights_creeps_air_spec"] = _G.playersinfo[id].unitsinfo["npc_dota_nights_air"].abilities["nights_creeps_air_spec"] + 1
    local ability = event.ability
    local level = ability:GetLevel()
    if level >= 3 then
        caster:RemoveAbility(ability:GetAbilityName())
    else
        ability:SetLevel(level+1)
    end
end


--forall

function SpellShield(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    
    if _G.playersinfo[id].ancient then
        local shieldParticle = ParticleManager:CreateParticle("particles/new/spell_shield2.vpcf", PATTACH_ABSORIGIN_FOLLOW, _G.playersinfo[id].ancient)
        ParticleManager:SetParticleControl(shieldParticle, 1, Vector(750,0,0))
        _G.playersinfo[id].ancient.custom_damage_reduction[6] = 0.2
    end
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v.custom_damage_reduction[6] = 0.2
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v.custom_damage_reduction[6] = 0.2
    end
    RemoveSpecAbilities(event)
end

function ForAllSpecDamageEnemies(event)
    local caster = event.caster
    local ability = event.ability
    local part = "particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_echoslam_start_egset.vpcf"
    local casterid = caster:GetPlayerOwnerID()
	local damage = ability:GetLevelSpecialValueFor("damage", (ability:GetLevel() - 1))

    -- [SCD-FIX] «Мини взрыв» не наносил урон. Единственное отличие этой функции от
    -- рабочих ультимейтов (ultimate_abilities.lua:268-294) - гейт по уровню замка,
    -- поэтому причина в нём или в падении до него. Три правки:
    --  1) tonumber(event.Level): KV-подстановка "%need_level" теоретически может
    --     прийти строкой, тогда "число >= строка" бросает ошибку Lua и функция
    --     умирает ДО урона и ДО возврата золота. Приведение делает гейт безопасным
    --     при любом типе. Косвенное доказательство, что обычно приходит число:
    --     hero_creater.lua сравнивает caster:GetLevel() >= event.barrack_level с
    --     литералом "2" из KV, и спавн героев в игре работает.
    --  2) guard'ы на nil: _G.playersinfo[casterid], .baracks и .towers у чужих
    --     игроков индексировались без проверок (в отличие от .ancient). Падение в
    --     середине цикла означало бы, что урон не наносится НИКОМУ.
    --  3) возврат золота через _G.SCD_RefundAbilityGold, чтобы ещё и вычитать
    --     goldspend (иначе «Счёт» в топ-баре рос при несостоявшейся покупке).
    local level = tonumber(event.Level)
    local casterinfo = (casterid ~= nil and _G.playersinfo) and _G.playersinfo[casterid] or nil
    local caster_ancient = casterinfo and casterinfo.ancient or nil
    local castle_level = caster_ancient and caster_ancient:GetLevel() or nil

    -- Диагностика: одна строка на каст. По ней в живом прогоне видно ВСЕ входы гейта
    -- и его результат, то есть причину можно установить за один каст.
    print("[SCD-DIAG] mini_boom: casterid=" .. tostring(casterid)
            .. " info=" .. tostring(casterinfo ~= nil)
            .. " ancient=" .. tostring(caster_ancient ~= nil)
            .. " castle_level=" .. tostring(castle_level)
            .. " need_level=" .. tostring(event.Level) .. "(" .. type(event.Level) .. ")"
            .. " damage=" .. tostring(damage))

    -- [SCD-FIX] Гейт по уровню замка УБРАН ПОЛНОСТЬЮ решением владельца
    -- («Для "Мини взрыва" не нужен третий уровень замка»).
    --
    -- Почему убран весь гейт, а не только снижен порог до 1: прежняя проверка
    -- `castle_level >= level` зависела от того, какой уровень возвращает GetLevel()
    -- для здания. Если у npc_dota_custom_ancient уровень 0 (а не 1), то даже порог
    -- need_level=1 не проходит, и способность молча возвращает золото, не нанося
    -- урона. Снижение порога оставляло эту зависимость; убирание сравнения - нет.
    -- Уровень замка по-прежнему печатается диагностикой выше, чтобы фактическое
    -- значение было видно в логе, а не угадывалось.
    --
    -- Единственное оставшееся условие - наличие записи игрока: без casterid некого
    -- бить и некому возвращать золото.
    if casterinfo then
        local enemies = 0
        local targets = 0
        for id, _ in pairs(_G.playersinfo) do
            if PlayerResource:IsValidPlayerID(id)
                    and PlayerResource:GetTeam(id) ~= PlayerResource:GetTeam(casterid) then
                local info = _G.playersinfo[id]
                if info then
                    enemies = enemies + 1
                    if info.ancient then
                        local partindx = ParticleManager:CreateParticle( part, PATTACH_ABSORIGIN, caster )
                        ParticleManager:SetParticleControl(partindx, 0, info.ancient:GetAbsOrigin())
                        ParticleManager:SetParticleControl(partindx, 1, Vector(1000,0,0))
                        ApplyCustomDamage(info.ancient, caster, damage, 6, ability)
                        targets = targets + 1
                    end
                    if info.baracks then
                        for k, v in pairs(info.baracks) do
                            -- partindx = ParticleManager:CreateParticle( part, PATTACH_ABSORIGIN, caster )
                            -- ParticleManager:SetParticleControl(partindx, 0, v:GetAbsOrigin())
                            ApplyCustomDamage(v, caster, damage, 6, ability)
                            targets = targets + 1
                        end
                    end
                    if info.towers then
                        for k, v in pairs(info.towers) do
                            -- partindx = ParticleManager:CreateParticle( part, PATTACH_ABSORIGIN, caster )
                            -- ParticleManager:SetParticleControl(partindx, 0, v:GetAbsOrigin())
                            ApplyCustomDamage(v, caster, damage, 6, ability)
                            targets = targets + 1
                        end
                    end
                end
            end
        end
        print("[SCD-DIAG] mini_boom: damage applied, enemies=" .. tostring(enemies)
                .. " targets=" .. tostring(targets) .. " damage=" .. tostring(damage)
                .. " castle_level=" .. tostring(castle_level))
    else
        -- [SCD-FIX] возврат за несостоявшийся каст: вернуть золото И вычесть goldspend.
        -- Ветка достижима только если у кастера нет записи в _G.playersinfo.
        local refund = ability:GetGoldCost(ability:GetLevel()-1)
        _G.SCD_RefundAbilityGold(ability, casterid, refund)
        print("[SCD-DIAG] mini_boom: NO playersinfo for casterid=" .. tostring(casterid)
                .. ", refunded " .. tostring(refund))
    end
end

--other

function CheckCastle(event)
    local caster = event.caster
    local level = event.Level
    local id = caster:GetPlayerOwnerID()
    
    if _G.playersinfo[id].ancient and _G.playersinfo[id].ancient:GetLevel() >= level then
    else
        caster:Stop()
        -- [SCD-DIAG] только в фейл-ветке, чтобы не спамить: показывает, что второй
        -- RunScript вообще выполнился (важно для «Мини взрыва», где ForAllSpec…
        -- идёт ПЕРЕД CheckCastle), и печатает тип level - это независимая проверка,
        -- что KV-подстановка "%need_level" приходит числом, а не строкой.
        print("[SCD-DIAG] CheckCastle fail: ability=" .. tostring(event.ability and event.ability:GetAbilityName())
                .. " player=" .. tostring(id)
                .. " ancient=" .. tostring(_G.playersinfo[id] and _G.playersinfo[id].ancient ~= nil)
                .. " castle_level=" .. tostring(_G.playersinfo[id] and _G.playersinfo[id].ancient
                        and _G.playersinfo[id].ancient:GetLevel())
                .. " need_level=" .. tostring(level) .. "(" .. type(level) .. ")")
        if level == 2 then
            CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#need_ancient_level_2" })
        elseif level == 3 then
            CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#need_ancient_level_3" })
        end
    end
end

function CheckMage(event)
    local caster = event.caster
    local level = event.Level
    local id = caster:GetPlayerOwnerID()
    
    if _G.playersinfo[id].ancient and _G.playersinfo[id].item_mage_upgrade >= level then
    else
        caster:Stop()
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#need_mage_grade"..level })
    end
end

function AddBonusAbility(event)
    local caster = event.caster
    caster:AddAbility(event.ability_name):SetLevel(1)
end

function RemoveBonusAbility(event)
    local caster = event.caster
    caster:RemoveAbility(event.ability_name)
end

function RemoveSpecAbilities(event)
    local caster = event.caster
    local ability = event.ability
    local name = ability:GetAbilityName()

    if caster:GetUnitName() ~= "npc_dota_custom_spec" then
        error("RemoveSpecAbilities: UnitName ~= npc_dota_custom_spec")
    end

    for i=0, caster:GetAbilityCount()-1 do
        local abil = caster:GetAbilityByIndex(i)
        if abil and abil:GetAbilityName() ~= "unit_building_core" then
            caster:RemoveAbilityByHandle(abil)
        end
    end

    -- local gameEvent = {}
	-- gameEvent["player_id"] = caster:GetPlayerOwnerID()
	-- gameEvent["teamnumber"] = -1
	-- gameEvent["locstring_value"] = "#DOTA_Tooltip_Ability_" .. name
	-- gameEvent["message"] = "#Combat_Message_Test"
	-- FireGameEvent( "dota_combat_event_message", gameEvent )

    caster.specpass = caster:AddAbility(name.."_pass")
    caster.specpass:SetLevel(1)

    caster:AddAbility("forall_spec_damage_enemies"):SetLevel(1)

    CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(caster:GetPlayerOwnerID()), "building_selection_clear", {} )
end