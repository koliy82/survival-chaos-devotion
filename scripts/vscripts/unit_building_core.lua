LinkLuaModifier( "unit_building_core_mod", "unit_building_core.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "unit_destroyed_barrack_mod", "unit_building_core.lua", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_neutrals_buids_2_buff", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_3", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_4", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_5", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_6", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_7", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_8", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_9", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_10", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_11", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_12", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_13", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_14", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_15", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_neutrals_buids_16", "modifiers/modifiers_neutrals_buids", LUA_MODIFIER_MOTION_NONE )
unit_building_core = class({})

function unit_building_core:OnOwnerDied()
    if IsServer() then
        local caster = self:GetCaster()
        local unit_name = caster:GetUnitName()
        if unit_name == "npc_dota_custom_ancient" then
            local castle_gold = {1000, 1500, 2000}
            local level = caster:GetLevel()
            PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), castle_gold[level], false, DOTA_ModifyGold_Building)
            local enemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, 1100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
            for _,hEnemy in pairs( enemies ) do
                if hEnemy ~= nil and hEnemy:IsAlive() and hEnemy:IsInvulnerable() == false then
                    local pfx = ParticleManager:CreateParticle("particles/dire_fx/bad_ancient002_destruction_flashyshit.vpcf", PATTACH_ABSORIGIN, caster)
                    ParticleManager:ReleaseParticleIndex(pfx)
                    ApplyCustomDamage(hEnemy, caster, 10000, 5, self)
                end
            end
        elseif unit_name == "npc_dota_custom_tower" then
            PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), 350, false, DOTA_ModifyGold_Building)
        end
    end
end

function unit_building_core:GetIntrinsicModifierName()
	return "unit_building_core_mod"
end

unit_building_core_mod = class({})

function unit_building_core_mod:OnCreated( kv )
    if IsServer() then
        local caster = self:GetCaster()
        local unit_name = caster:GetUnitName()
        if unit_name == "npc_dota_custom_ancient" then
            caster:SetHullRadius(200)
            caster.mana = 400
            Timers:CreateTimer(0.1, function()
                caster:SetMana(caster:GetMaxMana())
            end)
        elseif unit_name == "npc_dota_custom_barrack" then
            caster:SetHullRadius(160)
        elseif unit_name == "npc_dota_custom_tower" then
            caster:SetHullRadius(80)
        elseif unit_name == "npc_dota_custom_spec" then
            self.inv = true
        elseif unit_name == "npc_dota_custom_neutral" then
            self.inv = true
            self.pv = true
            Timers:CreateTimer(1, function()
                local bonus_type = caster.building_id % 2
                local bonus_id = RandomInt(1, #_G.bonus_ids[bonus_type])
                caster.neutral_bonus_id = _G.bonus_ids[bonus_type][bonus_id]
                table.remove(_G.bonus_ids[bonus_type], bonus_id)

                caster:SetModel("models/neutral_building_"..caster.neutral_bonus_id..".vmdl")
                caster:SetOriginalModel("models/neutral_building_"..caster.neutral_bonus_id..".vmdl")
                caster.neutral_ability = caster:AddAbility("neutral_bonus_pass"..caster.neutral_bonus_id)
                caster.neutral_ability:SetLevel(1)

                function caster:SetNewCustomOwner(new_owner)
                    if caster:HasModifier("modifier_neutral_locked") then return end
                    local team = new_owner:GetTeam()
                    local oldteam = caster:GetTeam()
                    if oldteam == team then return end
                    local gpt_all = caster.neutral_ability:GetLevelSpecialValueFor("gpt_all", caster.neutral_ability:GetLevel()-1)
                    if oldteam == DOTA_TEAM_NEUTRALS then
                        PlayerResource:ModifyGold(_G:GetPlayerIDByTeam( team ), 50, false, DOTA_ModifyGold_Building)
                    else
                        for k, v in pairs(_G.playersinfo) do
                            if PlayerResource:GetTeam(k) == oldteam then
                                _G.playersinfo[k].gpt = _G.playersinfo[k].gpt - gpt_all
                            end
                        end
                    end
                    for k, v in pairs(_G.playersinfo) do
                        if PlayerResource:GetTeam(k) == team then
                            _G.playersinfo[k].gpt = _G.playersinfo[k].gpt + gpt_all
                        end
                    end
    
                    if caster.neutral_bonus_id == 1 then
                        local gpt = caster.neutral_ability:GetLevelSpecialValueFor("gpt", caster.neutral_ability:GetLevel()-1)
                        if oldteam ~= DOTA_TEAM_NEUTRALS then
                            for k, v in pairs(_G.playersinfo) do
                                if PlayerResource:GetTeam(k) == oldteam then
                                    _G.playersinfo[k].gpt = _G.playersinfo[k].gpt - gpt
                                end
                            end
                        end
                        for k, v in pairs(_G.playersinfo) do
                            if PlayerResource:GetTeam(k) == team then
                                _G.playersinfo[k].gpt = _G.playersinfo[k].gpt + gpt
                            end
                        end
                        caster:SetTeam(team)
                    elseif caster.neutral_bonus_id == 2 then
                        if oldteam ~= DOTA_TEAM_NEUTRALS then
                            for k, v in pairs(_G.playersinfo) do
                                if PlayerResource:GetTeam(k) == oldteam and _G.playersinfo[k].ancient then
                                    _G.playersinfo[k].ancient:RemoveModifierByName("modifier_neutrals_buids_2_buff")
                                end
                            end
                        end
                        caster:SetTeam(team)
                        for k, v in pairs(_G.playersinfo) do
                            if PlayerResource:GetTeam(k) == team and _G.playersinfo[k].ancient then
                                caster.neutral_mod = _G.playersinfo[k].ancient:AddNewModifier(caster, caster.neutral_ability, "modifier_neutrals_buids_2_buff", {})
                            end
                        end
                    else
                        caster:RemoveModifierByName("modifier_neutrals_buids_" .. caster.neutral_bonus_id)
                        caster:SetTeam(team)
                        caster.neutral_mod = caster:AddNewModifier(caster, caster.neutral_ability, "modifier_neutrals_buids_" .. caster.neutral_bonus_id, {})
                    end
                    
                    --Challenges:TriggerEvent(new_owner:GetPlayerOwnerID(), "capture_neutral", {neutral = caster})
                    FireGameEvent("capture_neutral", {neutral = caster:entindex(), old_team = oldteam, new_team = team})
                end

                function caster:UpgradeNeutral()
                    local team = caster:GetTeam()
                    caster.neutral_ability:UpgradeAbility(false)
                    if team == DOTA_TEAM_NEUTRALS then return end

                    local gpt_all_dif = caster.neutral_ability:GetLevelSpecialValueFor("gpt_all", caster.neutral_ability:GetLevel()-1) - caster.neutral_ability:GetLevelSpecialValueFor("gpt_all", caster.neutral_ability:GetLevel()-2)
                    
                    if caster.neutral_bonus_id == 1 then
                        local gpt_dif = caster.neutral_ability:GetLevelSpecialValueFor("gpt", caster.neutral_ability:GetLevel()-1) - caster.neutral_ability:GetLevelSpecialValueFor("gpt", caster.neutral_ability:GetLevel()-2)
                        for k, v in pairs(_G.playersinfo) do
                            if PlayerResource:GetTeam(k) == team then
                                _G.playersinfo[k].gpt = _G.playersinfo[k].gpt + gpt_all_dif + gpt_dif
                            end
                        end
                    else
                        for k, v in pairs(_G.playersinfo) do
                            if PlayerResource:GetTeam(k) == team then
                                _G.playersinfo[k].gpt = _G.playersinfo[k].gpt + gpt_all_dif
                            end
                        end
                        if caster.neutral_mod and not caster.neutral_mod:IsNull() and caster.neutral_mod.ForceRefresh then
                            caster.neutral_mod:ForceRefresh()
                        end
                    end
                end
            end)
        end
    end
end

function unit_building_core_mod:IsHidden()
    return true
end

function unit_building_core_mod:CheckState()
    local state = {}
    state[MODIFIER_STATE_ROOTED] = true
	state[MODIFIER_STATE_INVULNERABLE] = self.inv
	state[MODIFIER_STATE_PROVIDES_VISION] = self.pv
	return state
end

function unit_building_core_mod:DeclareFunctions()
    local caster = self:GetCaster()
    local unit_name = caster:GetUnitName()
    local func = {
        MODIFIER_PROPERTY_DISABLE_TURNING,
        MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_MANA_BONUS,
        MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
        -- MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
    }
    if unit_name == "npc_dota_custom_ancient" then
        func = {
            MODIFIER_PROPERTY_DISABLE_TURNING,
            MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
            MODIFIER_PROPERTY_MANA_BONUS,
            MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
            -- MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
        }
    elseif unit_name == "npc_dota_custom_barrack" then
        func = {
            MODIFIER_PROPERTY_DISABLE_TURNING,
            MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
            MODIFIER_EVENT_ON_TAKEDAMAGE,
            MODIFIER_PROPERTY_MANA_BONUS,
            MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
            -- MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
        }
    elseif unit_name == "npc_dota_custom_tower" then
        func = {
            MODIFIER_PROPERTY_DISABLE_TURNING,
            MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
            MODIFIER_PROPERTY_MANA_BONUS,
            MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
            -- MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
        }
    elseif unit_name == "npc_dota_custom_spec" then
        func = {
            MODIFIER_PROPERTY_DISABLE_TURNING,
            MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
            MODIFIER_PROPERTY_MANA_BONUS,
            MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
            -- MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
        }
    elseif unit_name == "npc_dota_custom_neutral" then
        func = {
            MODIFIER_PROPERTY_DISABLE_TURNING,
            MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
            MODIFIER_PROPERTY_MANA_BONUS,
            MODIFIER_PROPERTY_PROVIDES_FOW_POSITION,
            -- MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS
        }
    end
	return func
end

function unit_building_core_mod:OnTakeDamage( params )
	if IsServer() then
        local parent = self:GetParent()
        if params.unit == parent and parent:GetUnitName() == "npc_dota_custom_barrack" and parent:GetHealth() <= 0 then
            parent:Stop()
            parent:SetHealth(1)
            parent:AddNewModifier(parent, self:GetAbility(), "unit_destroyed_barrack_mod", {})
            parent:AddNoDraw()
            parent.barrack_timer = 60

            local id = parent:GetPlayerOwnerID()
            
            local gameEvent = {}
            gameEvent["player_id"] = id
            gameEvent["teamnumber"] = -1
            gameEvent["message"] = "#Combat_Message_barrack_destroyed"
            -- FireGameEvent( "dota_combat_event_message", gameEvent )

            if id and PlayerResource:IsValidTeamPlayerID(id) and _G.playersinfo[id].alive then
                local level = parent:GetLevel()
                local gold = {550, 800, 1050, 1300}
                PlayerResource:ModifyGold(id, gold[level], false, DOTA_ModifyGold_Building)
                if parent.gpt and _G.playersinfo[id] and _G.playersinfo[id].gpt then
                    _G.playersinfo[id].gpt = _G.playersinfo[id].gpt - parent.gpt
                    parent.gpt = nil
                end
                local barracks = 0
                local towers = 0
                for k, v in pairs(_G.playersinfo[id].baracks) do
                    if v == parent then
                        _G.playersinfo[id].baracks[k] = nil
                    else
                        barracks = barracks + 1
                    end
                end
                for k, v in pairs(_G.playersinfo[id].towers) do
                    towers = towers + 1
                end
                if _G.playersinfo[id].ancient == nil and barracks == 0 and towers == 0 then
                    _G:Defeat(id)
                end

                --Challenges:TriggerEvent(id, "barrack_destroyed", {barrack = parent})
            end
            local attacker = params.attacker
            if attacker then
                PlayerResource:ModifyGold(attacker:GetPlayerOwnerID(), parent:GetGoldBounty(), false, DOTA_ModifyGold_Building)
            end
        end
	end
end

function unit_building_core_mod:GetModifierManaBonus()
    return self:GetCaster().mana
end

-- function unit_building_core_mod:GetModifierExtraHealthBonus()
--     return self:GetCaster().extra_health
-- end

function unit_building_core_mod:GetModifierIgnoreCastAngle()
    return 1
end


function unit_building_core_mod:GetModifierDisableTurning()
    return 1
end

function unit_building_core_mod:GetModifierProvidesFOWVision()
    if self.pv then 
        return 1
    else
        return 0
    end
end

unit_destroyed_barrack_mod = class({})

function unit_destroyed_barrack_mod:IsHidden()
    return true
end

function unit_destroyed_barrack_mod:CheckState()
    local state = {}
	state[MODIFIER_STATE_DISARMED] = true
	state[MODIFIER_STATE_ATTACK_IMMUNE] = true
	state[MODIFIER_STATE_SILENCED] = true
	state[MODIFIER_STATE_MUTED] = true
	state[MODIFIER_STATE_STUNNED] = true
	state[MODIFIER_STATE_INVULNERABLE] = true
	state[MODIFIER_STATE_MAGIC_IMMUNE] = true
	state[MODIFIER_STATE_UNSELECTABLE] = true
	state[MODIFIER_STATE_NOT_ON_MINIMAP] = true
	state[MODIFIER_STATE_NO_HEALTH_BAR] = true
	state[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	state[MODIFIER_STATE_OUT_OF_GAME] = true
	return state
end

-- function unit_destroyed_barrack_mod:DeclareFunctions()
-- 	local funcs = 
-- 	{
-- 		MODIFIER_PROPERTY_DISABLE_TURNING,
-- 		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
-- 	}

-- 	return funcs
-- end

-- function unit_destroyed_barrack_mod:GetModifierIgnoreCastAngle()
--     return 1
-- end


-- function unit_destroyed_barrack_mod:GetModifierDisableTurning()
--     return 1
-- end