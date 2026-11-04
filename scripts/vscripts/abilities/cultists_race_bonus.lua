function OnSpellStart(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()
    local id = caster:GetPlayerOwnerID()
    if not (_G.playersinfo[id].ancient and _G.playersinfo[id].ancient:GetLevel() >= level) then
        caster:Stop()
        CustomGameEventManager:Send_ServerToPlayer(caster:GetPlayerOwner(), "display_custom_error", { message = "#need_ancient_level_"..(level) })
    end
end

function OnChannelSucceeded(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()

    ability:SetLevel(level + 1)
    if level == 3 then
        ability:SetActivated(false)
    end
    --ability:StartCooldown(event.duration)
end

function AddHP(event)
    local id = event.caster:GetPlayerOwnerID()

    _G.playersinfo[id].unitsinfo["npc_dota_cultists_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_melee"].health + event.bonus_health
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_range"].health + event.bonus_health
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].health + event.bonus_health
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme"].health + event.bonus_health
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme_spec"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme_spec"].health + event.bonus_health
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_air"].health + event.bonus_health
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_siege"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_siege"].health + event.bonus_health
end

function ReduceHP(event)
    local id = event.caster:GetPlayerOwnerID()

    _G.playersinfo[id].unitsinfo["npc_dota_cultists_melee"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_melee"].health - event.bonus_health
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_range"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_range"].health - event.bonus_health
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_mage"].health - event.bonus_health
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme"].health - event.bonus_health
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme_spec"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_arme_spec"].health - event.bonus_health
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_air"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_air"].health - event.bonus_health
    _G.playersinfo[id].unitsinfo["npc_dota_cultists_siege"].health = _G.playersinfo[id].unitsinfo["npc_dota_cultists_siege"].health - event.bonus_health
end

function RitualGoing(event)
    local caster = event.target

    if caster:GetHealthPercent() == 100 then

        local damageTable = {
            victim = caster,
            attacker = caster,
            damage = caster:GetMaxHealth() * event.hp_red / 100,
            damage_type = DAMAGE_TYPE_PURE
        }
        ApplyDamage(damageTable)
    end
end