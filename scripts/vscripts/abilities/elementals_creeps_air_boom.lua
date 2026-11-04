function OnCreated(keys)
	local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    if caster:GetUnitName() == "npc_dota_elementals_air" then 
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_elementals_creeps_air_boom", {})
    else
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_elementals_creeps_air_boom_summon", {})
    end
end