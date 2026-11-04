--frostivus
function OnSpellStart(event)
    local caster = event.caster
    local player = caster:GetPlayerOwner()
    local id = caster:GetPlayerOwnerID()
    if frostivus.player_gifts[id] then
        CustomGameEventManager:Send_ServerToPlayer(player, "OpenSelectGift", frostivus.player_gifts[id])
    else
        CustomGameEventManager:Send_ServerToPlayer(player, "display_custom_error", { message = "#display_no_gifts_error" })
    end
end