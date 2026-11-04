function OnKill(keys)
	local caster = keys.caster
	local ability = keys.ability
    local level = ability:GetLevel()

    local gold = ability:GetLevelSpecialValueFor( "gold" , level - 1 )
	local id = caster:GetPlayerOwnerID()

	caster:EmitSound("General.Coins")
	PlayerResource:ModifyGold(id, gold, false, DOTA_ModifyGold_CreepKill)
end

function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()
    local add_gpt = ability:GetSpecialValueFor( "gpt" )
    caster.gpt = caster.gpt + add_gpt
    _G.playersinfo[id].gpt = _G.playersinfo[id].gpt + add_gpt

    for k, v in pairs(_G.playersinfo[id].towers) do
        ability:ApplyDataDrivenModifier(caster, v, "modifier_pirates_ancient_gold_aura_regen", {})
    end
    for k, v in pairs(_G.playersinfo[id].baracks) do
        ability:ApplyDataDrivenModifier(caster, v, "modifier_pirates_ancient_gold_aura_regen", {})
    end
    ability:ApplyDataDrivenModifier(caster, _G.playersinfo[id].ancient, "modifier_pirates_ancient_gold_aura_regen", {})
end