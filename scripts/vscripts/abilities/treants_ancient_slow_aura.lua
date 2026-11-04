function OnCreated(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_treants_tiny_spec"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_tiny_spec"].health + event.hp
    _G.playersinfo[id].unitsinfo["npc_dota_treants_melee_v2"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_melee_v2"].health + event.hp
    _G.playersinfo[id].unitsinfo["npc_dota_treants_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_melee"].health + event.hp
    _G.playersinfo[id].unitsinfo["npc_dota_treants_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_range"].health + event.hp
    _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].health + event.hp
    _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].health + event.hp
    _G.playersinfo[id].unitsinfo["npc_dota_treants_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_air"].health + event.hp
    _G.playersinfo[id].unitsinfo["npc_dota_treants_siege"].health = _G.playersinfo[id].unitsinfo["npc_dota_treants_siege"].health + event.hp
    
    _G.playersinfo[id].unitsinfo["npc_dota_treants_tiny_spec"].armor = _G.playersinfo[id].unitsinfo["npc_dota_treants_tiny_spec"].armor + event.armor
    _G.playersinfo[id].unitsinfo["npc_dota_treants_melee_v2"].armor = _G.playersinfo[id].unitsinfo["npc_dota_treants_melee_v2"].armor + event.armor
    _G.playersinfo[id].unitsinfo["npc_dota_treants_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_treants_melee"].armor + event.armor
    _G.playersinfo[id].unitsinfo["npc_dota_treants_range"].armor = _G.playersinfo[id].unitsinfo["npc_dota_treants_range"].armor + event.armor
    _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].armor = _G.playersinfo[id].unitsinfo["npc_dota_treants_mage"].armor + event.armor
    _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].armor = _G.playersinfo[id].unitsinfo["npc_dota_treants_arme"].armor + event.armor
    _G.playersinfo[id].unitsinfo["npc_dota_treants_air"].armor = _G.playersinfo[id].unitsinfo["npc_dota_treants_air"].armor + event.armor
    _G.playersinfo[id].unitsinfo["npc_dota_treants_siege"].armor = _G.playersinfo[id].unitsinfo["npc_dota_treants_siege"].armor + event.armor
end