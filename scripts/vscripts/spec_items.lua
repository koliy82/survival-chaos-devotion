
local spec_items = {}

function spec_items:SellItem(data)
    local id = data.PlayerID
    if not id then return end
    local slot_index = tonumber(data.slot)
    if not slot_index or not (slot_index == 0 or slot_index == 1 or slot_index == 2 or slot_index == 3 or slot_index == 4 or slot_index == 5) then return end
    local hero_name = data.hero_name
    if hero_name and not (_G.playersinfo[id].spec.items_spec and _G.playersinfo[id].spec.items_spec[hero_name]) then return end
    
    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
    local units = FindUnitsInRadius(_G.playersinfo[id].spec:GetTeam(), _G.playersinfo[id].spec:GetAbsOrigin(), nil, 999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
    local hero = nil
    for _, unit in pairs(units) do
        if unit:GetUnitName() == hero_name and unit:FindAbilityByName("hero_core") ~= nil and not unit:IsIllusion() then
            hero = unit
        end
    end
    local inventory = nil
    if hero ~= nil then
        local item = hero:GetItemInSlot(slot_index)
        if item ~= nil then
            local add_gold = GetItemCost(item:GetAbilityName()) / 2
            hero:RemoveItem(item)
            PlayerResource:ModifyGold(id, add_gold, false, DOTA_ModifyGold_SellItem)

            inventory = {}
            for i=0,5 do
                local item = hero:GetItemInSlot(i)
                if item ~= nil then
                    inventory[tostring(i)] = item:GetAbilityName()
                end
            end
        end
    else
        slot_index = slot_index + 1
        if _G.playersinfo[id].unitsinfo[hero_name].inventory ~= nil then
            if _G.playersinfo[id].unitsinfo[hero_name].inventory[slot_index] ~= nil then
                local add_gold = GetItemCost(_G.playersinfo[id].unitsinfo[hero_name].inventory[slot_index]) / 2
                _G.playersinfo[id].unitsinfo[hero_name].inventory[slot_index] = nil
                PlayerResource:ModifyGold(id, add_gold, false, DOTA_ModifyGold_SellItem)
                
                inventory = {}
                for i=0,5 do
                    inventory[tostring(i)] = _G.playersinfo[id].unitsinfo[hero_name].inventory[i+1]
                end
                inventory["neutral"] = _G.playersinfo[id].unitsinfo[hero_name].inventory["neutral"]
            end
        end
    end
    
    if inventory ~= nil then
        local invs = CustomNetTables:GetTableValue("Hero_Items",tostring(id))
        if invs == nil then
            invs = {}
        end
        invs[hero_name] = inventory
        CustomNetTables:SetTableValue("Hero_Items", tostring(id), invs)
    end
end

function spec_items:BuyNeutral(data)
    local id = data.PlayerID
    if not id then return end
    local hero_name = data.hero_name
    if hero_name and not (_G.playersinfo[id].spec.items_spec and _G.playersinfo[id].spec.items_spec[hero_name]) then return end
    if PlayerResource:GetGold(id) < 100 then return end
    
	local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE
    local units = FindUnitsInRadius(_G.playersinfo[id].spec:GetTeam(), _G.playersinfo[id].spec:GetAbsOrigin(), nil, 999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
    local hero = nil
    for _, unit in pairs(units) do
        if unit:GetUnitName() == hero_name and unit:FindAbilityByName("hero_core") ~= nil and not unit:IsIllusion() then
            hero = unit
        end
    end

    local neutrals = {
        "item_spec_faerie_fire",
        -- "item_spec_enchanted_mango",
        "item_spec_fusion_rune",
        "item_spec_blast_rig",
        "item_spec_witch_blade",
        "item_spec_orchid"
    }

    if hero == nil then
        if _G.playersinfo[id].unitsinfo[hero_name].inventory ~= nil then
            if _G.playersinfo[id].unitsinfo[hero_name].inventory["neutral"] == nil then
                _G.playersinfo[id].unitsinfo[hero_name].inventory["neutral"] = neutrals[RandomInt(1, #neutrals)]
                PlayerResource:ModifyGold(id, -100, false, DOTA_ModifyGold_PurchaseConsumable)
            end
        else
            _G.playersinfo[id].unitsinfo[hero_name].inventory = {}
            _G.playersinfo[id].unitsinfo[hero_name].inventory["neutral"] = neutrals[RandomInt(1, #neutrals)]
            PlayerResource:ModifyGold(id, -100, false, DOTA_ModifyGold_PurchaseConsumable)
        end
        local inventory = {}
        for i=0,5 do
            inventory[tostring(i)] = _G.playersinfo[id].unitsinfo[hero_name].inventory[i+1]
        end
        inventory["neutral"] = _G.playersinfo[id].unitsinfo[hero_name].inventory["neutral"]
        local invs = CustomNetTables:GetTableValue("Hero_Items",tostring(id))
        if invs == nil then
            invs = {}
        end
        invs[hero_name] = inventory
        CustomNetTables:SetTableValue("Hero_Items", tostring(id), invs)
    else
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "display_custom_error", { message = "#cant_buy_when_hero_alive" })
    end
end

function spec_items:Init()
	CustomGameEventManager:RegisterListener("SellItem", Dynamic_Wrap(spec_items, 'SellItem'))
	CustomGameEventManager:RegisterListener("BuyNeutral", Dynamic_Wrap(spec_items, 'BuyNeutral'))
end

spec_items:Init()
return spec_items