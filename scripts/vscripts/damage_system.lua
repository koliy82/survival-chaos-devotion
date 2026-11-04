_G.resistarray = {
	{1,   1.5,  1,    0.9, 1,    1},
	{1.5, 0.75, 0.75, 0.5, 0.75, 1.5},
	{1,   0.5,  0.75, 1.75,0.5 , 1.5},
	{1.25,0.75, 1.5,  0.75,0.75, 1},
	{1,1,1,1,1,1},
	{1,0.75,0.75,1,0.7,1},
	{1,1,1,0.25,1,1}
}
--[[
	Damage Types
	Normal = 1 normal_attack
	Pierce = 2 pierce_attack
	Siege = 3 siege_attack
	Magic = 4 magic_attack
	Chaos = 5 chaos_attack
	Spells = 6 spells_attack
	Hero = 7 hero_attack

	Armor Types
	Light = 1 light_armor
	Medium = 2 medium_armor
	Heavy = 3 heavy_armor
	Fort = 4 fort_armor
	Hero = 5 hero_armor
	Unarmored = 6 unarmored_armor
]]
--[[
////////////////////////////////////////////////////////
Dealing fire damage from Lua
ApplyCustomDamage(target, caster, damage, damage_type, ability)

    "RunScript"
    {
        "Target"		"TARGET"
        "ScriptFile"		"abilities/custom_attack.lua"
        "Function"		"ApplyDamage"
        "damage"        "100"
        "type"          "1"

        //Damage Types
        //Normal = 1
        //Pierce = 2
        //Siege = 3
        //Magic = 4
        //Chaos = 5
        //Spells = 6
        //Hero = 7
    }

        //Damage Types
        //Normal = 1
        //Pierce = 2
        //Siege = 3
        //Magic = 4
        //Chaos = 5
        //Spells = 6
        //Hero = 7
]]


if DamageSystem == nil then
    print ( '[DamageSystem] creating DamageSystem' )
    DamageSystem = {}
    DamageSystem.__index = DamageSystem
end


function DamageSystem:DamageFilter( event )
    if event.damagetype_const ~= 1 then
        return true
    end
    event.damagetype_const = DAMAGE_TYPE_PURE
    local attacker = EntIndexToHScript(event.entindex_attacker_const)
    local victim = EntIndexToHScript(event.entindex_victim_const)
    -- local ability = attacker
    -- local attack = true
    -- if event.entindex_inflictor_const then --if there is no inflictor key then it was an auto attack
    --     attack = false
    --     ability = EntIndexToHScript(event.entindex_inflictor_const)
    -- end
    --print( '********damage event************' )
    -- for k, v in pairs(event) do
    --     print("DamageFilter: ",k, " ==> ", v)
    -- end

    if attacker.custom_damage_type == nil then
        return true
    end
    
    --print('DamageFilter: attack type:')
    --print('>', attacker.custom_damage_type)
    
    event.damage = DamageConverting(attacker:GetAverageTrueAttackDamage(victim), attacker, victim, nil)

    if event.damage <= 0 then
        --print('DamageFilter: Damage is 0')
        return false
    end

    return true
end

--damage dealing function for RunScript calls
function ApplyCustomDamage(victim, attacker, damage, customdamagetype, ability)
    --print('DamageFilter: victim resistances:')
    --for k,v in pairs(victim.resistances) do print(k,v) end
    --EntIndexToHScript(DamageSystem.handle)

    local newdamage = DamageConverting(damage, attacker, victim, customdamagetype)

    if newdamage <= 0 then
        --print('DamageFilter: Damage is 0')
        return
    end

    local damageTable = {
        victim = victim,
        attacker = attacker,
        damage = newdamage,
        damage_type = DAMAGE_TYPE_PURE,
        ability = ability
    }
    -- print('[DamageSystem] Dealing ', customdamagetype, ' old_damage ', damage, ' new_damage ', newdamage)
    ApplyDamage(damageTable)   
end


function ApplyPureDamage(event)
    local attacker = event.caster
    local victim = event.target
    local damage = tonumber(event.damage)
     local damageTable = {
        victim = victim,
        attacker = attacker,
        damage = damage,
        damage_type = DAMAGE_TYPE_PURE
        -- ability = ability
    }
    -- print('[DamageSystem] Dealing ', customdamagetype, ' old_damage ', damage, ' new_damage ', newdamage)
    ApplyDamage(damageTable)   
end

--damage dealing function for RunScript calls
function ApplyPureDamageTable(victim, attacker, damage, ability)
    --print('DamageFilter: victim resistances:')
    --for k,v in pairs(victim.resistances) do print(k,v) end
    --EntIndexToHScript(DamageSystem.handle)

    if damage <= 0 then
        --print('DamageFilter: Damage is 0')
        return
    end

    local damageTable = {
        victim = victim,
        attacker = attacker,
        damage = damage,
        damage_type = DAMAGE_TYPE_PURE,
        ability = ability
    }
    -- print('[DamageSystem] Dealing ', customdamagetype, ' old_damage ', damage, ' new_damage ', newdamage)
    ApplyDamage(damageTable)   
end


function DamageConverting(damage, attacker, victim, customdamagetype)
    if not damage then return 0 end
    if not victim then return 0 end
    if not victim.custom_armor_type then return 0 end
    -- if not attacker and not customdamagetype then return damage end

    local damage_type = customdamagetype or attacker.custom_damage_type

    local locdamage = damage 
        * victim.custom_damage_reduction[0]
        * _G.resistarray[damage_type][victim.custom_armor_type] 
        * victim.custom_damage_reduction[damage_type]
    if attacker then
        if attacker.custom_damage_armor_multiplier then
            locdamage = locdamage * (attacker.custom_damage_armor_multiplier[victim.custom_armor_type] or 1) * (attacker.custom_damage_armor_multiplier[0] or 1)
        end
        if attacker.custom_damage_attack_multiplier then
            locdamage = locdamage * (attacker.custom_damage_attack_multiplier[damage_type] or 1) * (attacker.custom_damage_attack_multiplier[0] or 1)
        end
    end
    local armor = victim:GetPhysicalArmorValue(false)
    local new_armor = math.abs(armor)
    local resist = new_armor * 6 / (1 + new_armor * 0.06)
    if armor < 0 then
        resist = -1*resist
    end
    local newdamage = locdamage - locdamage / 100 * resist

    if victim.custom_block then
        local block = victim.custom_block[damage_type] + victim.custom_block[0]
        if newdamage < block then
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, victim, newdamage, nil)
        else
            SendOverheadEventMessage(nil, OVERHEAD_ALERT_BLOCK, victim, block, nil)
        end
        newdamage = newdamage - block
    end

    if newdamage <= 0 then return 0 end

    local barriers = victim:FindAllModifiersByName("modifier_custom_barrier")
    for _,barrier in pairs(barriers) do
        if barrier.damage_type == damage_type then
            if newdamage > 0 then
                newdamage = barrier:DamageBarrier(newdamage)
            else
                break
            end
        end
    end
    if newdamage > 0 then
        for _,barrier in pairs(barriers) do
            if barrier.damage_type == 0 then
                if newdamage > 0 then
                    newdamage = barrier:DamageBarrier(newdamage)
                else
                    break
                end
            end
        end
    end
    return newdamage
end

LinkLuaModifier( "modifier_custom_barrier", "modifiers/modifier_custom_barrier.lua", LUA_MODIFIER_MOTION_NONE )
function CDOTA_BaseNPC:AddBarrier(durability, damage_type, duration, source, source_ability)
    return self:AddNewModifier(source, source_ability, "modifier_custom_barrier", {duration = duration, durability = durability, damage_type = damage_type})
end