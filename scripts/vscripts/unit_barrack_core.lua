LinkLuaModifier( "unit_barrack_core_mod", "unit_barrack_core.lua", LUA_MODIFIER_MOTION_NONE )
unit_barrack_core = class({})

function unit_barrack_core:GetIntrinsicModifierName()
	return "unit_barrack_core_mod"
end

unit_barrack_core_mod = class({})

function unit_barrack_core_mod:StartGame()
    local caster = self:GetCaster()
    caster.creepspawnpoint = caster:GetAbsOrigin() + caster:GetForwardVector()*100
    caster.herospawnpoint = caster:GetAbsOrigin() - caster:GetForwardVector()*100
    if GetMapName() == "polygon" then return end
    caster.localtimer = caster.barrack_timer
    local mod = caster:FindModifierByName("unit_barrack_core_mod")
    mod:SetStackCount(caster.localtimer)
    self.endTime = GameRules:GetGameTime() + 1
    caster:SetThink("Think", self, "unit_barrack_core_mod", 0.1)
    --Timers:CreateTimer(function()
    --    local caster = self:GetCaster()
    --    if caster:IsAlive() and _G.playersinfo[caster:GetPlayerOwnerID()].alive then
    --        caster.localtimer = caster.localtimer - 1
    --        SendOverheadEventMessage(caster:GetPlayerOwner(), OVERHEAD_ALERT_MAGICAL_BLOCK, caster, caster.localtimer, caster:GetPlayerOwner())
    --        if caster.localtimer <= 0 then
    --            local status, err = pcall(self.SpawnUnits, self)--self:SpawnUnits()
    --            if not status then
    --                pcall(_G.HandleEventError, _G, unit_barrack_core_mod, "barrack_core", err)
    --            end
    --            caster.localtimer = caster.barrack_timer
    --        end
    --    end
    --    return 1.0
    --end)
    
    self:SpawnUnits()
    -- SendOverheadEventMessage(nil, OVERHEAD_ALERT_MAGICAL_BLOCK, caster, caster.localtimer, nil)
end

function unit_barrack_core_mod:Think()
    local now = GameRules:GetGameTime()
    if now >= self.endTime then
        local status, nextCall = pcall(self.BigThink, self)
        --self.endTime = self.endTime + 1
        if status then
            if nextCall then
                self.endTime = self.endTime + nextCall
                return 0.1
            end
            return 0.1
        else
            pcall(_G.HandleEventError, _G, self, "barrack_core_timer", nextCall)
        end
    else
        return 0.1
    end
    return 0.1
end

function unit_barrack_core_mod:BigThink()
    local caster = self:GetCaster()
    if caster:IsAlive() and _G.playersinfo[caster:GetPlayerOwnerID()].alive then
        caster.localtimer = caster.localtimer - 1
        local player = caster:GetPlayerOwner()
        -- if player then
        --     SendOverheadEventMessage(nill, OVERHEAD_ALERT_XP, caster, caster.localtimer, player)
        -- end


        local mod = caster:FindModifierByName("unit_barrack_core_mod")
        mod:SetStackCount(caster.localtimer)
        if caster.localtimer <= 0 then
            local status, err = pcall(self.SpawnUnits, self)--self:SpawnUnits()
            if not status then
                pcall(_G.HandleEventError, _G, unit_barrack_core_mod, "barrack_core", err)
            end
            caster.localtimer = caster.barrack_timer
        else
            function CustomFloatingText(unit, text, color)
                local particle = ParticleManager:CreateParticle(
                    "particles/msg_fx/msg_number.vpcf",
                    PATTACH_WORLDORIGIN,
                    unit
                )
                    -- Get position 200 units above the unit
                local pos = unit:GetAbsOrigin() + Vector(0, 0, 250)
                ParticleManager:SetParticleControl(particle, 0, pos)
                ParticleManager:SetParticleControl(particle, 1, Vector(0, tonumber(text), 0))
                ParticleManager:SetParticleControl(particle, 2, Vector(1, #tostring(text), 0))
                ParticleManager:SetParticleControl(particle, 3, color or Vector(255, 255, 255))
            end
            -- Usage:
            CustomFloatingText(caster, caster.localtimer, Vector(150, 150, 150))
        end
        --return 1
    end
    return 1
end

function unit_barrack_core_mod:SpawnUnits()
    local caster = self:GetCaster()
    local team = caster:GetTeam()
    local owner = caster:GetOwner()
    local function delayedSpawn(unitsToSpawn)
        for k, v in pairs(unitsToSpawn) do
            while v > 0 do
                v = v - 1
                local unit = CreateUnitByName(k, caster.creepspawnpoint, true, owner, owner, team)
                if unit:IsRangedAttacker() then
                    FindClearSpaceForUnit(unit, caster.herospawnpoint, false)
                end
                --if caster.mid_barrack and not _G.duos then
                --    unit:SetMinimumGoldBounty(unit:GetMinimumGoldBounty() * caster.mid_barrack_gold_bounty_mult)
                --    unit:SetMaximumGoldBounty(unit:GetMaximumGoldBounty() * caster.mid_barrack_gold_bounty_mult)
                --    unit:SetDeathXP(unit:GetDeathXP() * caster.mid_barrack_exp_bounty_mult)
                --end
                if caster:HasModifier("unit_destroyed_barrack_mod") and GameRules:GetDOTATime(false,false) <= 1200 then
                    unit:SetDeathXP(unit:GetDeathXP() * 0.2)
                    unit:SetMinimumGoldBounty(unit:GetMinimumGoldBounty() * 0.2)
                    unit:SetMaximumGoldBounty(unit:GetMaximumGoldBounty() * 0.2)
                end
                --FireGameEventLocal?
                FireGameEvent("custom_spawn_unit", {spawner_unit = caster:entindex(), spawner_ability = self:GetAbility():entindex(), unit = unit:entindex()})
            end
            --if v > 1 then
            --    unitsToSpawn[k] = v - 1
            --else
            --    unitsToSpawn[k] = nil
            --end
            --local unit = CreateUnitByName(k, caster.creepspawnpoint, true, owner, owner, team)
            --if unit:IsRangedAttacker() then
            --    FindClearSpaceForUnit(unit, caster.herospawnpoint, false)
            --end
            ----if caster.mid_barrack and not _G.duos then
            ----    unit:SetMinimumGoldBounty(unit:GetMinimumGoldBounty() * caster.mid_barrack_gold_bounty_mult)
            ----    unit:SetMaximumGoldBounty(unit:GetMaximumGoldBounty() * caster.mid_barrack_gold_bounty_mult)
            ----    unit:SetDeathXP(unit:GetDeathXP() * caster.mid_barrack_exp_bounty_mult)
            ----end
            --if caster:HasModifier("unit_destroyed_barrack_mod") and GameRules:GetDOTATime(false,false) <= 1200 then
            --    unit:SetDeathXP(unit:GetDeathXP() * 0.3)
            --end
            --FireGameEvent("custom_spawn_unit", {spawner_unit = caster:entindex(), spawner_ability = self:GetAbility():entindex(), unit = unit:entindex()})
            --if next then
            --    Timers:CreateTimer(0.1, function()
            --        delayedSpawn(unitsToSpawn)
            --    end)
            --end
            --return
        end
    end
    local unitsts = {}
    for k, v in pairs(caster.units) do
        unitsts[k] = v
    end
    delayedSpawn(unitsts)
    if caster.double_spawn then
        Timers:CreateTimer(1, function()
            self:SpawnUnits()
        end)
        caster.double_spawn = nil
    end
end

function unit_barrack_core_mod:OnCreated( kv )
    if IsServer() then
        self:GetCaster().barrack_timer = 45
        table.insert(_G.onstartgame, self)
    end
end

function unit_barrack_core_mod:IsHidden()
    --return true
    return false
end