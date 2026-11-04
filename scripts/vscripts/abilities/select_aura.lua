function OnSpellStart(event)
    local caster = event.caster
    local player = caster:GetPlayerOwner()
    if caster:GetLevel() > 1 then
        CustomGameEventManager:Send_ServerToPlayer(player, "OpenSelectAbil", {mode = "aura", auras = _G.playersinfo[player:GetPlayerID()].raceinfo["auras"]})
    else
        CustomGameEventManager:Send_ServerToPlayer(player, "display_custom_error", { message = "#need_ancient_level_2" })
    end
end