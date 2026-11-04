function OnSpellStart(event)
    local caster = event.caster
    local ability = event.ability
	local ability_level = ability:GetLevel() - 1
	local duration = ability:GetLevelSpecialValueFor("duration", ability_level)
    local id = caster:GetPlayerOwnerID()
    if _G.playersinfo[id].ancient then
        ability:ApplyDataDrivenModifier(caster, _G.playersinfo[id].ancient, "modifier_diretide_ancient_candy_abil2", {duration = duration})
    end
    for k, v in pairs(_G.playersinfo[id].baracks) do
        ability:ApplyDataDrivenModifier(caster, v, "modifier_diretide_ancient_candy_abil2", {duration = duration})
    end
    for k, v in pairs(_G.playersinfo[id].towers) do
        ability:ApplyDataDrivenModifier(caster, v, "modifier_diretide_ancient_candy_abil2", {duration = duration})
    end
end