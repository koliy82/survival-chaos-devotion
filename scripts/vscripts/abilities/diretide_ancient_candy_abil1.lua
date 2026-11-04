function OnSpellStart(event)
    local caster = event.caster
    local ability = event.ability
	local ability_level = ability:GetLevel() - 1
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
    local id = caster:GetPlayerOwnerID()
	local owner = caster:GetOwner()
    
    for k, v in pairs(_G.playersinfo[id].baracks) do
        for i = 0, GameRules:GetDOTATime(false, true), 20 * 60 do
            local unit = CreateUnitByName("npc_dota_diretide_candys_melee", v.creepspawnpoint, true, owner, owner, caster:GetTeam())
            unit.custom_damage_armor_multiplier[4] = 0.4
        end
    end
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_candys_melee"].armor = _G.playersinfo[id].unitsinfo["npc_dota_diretide_candys_melee"].armor + 1
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_candys_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_diretide_candys_melee"].health + 90
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_candys_melee"].min_damage = _G.playersinfo[id].unitsinfo["npc_dota_diretide_candys_melee"].min_damage + 10
    _G.playersinfo[id].unitsinfo["npc_dota_diretide_candys_melee"].max_damage = _G.playersinfo[id].unitsinfo["npc_dota_diretide_candys_melee"].max_damage + 10
end