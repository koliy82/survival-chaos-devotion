function OnSpellStart(event)
    local caster = event.caster
    local ability = event.ability
	local level = ability:GetLevel()
    local skeletons = ability:GetLevelSpecialValueFor( "skeletons" , level - 1  )
    local skeletons_health = ability:GetLevelSpecialValueFor( "skeletons_health" , level - 1  )
    local skeletons_armor = ability:GetLevelSpecialValueFor( "skeletons_armor" , level - 1  )
    local skeletons_damage = ability:GetLevelSpecialValueFor( "skeletons_damage" , level - 1  )
    local owner = caster:GetOwner()
    local id = caster:GetPlayerOwnerID()
    _G.playersinfo[id].unitsinfo["npc_dota_undead_skeleton"].health = skeletons_health
    _G.playersinfo[id].unitsinfo["npc_dota_undead_skeleton"].armor = skeletons_armor
    _G.playersinfo[id].unitsinfo["npc_dota_undead_skeleton"].min_damage = skeletons_damage - 2
    _G.playersinfo[id].unitsinfo["npc_dota_undead_skeleton"].max_damage = skeletons_damage + 2
    
    for i=1, skeletons do
        local skeleton = CreateUnitByName("npc_dota_undead_skeleton", caster:GetAbsOrigin(), true, owner, owner, caster:GetTeam())
        skeleton.previous_point = caster.previous_point
        skeleton.to_point = caster.to_point
        FindClearSpaceForUnit( skeleton, caster:GetAbsOrigin()+RandomVector( 150 ), false )
        ability:ApplyDataDrivenModifier( caster, skeleton, "modifier_undead_hero_tank_summon_skeleton", {} )
    end
end