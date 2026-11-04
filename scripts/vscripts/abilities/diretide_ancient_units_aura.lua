function OnSpellStart(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    if not (_G.playersinfo[id].ancient and _G.playersinfo[id].ancient:GetLevel() > 2) then
        caster:Stop()
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#need_ancient_level_3" })
    end
end

function OnCreated(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()

    for k, v in pairs(_G.playersinfo[id].baracks) do
        v.units["npc_dota_diretide_aura_melee"] = 1
        v.units["npc_dota_diretide_aura_range"] = 1
    end
end

function OnChannelSucceeded(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()

    _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_melee"].health + 275
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_melee"].armor + 6
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_melee"].min_damage = _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_melee"].min_damage + 12
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_melee"].max_damage = _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_melee"].max_damage + 12
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_melee"].abilities["diretide_creeps_aura_melee_aura"] = 2
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_melee"].abilities["diretide_creeps_aura_melee_manaburn"] = 2

    _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_range"].health + 275
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_range"].armor + 6
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_range"].min_damage = _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_range"].min_damage + 12
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_range"].max_damage = _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_range"].max_damage + 12
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_range"].abilities["diretide_creeps_aura_range_aura"] = 2
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_aura_range"].abilities["diretide_creeps_aura_range_cookie"] = 2
    
    ability:SetLevel(2)
    ability:SetActivated(false)
end