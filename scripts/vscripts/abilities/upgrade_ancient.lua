function OnSpellStart(event)
    --DeepPrintTable(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()
    local id = caster:GetPlayerOwnerID()
    -- local heroduration = ability:GetLevelSpecialValueFor("hero_duration", level-1)
    -- local creepduration = ability:GetLevelSpecialValueFor("creep_duration", level-1)
    
    _G.playersinfo[id].gpt = _G.playersinfo[id].gpt + 10

    -- ability:SetLevel(level+1)
    if level == 1 then
        if caster.abil2 then
            caster.abil2:SetActivated(true)
        end
        local player = caster:GetPlayerOwner()
        if player then
            CustomGameEventManager:Send_ServerToPlayer(player, "OpenSelectAbil", {mode = "aura", auras = _G.playersinfo[player:GetPlayerID()].raceinfo["auras"]})
        end
    end
    if level == 2 and caster.ult_abil then
        caster.ult_abil:SetActivated(true)
    end
    
    --for k, v in pairs(_G.playersinfo[id].towers) do
    --    local health_prc = v:GetHealthPercent()
    --    v:SetBaseMaxHealth(v:GetBaseMaxHealth() + 1500)
    --    v:CalculateGenericBonuses()
    --    local newhealth = v:GetMaxHealth() * (health_prc/100)
    --    if newhealth <= 0 then
    --        newhealth = 1
    --    end
    --    v:SetHealth(newhealth)
    --    v:SetPhysicalArmorBaseValue(v:GetPhysicalArmorBaseValue() + 6)
    --end

    -- caster:SetHPGain(5000)
    -- caster:SetArmorGain(4)
    -- caster:SetManaGain(200)
    if caster.mana then
        caster.mana = caster.mana + 200
    end
    local health_prc = caster:GetHealthPercent()
    if health_prc <= 0 then
        health_prc = 1
    end
    local current_hp = caster:GetHealth()
    local oldmanap = caster:GetManaPercent()
    -- print(caster:GetBonusManaRegen())
    -- print(caster:GetManaRegen())
    caster:CreatureLevelUp(1)
    -- print(caster:GetBonusManaRegen())
    -- print(caster:GetManaRegen())
    caster:SetBaseManaRegen(0.2)
    caster:SetHealth(current_hp + 5000)
    caster:SetMana(caster:GetMaxMana() * oldmanap / 100)
    if ability:GetMaxLevel() <= ability:GetLevel() then
        caster:RemoveAbility(ability:GetAbilityName())
        caster:AddAbility("ancient_buy_mana"):SetLevel(1)
    end
    FireGameEvent("building_upgrade", {building = caster:entindex()})
end