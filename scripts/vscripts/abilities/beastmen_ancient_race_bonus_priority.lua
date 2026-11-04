function OnSpellStart(event)
    local target = event.target
    local caster = event.caster
    -- local id = caster:GetPlayerOwnerID()
    if target:GetUnitName() ~= "npc_dota_custom_barrack" or caster:GetPlayerOwnerID() ~= target:GetPlayerOwnerID() then
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#dota_hud_error_cant_cast_on_other" })
        return
    end

    local race_abil = caster:FindAbilityByName("beastmen_race_bonus")
    race_abil.priority = target
    target.barrack_timer = target.barrack_timer - event.time_red
    event.ability:SetActivated(false)
end