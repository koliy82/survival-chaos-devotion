function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()

    if _G.playersinfo[id].ancient then
        ability:ApplyDataDrivenModifier(caster, _G.playersinfo[id].ancient, "modifier_frostivus_ancient_builds_regen_buff", {})
        ability:ApplyDataDrivenModifier(caster, _G.playersinfo[id].ancient, "modifier_frostivus_ancient_builds_mana_regen_buff", {})
	end
    for k, v in pairs(_G.playersinfo[id].baracks) do
        ability:ApplyDataDrivenModifier(caster, v, "modifier_frostivus_ancient_builds_regen_buff", {})
	end
    for k, v in pairs(_G.playersinfo[id].towers) do
        ability:ApplyDataDrivenModifier(caster, v, "modifier_frostivus_ancient_builds_regen_buff", {})
	end
end

function OnDestroy(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()

    if _G.playersinfo[id].ancient then
        _G.playersinfo[id].ancient:RemoveModifierByName("modifier_frostivus_ancient_builds_regen_buff")
        _G.playersinfo[id].ancient:RemoveModifierByName("modifier_frostivus_ancient_builds_mana_regen_buff")
	end
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:RemoveModifierByName("modifier_frostivus_ancient_builds_regen_buff")
	end
    for k, v in pairs(_G.playersinfo[id].towers) do
        v:RemoveModifierByName("modifier_frostivus_ancient_builds_regen_buff")
	end
end