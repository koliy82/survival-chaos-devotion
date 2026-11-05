LinkLuaModifier( "modifier_frostivus_creep_damage_gift_1", "modifiers/frostivus_modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_frostivus_creep_damage_gift_2", "modifiers/frostivus_modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_frostivus_creep_damage_gift_3", "modifiers/frostivus_modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_frostivus_creep_damage_gift_4", "modifiers/frostivus_modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_frostivus_creep_damage_gift_5", "modifiers/frostivus_modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_frostivus_buildings_regen_1_buff", "modifiers/frostivus_modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_frostivus_buildings_regen_2_buff", "modifiers/frostivus_modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_frostivus_buildings_regen_3_buff", "modifiers/frostivus_modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_frostivus_buildings_regen_4_buff", "modifiers/frostivus_modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_frostivus_buildings_regen_5_buff", "modifiers/frostivus_modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_frostivus_double_spawn_creep_armor_gift", "modifiers/frostivus_modifiers", LUA_MODIFIER_MOTION_NONE )

local frostivus = {}
frostivus.gifts = {
    {-- 1 LVL
    --gold_1
        {
            name = "name_gold_gift_1",
            description = "description_gold_gift_1",
            image = "file://{images}/frostivus/gifts/gold.png",
            GiveGift = function(self, id)
                PlayerResource:ModifyGold(id, 200, false, 0)
            end
        },
        --delayed_gold_1
        {
            name = "name_delayed_gold_gift_1",
            description = "description_delayed_gold_gift_1",
            image = "file://{images}/frostivus/gifts/delayed_gold.png",
            GiveGift = function(self, id)
                Timers:CreateTimer(360, function()
                    PlayerResource:ModifyGold(id, 300, false, 0)
                end)
            end
        },
        --damage_1
        {
            name = "name_creep_damage_gift_5",
            description = "description_creep_damage_gift_5",
            image = "file://{images}/frostivus/gifts/creep_damage.png",
            GiveGift = function(self, id)
                if _G.playersinfo[id].ancient then
                    _G.playersinfo[id].ancient:AddNewModifier(_G.playersinfo[id].ancient, nil, "modifier_frostivus_creep_damage_gift_5", {duration = 200})
                    local targets = FindUnitsInRadius(PlayerResource:GetTeam(id), Vector(0,0,0), nil, 999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_ANY_ORDER, false)
                    for _, target in pairs(targets) do
                    	target:Heal(target:GetMaxHealth(), nil)
                    end
                end
            end
        },
        --regen_1
        {
            name = "name_buildings_regen_gift_5",
            description = "description_buildings_regen_gift_5",
            image = "file://{images}/frostivus/gifts/buildings_regen.png",
            GiveGift = function(self, id)
                if _G.playersinfo[id].ancient then
                    _G.playersinfo[id].ancient:AddNewModifier(_G.playersinfo[id].ancient, nil, "modifier_frostivus_buildings_regen_5_buff", {duration = 300})
                end
                for k, v in pairs(_G.playersinfo[id].baracks) do
                    v:AddNewModifier(v, nil, "modifier_frostivus_buildings_regen_5_buff", {duration = 300})
                end
                for k, v in pairs(_G.playersinfo[id].towers) do
                    v:AddNewModifier(v, nil, "modifier_frostivus_buildings_regen_5_buff", {duration = 300})
                end
            end
        },
        --mana_1
        {
            name = "name_ancient_mana_gift_5",
            description = "description_ancient_mana_gift_5",
            image = "file://{images}/frostivus/gifts/ancient_mana.png",
            GiveGift = function(self, id)
                if _G.playersinfo[id].ancient then
                    _G.playersinfo[id].ancient:GiveMana(70)
                end
            end
        },
        --double_1
        {
            name = "name_double_spawn_gift",
            description = "description_double_spawn_gift",
            image = "file://{images}/frostivus/gifts/double_spawn.png",
            GiveGift = function(self, id)
                for k, barack in pairs(_G.playersinfo[id].all_baracks) do
                    barack.double_spawn = true
                end
                if _G.playersinfo[id].ancient then
                    _G.playersinfo[id].ancient:AddNewModifier(_G.playersinfo[id].ancient, nil, "modifier_frostivus_double_spawn_creep_armor_gift", {duration = 200})
                end
            end
        }
    },
    {-- 2 LVL
    --gold_2
        {
            name = "name_gold_gift_2",
            description = "description_gold_gift_2",
            image = "file://{images}/frostivus/gifts/gold.png",
            GiveGift = function(self, id)
                PlayerResource:ModifyGold(id, 280, false, 0)
            end
        },
        --delayed_gold_2
        {
            name = "name_delayed_gold_gift_2",
            description = "description_delayed_gold_gift_2",
            image = "file://{images}/frostivus/gifts/delayed_gold.png",
            GiveGift = function(self, id)
                Timers:CreateTimer(360, function()
                    PlayerResource:ModifyGold(id, 420, false, 0)
                end)
            end
        },
        --damage_2
        {
            name = "name_creep_damage_gift_5",
            description = "description_creep_damage_gift_5",
            image = "file://{images}/frostivus/gifts/creep_damage.png",
            GiveGift = function(self, id)
                if _G.playersinfo[id].ancient then
                    _G.playersinfo[id].ancient:AddNewModifier(_G.playersinfo[id].ancient, nil, "modifier_frostivus_creep_damage_gift_5", {duration = 200})
                    local targets = FindUnitsInRadius(PlayerResource:GetTeam(id), Vector(0,0,0), nil, 999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_ANY_ORDER, false)
                    for _, target in pairs(targets) do
                    	target:Heal(target:GetMaxHealth(), nil)
                    end
                end
            end
        },
        --regen_2
        {
            name = "name_buildings_regen_gift_5",
            description = "description_buildings_regen_gift_5",
            image = "file://{images}/frostivus/gifts/buildings_regen.png",
            GiveGift = function(self, id)
                if _G.playersinfo[id].ancient then
                    _G.playersinfo[id].ancient:AddNewModifier(_G.playersinfo[id].ancient, nil, "modifier_frostivus_buildings_regen_5_buff", {duration = 300})
                end
                for k, v in pairs(_G.playersinfo[id].baracks) do
                    v:AddNewModifier(v, nil, "modifier_frostivus_buildings_regen_5_buff", {duration = 300})
                end
                for k, v in pairs(_G.playersinfo[id].towers) do
                    v:AddNewModifier(v, nil, "modifier_frostivus_buildings_regen_5_buff", {duration = 300})
                end
            end
        },
        --mana_2
        {
            name = "name_ancient_mana_gift_5",
            description = "description_ancient_mana_gift_5",
            image = "file://{images}/frostivus/gifts/ancient_mana.png",
            GiveGift = function(self, id)
                if _G.playersinfo[id].ancient then
                    _G.playersinfo[id].ancient:GiveMana(70)
                end
            end
        },
        --steal_2
        {
            name = "name_gold_steal_gift",
            description = "description_gold_steal_gift",
            image = "file://{images}/frostivus/gifts/gold_steal.png",
            GiveGift = function(self, id)
                local enemies = {}
                for id2, data in pairs(_G.playersinfo) do
                    if data.alive and PlayerResource:GetTeam(id) ~= PlayerResource:GetTeam(id2) then
                        table.insert( enemies, id2 )
                    end
                end
                if #enemies > 0 then
                    local target_id = enemies[RandomInt(1, #enemies)]
                    local target_gold = PlayerResource:GetGold(target_id)
                    local steal_gold = math.ceil(target_gold * 0.35)
                    if steal_gold > 400 then
                        steal_gold = 400
                    end
                    PlayerResource:SetGold(id, PlayerResource:GetGold(id) + steal_gold, false)
                    PlayerResource:SetGold(target_id, target_gold - steal_gold, false)
                    
                    local gameEvent = {}
                    gameEvent["player_id"] = target_id
                    gameEvent["teamnumber"] = -1
                    gameEvent["locstring_value"] = steal_gold
                    gameEvent["message"] = "#Combat_Message_gold_steal"
                    FireGameEvent( "dota_combat_event_message", gameEvent )
                end
            end
        }
    },
    {-- 3 LVL
    --gold_3
        {
            name = "name_gold_gift_3",
            description = "description_gold_gift_3",
            image = "file://{images}/frostivus/gifts/gold.png",
            GiveGift = function(self, id)
                PlayerResource:ModifyGold(id, 400, false, 0)
            end
        },
        --delayed_gold_3
        {
            name = "name_delayed_gold_gift_3",
            description = "description_delayed_gold_gift_3",
            image = "file://{images}/frostivus/gifts/delayed_gold.png",
            GiveGift = function(self, id)
                Timers:CreateTimer(360, function()
                    PlayerResource:ModifyGold(id, 600, false, 0)
                end)
            end
        },
        --damage_3
        {
            name = "name_creep_damage_gift_5",
            description = "description_creep_damage_gift_5",
            image = "file://{images}/frostivus/gifts/creep_damage.png",
            GiveGift = function(self, id)
                if _G.playersinfo[id].ancient then
                    _G.playersinfo[id].ancient:AddNewModifier(_G.playersinfo[id].ancient, nil, "modifier_frostivus_creep_damage_gift_5", {duration = 200})
                    local targets = FindUnitsInRadius(PlayerResource:GetTeam(id), Vector(0,0,0), nil, 999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_ANY_ORDER, false)
                    for _, target in pairs(targets) do
                    	target:Heal(target:GetMaxHealth(), nil)
                    end
                end
            end
        },
        --regen_3
        {
            name = "name_buildings_regen_gift_5",
            description = "description_buildings_regen_gift_5",
            image = "file://{images}/frostivus/gifts/buildings_regen.png",
            GiveGift = function(self, id)
                if _G.playersinfo[id].ancient then
                    _G.playersinfo[id].ancient:AddNewModifier(_G.playersinfo[id].ancient, nil, "modifier_frostivus_buildings_regen_5_buff", {duration = 300})
                end
                for k, v in pairs(_G.playersinfo[id].baracks) do
                    v:AddNewModifier(v, nil, "modifier_frostivus_buildings_regen_5_buff", {duration = 300})
                end
                for k, v in pairs(_G.playersinfo[id].towers) do
                    v:AddNewModifier(v, nil, "modifier_frostivus_buildings_regen_5_buff", {duration = 300})
                end
            end
        },
        --mana_3
        {
            name = "name_ancient_mana_gift_5",
            description = "description_ancient_mana_gift_5",
            image = "file://{images}/frostivus/gifts/ancient_mana.png",
            GiveGift = function(self, id)
                if _G.playersinfo[id].ancient then
                    _G.playersinfo[id].ancient:GiveMana(70)
                end
            end
        },
        --more_3
        {
            name = "name_more_gifts_gift",
            description = "description_more_gifts_gift",
            image = "file://{images}/frostivus/gifts/more_gifts.png",
            GiveGift = function(self, id)
                frostivus:GiveGift(id, frostivus.gifts[2][RandomInt(1, #frostivus.gifts[2])], true)
                local giftlvl3id = RandomInt(1, #frostivus.gifts[3] - 1)
                local giftlvl3 = frostivus.gifts[3][giftlvl3id]
                if giftlvl3 == self then
                    giftlvl3 = frostivus.gifts[3][giftlvl3id + 1]
                end
                frostivus:GiveGift(id, giftlvl3, true)
            end
        }
    },
    {-- 4 LVL
    --gold_4
        {
            name = "name_gold_gift_4",
            description = "description_gold_gift_4",
            image = "file://{images}/frostivus/gifts/gold.png",
            GiveGift = function(self, id)
                PlayerResource:ModifyGold(id, 560, false, 0)
            end
        },
        --delayed_gold_4
        {
            name = "name_delayed_gold_gift_4",
            description = "description_delayed_gold_gift_4",
            image = "file://{images}/frostivus/gifts/delayed_gold.png",
            GiveGift = function(self, id)
                Timers:CreateTimer(360, function()
                    PlayerResource:ModifyGold(id, 840, false, 0)
                end)
            end
        },
        --damage_4
        {
            name = "name_creep_damage_gift_5",
            description = "description_creep_damage_gift_5",
            image = "file://{images}/frostivus/gifts/creep_damage.png",
            GiveGift = function(self, id)
                if _G.playersinfo[id].ancient then
                    _G.playersinfo[id].ancient:AddNewModifier(_G.playersinfo[id].ancient, nil, "modifier_frostivus_creep_damage_gift_5", {duration = 200})
                    local targets = FindUnitsInRadius(PlayerResource:GetTeam(id), Vector(0,0,0), nil, 999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_ANY_ORDER, false)
                    for _, target in pairs(targets) do
                    	target:Heal(target:GetMaxHealth(), nil)
                    end
                end
            end
        },
        --regen_4
        {
            name = "name_buildings_regen_gift_5",
            description = "description_buildings_regen_gift_5",
            image = "file://{images}/frostivus/gifts/buildings_regen.png",
            GiveGift = function(self, id)
                if _G.playersinfo[id].ancient then
                    _G.playersinfo[id].ancient:AddNewModifier(_G.playersinfo[id].ancient, nil, "modifier_frostivus_buildings_regen_5_buff", {duration = 300})
                end
                for k, v in pairs(_G.playersinfo[id].baracks) do
                    v:AddNewModifier(v, nil, "modifier_frostivus_buildings_regen_5_buff", {duration = 300})
                end
                for k, v in pairs(_G.playersinfo[id].towers) do
                    v:AddNewModifier(v, nil, "modifier_frostivus_buildings_regen_5_buff", {duration = 300})
                end
            end
        },
        --mana_4
        {
            name = "name_ancient_mana_gift_5",
            description = "description_ancient_mana_gift_5",
            image = "file://{images}/frostivus/gifts/ancient_mana.png",
            GiveGift = function(self, id)
                if _G.playersinfo[id].ancient then
                    _G.playersinfo[id].ancient:GiveMana(70)
                end
            end
        },
        --double_4
        {
            name = "name_double_spawn_gift",
            description = "description_double_spawn_gift",
            image = "file://{images}/frostivus/gifts/double_spawn.png",
            GiveGift = function(self, id)
                for k, barack in pairs(_G.playersinfo[id].all_baracks) do
                    barack.double_spawn = true
                end
                if _G.playersinfo[id].ancient then
                    _G.playersinfo[id].ancient:AddNewModifier(_G.playersinfo[id].ancient, nil, "modifier_frostivus_double_spawn_creep_armor_gift", {duration = 200})
                end
            end
        }
    },
    {-- 5 LVL,
    --attack_5
        {
            name = "name_attack_enemy_baracks_gift",
            description = "description_attack_enemy_baracks_gift",
            image = "file://{images}/frostivus/gifts/attack_enemy_baracks.png",
            GiveGift = function(self, id)
                if _G.playersinfo[id].ancient and _G.playersinfo[id].ancient:IsAlive() then
                    local enemy_baracks = {}
                    for id2, data in pairs(_G.playersinfo) do
                        if PlayerResource:GetTeam(id) ~= PlayerResource:GetTeam(id2) then
                            for k, barack in pairs(data.baracks) do
                                table.insert( enemy_baracks, barack )
                            end
                        end
                    end
                    local ability = _G.playersinfo[id].ancient:AddAbility("attack_enemy_baracks_gift")
                    local baracks_count = #enemy_baracks
                    if baracks_count > 3 then
                        local barackid1 = RandomInt(1, baracks_count)
                        local barackid2 = RandomInt(1, baracks_count-1)
                        if barackid1 == barackid2 then
                            barackid2 = barackid2 + 1
                        end
                        local barackid3 = RandomInt(1, baracks_count-2)
                        if barackid1 == barackid3 or barackid2 == barackid3 then
                            barackid3 = barackid3 + 1
                            if barackid1 == barackid3 or barackid2 == barackid3 then
                                barackid3 = barackid3 + 1
                            end
                        end

                        local projectile1 = {
                            Target = enemy_baracks[barackid1],
                            Source = _G.playersinfo[id].ancient,
                            Ability = ability,
                            EffectName = "particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf",
                            bDodgable = false,
                            iMoveSpeed = 2000,
                        }
                        ProjectileManager:CreateTrackingProjectile(projectile1)
                        local projectile2 = {
                            Target = enemy_baracks[barackid2],
                            Source = _G.playersinfo[id].ancient,
                            Ability = ability,
                            EffectName = "particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf",
                            bDodgable = false,
                            iMoveSpeed = 2000,
                        }
                        ProjectileManager:CreateTrackingProjectile(projectile2)
                        local projectile3 = {
                            Target = enemy_baracks[barackid3],
                            Source = _G.playersinfo[id].ancient,
                            Ability = ability,
                            EffectName = "particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf",
                            bDodgable = false,
                            iMoveSpeed = 2000,
                        }
                        ProjectileManager:CreateTrackingProjectile(projectile3)
                    else
                        for _, barack in pairs(enemy_baracks) do
                            local projectile = {
                                Target = barack,
                                Source = _G.playersinfo[id].ancient,
                                Ability = ability,
                                EffectName = "particles/units/heroes/hero_rattletrap/rattletrap_rocket_flare.vpcf",
                                bDodgable = false,
                                iMoveSpeed = 2000,
                            }
                            ProjectileManager:CreateTrackingProjectile(projectile)
                        end
                    end
                end
            end
        },
        --damage_5
        {
            name = "name_creep_damage_gift_5",
            description = "description_creep_damage_gift_5",
            image = "file://{images}/frostivus/gifts/creep_damage.png",
            GiveGift = function(self, id)
                if _G.playersinfo[id].ancient then
                    _G.playersinfo[id].ancient:AddNewModifier(_G.playersinfo[id].ancient, nil, "modifier_frostivus_creep_damage_gift_5", {duration = 200})
                    local targets = FindUnitsInRadius(PlayerResource:GetTeam(id), Vector(0,0,0), nil, 999999, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_ANY_ORDER, false)
                    for _, target in pairs(targets) do
                    	target:Heal(target:GetMaxHealth(), nil)
                    end
                end
            end
        },
        --regen_5
        {
            name = "name_buildings_regen_gift_5",
            description = "description_buildings_regen_gift_5",
            image = "file://{images}/frostivus/gifts/buildings_regen.png",
            GiveGift = function(self, id)
                if _G.playersinfo[id].ancient then
                    _G.playersinfo[id].ancient:AddNewModifier(_G.playersinfo[id].ancient, nil, "modifier_frostivus_buildings_regen_5_buff", {duration = 300})
                end
                for k, v in pairs(_G.playersinfo[id].baracks) do
                    v:AddNewModifier(v, nil, "modifier_frostivus_buildings_regen_5_buff", {duration = 300})
                end
                for k, v in pairs(_G.playersinfo[id].towers) do
                    v:AddNewModifier(v, nil, "modifier_frostivus_buildings_regen_5_buff", {duration = 300})
                end
            end
        },
        --mana_5
        {
            name = "name_ancient_mana_gift_5",
            description = "description_ancient_mana_gift_5",
            image = "file://{images}/frostivus/gifts/ancient_mana.png",
            GiveGift = function(self, id)
                if _G.playersinfo[id].ancient then
                    _G.playersinfo[id].ancient:GiveMana(70)
                end
            end
        },
        --hero_5
        {
            name = "name_hero_copy_gift",
            description = "description_hero_copy_gift",
            image = "file://{images}/frostivus/gifts/hero_copy.png",
            GiveGift = function(self, id)
                local alive_baracks = {}
                for _, alive_barack in pairs(_G.playersinfo[id].baracks) do
                    table.insert( alive_baracks, alive_barack )
                end
                if #alive_baracks > 0 then
                    local barack = alive_baracks[RandomInt(1, #alive_baracks)]

                    local heroes = {}
                    for unit_name, data in pairs(_G.playersinfo[id].unitsinfo) do
                        if data ~= nil and data.hero_xp ~= nil and not string.match(unit_name, "pusher") then
                            table.insert(heroes , unit_name )
                        end
                    end
                    if #heroes > 0 then
                        local hero_name = heroes[RandomInt(1, #heroes)]

                        local illusion = CreateUnitByName(hero_name, barack.herospawnpoint, true, barack:GetOwner(), barack:GetOwner(), barack:GetTeamNumber())
                        
                        illusion:AddNewModifier(illusion, nil, "modifier_illusion", { duration = 120, outgoing_damage = 60, incoming_damage = 250 })
                        illusion:MakeIllusion()
                        function illusion:IsTempestDouble()
                            return true
                        end

                        if _G.playersinfo[id].unitsinfo[hero_name].inventory ~= nil then
                            for _, item_name in pairs(_G.playersinfo[id].unitsinfo[hero_name].inventory) do
                                illusion:AddItemByName(item_name)
                            end
                        end
                        
                        local hero_xp = _G.playersinfo[id].unitsinfo[hero_name].hero_xp
                        local needxp = 100
                        local lvlup = 0
                        while hero_xp > needxp do
                            lvlup = lvlup + 1
                            hero_xp = hero_xp - needxp
                            needxp = 100 + 100 * lvlup
                        end
                        
                        Timers:CreateTimer(0, function()
                            illusion:CreatureLevelUp(lvlup)
                            if illusion.mana then
                                illusion.mana = illusion.mana + _G.playersinfo[id].unitsinfo[hero_name].manapl * lvlup
                            else
                                illusion.mana = _G.playersinfo[id].unitsinfo[hero_name].manapl * lvlup
                            end
                            local level = illusion:GetLevel()
                            local ability1 = illusion:GetAbilityByIndex(0)
                            if ability1 then
                                ability1:SetLevel(math.min(math.floor((level+3)/4),4))
                            end
                            local ability2 = illusion:GetAbilityByIndex(1)
                            if ability2 then
                                ability2:SetLevel(math.min(math.floor((level+2)/4),4))
                            end
                            local ability3 = illusion:GetAbilityByIndex(2)
                            if ability3 then
                                ability3:SetLevel(math.min(math.floor((level+1)/4),4))
                            end
                            local ability4 = illusion:GetAbilityByIndex(3)
                            if ability4 then
                                ability4:SetLevel(math.min(math.floor((level)/4),4))
                            end
                            
                            -- if caster.mid_barrack and not _G.duos then
                            --     hero:SetMinimumGoldBounty(hero:GetMinimumGoldBounty()*0.67)
                            --     hero:SetMaximumGoldBounty(hero:GetMaximumGoldBounty()*0.67)
                            -- end
                        end)
                    end
                end
            end
        },
        --double_5
        {
            name = "name_double_spawn_gift",
            description = "description_double_spawn_gift",
            image = "file://{images}/frostivus/gifts/double_spawn.png",
            GiveGift = function(self, id)
                for k, barack in pairs(_G.playersinfo[id].all_baracks) do
                    barack.double_spawn = true
                end
                if _G.playersinfo[id].ancient then
                    _G.playersinfo[id].ancient:AddNewModifier(_G.playersinfo[id].ancient, nil, "modifier_frostivus_double_spawn_creep_armor_gift", {duration = 200})
                end
            end
        }
    }
}

frostivus.player_gifts = {}

function frostivus:OnPlayerSpawnCreep(data)
	-- print("OnPlayerSpawnCreep")
    -- DeepPrintTable(keys)
    local id = data.id
    local item = data.item
    local ancient = _G.playersinfo[id].ancient
    if _G.playersinfo[id].race == 12 and ancient and not ancient:IsNull() then
        local race_abil = ancient:FindAbilityByName("frostivus_race_bonus")
        if not race_abil:IsCooldownReady() then return end
        local stacks = ancient:GetModifierStackCount("modifier_frostivus_race_bonus", ancient) + item:GetGoldCost(item:GetLevel()-1)

        if not race_abil.gift_tier then
            race_abil.gift_tier = 1
        end

        local gold_for_tier = {
            300,
            400,
            500,
            600,
            700
        }
        if _G.playersinfo[id].spec.specpass and _G.playersinfo[id].spec.specpass:GetAbilityName() == "frostivus_spec_t1t2_pass" then
            gold_for_tier = {
                150,
                200,
                250,
                300,
                350
            }
        end

        if stacks >= gold_for_tier[race_abil.gift_tier]  then
            stacks = stacks - gold_for_tier[race_abil.gift_tier]
            -- local gifts_count = #frostivus.gifts[race_abil.gift_tier]
            -- local giftid1 = RandomInt(1, gifts_count)
            -- local giftid2 = RandomInt(1, gifts_count-1)
            -- if giftid1 == giftid2 then
            --     giftid2 = giftid2 + 1
            -- end
            -- if _G.playersinfo[id].spec.specpass and _G.playersinfo[id].spec.specpass:GetAbilityName() == "frostivus_spec_t1t2_pass" then
            --     local giftid3 = RandomInt(1, gifts_count-2)
            --     if giftid3 == giftid1 then
            --     	giftid3 = giftid3 + 1
            --         if giftid3 == giftid2 then
            --             giftid3 = giftid3 + 1
            --         end
            --     elseif giftid3 == giftid2 then
            --     	giftid3 = giftid3 + 1
            --         if giftid3 == giftid1 then
            --             giftid3 = giftid3 + 1
            --         end
            --     end
            --     frostivus:GiveGift(id, frostivus.gifts[race_abil.gift_tier][giftid3], true)
            -- end

            -- frostivus:GiveGift(id, frostivus.gifts[race_abil.gift_tier][giftid1], true)
            -- frostivus:GiveGift(id, frostivus.gifts[race_abil.gift_tier][giftid2], true)

            local level = race_abil.gift_tier
            local gifts_count = #frostivus.gifts[level]
            local gifts = {}
            for i=1, gifts_count do
                gifts[i] = i
            end
            local id1 = RandomInt(1, gifts_count)
            local giftid1 = gifts[id1]
            for i = id1, gifts_count - 1 do
                gifts[i] = gifts[i+1]
            end
            local id2 = RandomInt(1, gifts_count-1)
            local giftid2 = gifts[id2]
            -- if giftid1 == giftid2 then
            --     giftid2 = giftid2 + 1
            -- end
            for i = id2, gifts_count - 2 do
                gifts[i] = gifts[i+1]
            end
            local id3 = RandomInt(1, gifts_count-2)
            local giftid3 = gifts[id3]
            -- if giftid1 == giftid3 or giftid2 == giftid3 then
            --     giftid3 = giftid3 + 1
            --     if giftid1 == giftid3 or giftid2 == giftid3 then
            --         giftid3 = giftid3 + 1
            --     end
            -- end  

            -- if _G.playersinfo[id].spec.specpass and _G.playersinfo[id].spec.specpass:GetAbilityName() == "frostivus_spec_t1t2_pass" then
            --     local giftid4 = RandomInt(1, gifts_count-2)
            --     local gift_min_1 = giftid1
            --     if gift_min_1 < giftid2 then gift_min_1 = giftid2 end
            --     if gift_min_1 < giftid3 then gift_min_1 = giftid3 end
            --     local gift_min_2
            --     local gift_min_3
            --     if giftid4 == giftid1 then
            --     	giftid4 = giftid4 + 1
            --         if giftid4 == giftid2 then
            --             giftid4 = giftid4 + 1
            --         end
            --     elseif giftid4 == giftid2 then
            --     	giftid4 = giftid4 + 1
            --         if giftid4 == giftid1 then
            --             giftid4 = giftid4 + 1
            --         end
            --     end
            --     frostivus:GiveGift(id, frostivus.gifts[race_abil.gift_tier][giftid3], true)
            -- end

            if frostivus.player_gifts[id] then
                frostivus:GiveGift(id, frostivus.player_gifts[id][RandomInt(1, #frostivus.player_gifts[id])], true)
            end

            local player_gifts = {frostivus.gifts[level][giftid1],frostivus.gifts[level][giftid2],frostivus.gifts[level][giftid3]}
            frostivus.player_gifts[id] = player_gifts
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "CloseSelectGift", {})
            CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "OpenSelectGift", player_gifts)

            race_abil:SetLevel(race_abil.gift_tier)
            race_abil:StartCooldown(race_abil:GetEffectiveCooldown(race_abil.gift_tier-1))
            race_abil.gift_tier = race_abil.gift_tier + 1
            if race_abil.gift_tier > #frostivus.gifts then
                race_abil.gift_tier = #frostivus.gifts
            end
        end

        ancient:SetModifierStackCount("modifier_frostivus_race_bonus", ancient, stacks)
    end
end

function frostivus:GiveGift(id, gift, aura)
    if id and _G.playersinfo[id].alive then
        local gameEvent = {}
        gameEvent["player_id"] = id
        gameEvent["teamnumber"] = -1
        gameEvent["locstring_value"] = gift.name
        gameEvent["message"] = "#Combat_Message_get_gift"
        FireGameEvent( "dota_combat_event_message", gameEvent )

        gift:GiveGift(id)

        --if aura and _G.playersinfo[id].aura == "frostivus_ancient_builds_regen_and_gifts" and RandomInt(1, 100) <= 27 then
        --    local race_abil = _G.playersinfo[id].ancient:FindAbilityByName("frostivus_race_bonus")
        --    frostivus:GiveGift(id, frostivus.gifts[race_abil.gift_tier][1], false)
        --end
    end
end

function frostivus:GetGift(tier, giftid)
	local cmdPlayer = Convars:GetCommandClient()
	if cmdPlayer and _G.SCD_IsDevPlayer(cmdPlayer) then
        if tier and giftid then
            -- GetCommandClient() в этой сборке возвращает объект без метода
            -- GetPlayerID, поэтому PlayerID берём через общий резолвер (commands.lua)
            frostivus:GiveGift((_G.SCD_ResolveCallerID(cmdPlayer)), frostivus.gifts[tonumber(tier)][tonumber(giftid)], false)
		end
	end
end

--FOR EVENT

-- function frostivus:StartGame()
--    local level = 1
--    Timers:CreateTimer(540, function()
--        for id, data in pairs(_G.playersinfo) do
--            if data.alive then
--                local gifts_count = #frostivus.gifts[level]
--                local giftid1 = RandomInt(1, gifts_count)
--                local giftid2 = RandomInt(1, gifts_count-1)
--                if giftid1 == giftid2 then
--                    giftid2 = giftid2 + 1
--                end
--                local giftid3 = RandomInt(1, gifts_count-2)
--                if giftid1 == giftid3 or giftid2 == giftid3 then
--                    giftid3 = giftid3 + 1
--                    if giftid1 == giftid3 or giftid2 == giftid3 then
--                        giftid3 = giftid3 + 1
--                    end
--                end

--                if frostivus.player_gifts[id] then
--                    frostivus:GiveGift(id, frostivus.player_gifts[id][RandomInt(1, #frostivus.player_gifts[id])], true)
--                end

--                local player_gifts = {frostivus.gifts[level][giftid1],frostivus.gifts[level][giftid2],frostivus.gifts[level][giftid3]}
--                frostivus.player_gifts[id] = player_gifts
--                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "CloseSelectGift", {})
--                CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "OpenSelectGift", player_gifts)
--            end
--        end
--        level = level + 1
--        if level > #frostivus.gifts then
--            level = #frostivus.gifts
--        end
--        return 540
--    end)
-- end

function frostivus:SelectGift(data)
    local id = data.PlayerID
    if not id or not _G.playersinfo[id].alive or not data.gift then return end
    if frostivus.player_gifts[id] then
        frostivus:GiveGift(id, frostivus.player_gifts[id][data.gift], true)
        frostivus.player_gifts[id] = nil
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(id), "CloseSelectGift", {})
    end
end

function frostivus:Init()
	CustomGameEventManager:RegisterListener("SelectGift", Dynamic_Wrap(frostivus, 'SelectGift'))
	Convars:RegisterCommand( "get_gift", Dynamic_Wrap(frostivus, 'GetGift'), "A console command example", 0 )
    --table.insert( _G.onstartgame, frostivus )
end

frostivus:Init()
return frostivus