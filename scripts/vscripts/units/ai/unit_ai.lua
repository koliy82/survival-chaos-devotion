function Spawn(keys)
	if not IsServer() then
		return
  end
  
  if _G.polygon then
    thisEntity:SetControllableByPlayer(0, true)
    return
  end

	if thisEntity == nil then
		return
  end

  local getAbilsTimer = function()
    local getAbils = function(entity)
      if thisEntity:IsIllusion() and not thisEntity:IsTempestDouble() then
        function entity:UnitAbilitiesAI()
          return
        end
        return
      end

      local name = thisEntity:GetUnitName()
    
      local id = thisEntity:GetPlayerOwnerID()
      thisEntity.ai_items = false
      if id ~= nil then
        thisEntity.ai_items = thisEntity:IsCustomHero() and _G.playersinfo[id].spec.items_spec and _G.playersinfo[id].spec.items_spec[name]
      end
      if thisEntity.ai_items then
        function entity:useItems()
          local mystic_staff = thisEntity:FindItemInInventory("item_spec_mystic_staff")
          if mystic_staff and mystic_staff:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityNoTarget(mystic_staff, thisEntity:entindex())
              return 0.2
            end
          end
          local meteor_hammer = thisEntity:FindItemInInventory("item_spec_meteor_hammer")
          if meteor_hammer and meteor_hammer:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 3 then
              thisEntity:CastAbilityNoTarget(meteor_hammer, thisEntity:entindex())
              return 0.2
            end
          end
          local scythe_of_vyse = thisEntity:FindItemInInventory("item_spec_scythe_of_vyse")
          if scythe_of_vyse and scythe_of_vyse:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 4 then
              thisEntity:CastAbilityNoTarget(scythe_of_vyse, thisEntity:entindex())
              return 0.2
            end
          end
          local book1 = thisEntity:FindItemInInventory("item_spec_tome_of_knowledge")
          if book1 and book1:IsFullyCastable() then
            thisEntity:CastAbilityNoTarget(book1, thisEntity:entindex())
            return 0.2
          end
          local book2 = thisEntity:FindItemInInventory("item_spec_necronomicon")
          if book2 and book2:IsFullyCastable() then
            thisEntity:CastAbilityNoTarget(book2, thisEntity:entindex())
            return 0.2
          end
          local book3 = thisEntity:FindItemInInventory("item_spec_book_of_the_dead")
          if book3 and book3:IsFullyCastable() then
            thisEntity:CastAbilityNoTarget(book3, thisEntity:entindex())
            return 0.2
          end
          local faerie_fire = thisEntity:FindItemInInventory("item_spec_faerie_fire")
          if faerie_fire and faerie_fire:IsFullyCastable() then
            if thisEntity:GetHealthPercent() < 40 then
              thisEntity:CastAbilityNoTarget(faerie_fire, thisEntity:entindex())
              return 0.2
            end
          end
          local enchanted_mango = thisEntity:FindItemInInventory("item_spec_enchanted_mango")
          if enchanted_mango and enchanted_mango:IsFullyCastable() then
            if thisEntity:GetManaPercent() < 40 then
              thisEntity:CastAbilityNoTarget(enchanted_mango, thisEntity:entindex())
              return 0.2
            end
          end
          local blast_rig = thisEntity:FindItemInInventory("item_spec_blast_rig")
          if blast_rig and blast_rig:IsFullyCastable() then
            if thisEntity:GetHealthPercent() < 50 then
              thisEntity:CastAbilityNoTarget(blast_rig, thisEntity:entindex())
              return 0.2
            end
          end
        end
      end
    
      if name == "npc_dota_treants_hero_tank" then
        function entity:UnitAbilitiesAI()
          local agr_ability = thisEntity:FindAbilityByName("treants_hero_tank_berserkers_call")
          if agr_ability and agr_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(agr_ability, thisEntity:entindex())
              return 1
            end
          end
        end
      
      elseif name == "npc_dota_treants_hero_asassin" then
        function entity:UnitAbilitiesAI()
          local ability2 = thisEntity:FindAbilityByName("treants_furion_wrath_of_nature")
          if ability2 and ability2:IsFullyCastable() then
              thisEntity:CastAbilityOnPosition(thisEntity:GetOrigin(), ability2, thisEntity:entindex())
              return 1
          end
        end
    
      elseif name == "npc_dota_treants_hero_pusher" then
        function entity:UnitAbilitiesAI()
          local tree_ability = thisEntity:FindAbilityByName("treants_hero_pusher_avalanche")
          if tree_ability and tree_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetOrigin(), tree_ability, thisEntity:entindex())
              return 1
            end
          end
          local toss_ability = thisEntity:FindAbilityByName("treants_hero_pusher_toss")
          if toss_ability and toss_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 275, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], toss_ability, thisEntity:entindex())
              return 1
            end
          end
        end
      
      elseif name == "npc_dota_treants_hero_mage" then
        function entity:UnitAbilitiesAI()
          local ents_ability = thisEntity:FindAbilityByName("treants_hero_mage_summon_ents")
          if ents_ability and ents_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ents_ability, thisEntity:entindex())
              return 0.7
            end
          end
          local seed_ability = thisEntity:FindAbilityByName("treants_hero_mage_seed")
          if seed_ability and seed_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], seed_ability, thisEntity:entindex())
              return 0.7
            end
          end
          local arc_ability = thisEntity:FindAbilityByName("treants_hero_mage_nature_arc")
          if arc_ability and arc_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], arc_ability, thisEntity:entindex())
              return 0.7
            end
          end
        end
      
      elseif name == "npc_dota_treants_hero_mage_spec" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("treants_hero_mage_spec_thorn_bush")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 1
            end
          end
          local ability2 = thisEntity:FindAbilityByName("treants_hero_mage_spec_forest_curse")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability2, thisEntity:entindex())
              return 1
            end
          end
          local ability3 = thisEntity:FindAbilityByName("treants_hero_mage_spec_gust")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetOrigin(), ability3, thisEntity:entindex())
              return 1
            end
          end
          local ability4 = thisEntity:FindAbilityByName("treants_hero_mage_spec_bedlam")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              for i=1, #targets do
                if targets[i]:IsCustomHero() then
                  thisEntity:CastAbilityOnPosition(targets[i]:GetOrigin(), ability4, thisEntity:entindex())
                  return 1
                end
              end 
              thisEntity:CastAbilityOnPosition(targets[1]:GetOrigin(), ability4, thisEntity:entindex())
              return 1
            end
          end
        end
      
      elseif name == "npc_dota_treants_mage" then
        function entity:UnitAbilitiesAI()
          local armor_ability = thisEntity:FindAbilityByName("treants_creeps_mage_magic_armor")
          if armor_ability and armor_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:GetMaxHealth() - 150 > targets[i]:GetHealth() then
                thisEntity:CastAbilityOnTarget(targets[i], armor_ability, thisEntity:entindex())
                return 0.4
              end
            end
          end
          local ability2 = thisEntity:FindAbilityByName("treants_creeps_mage_spec_skill")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability2, thisEntity:entindex())
              return 0.6
            end
          end
          local ability3 = thisEntity:FindAbilityByName("treants_creeps_mage_bonds")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              for i=1, #targets do
                if targets[i]:GetHealth() < targets[i]:GetMaxHealth() - 150 and not targets[i]:HasModifier("modifier_treants_creeps_mage_bonds_buff") then
                  thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
                  return 0.4
                end
              end
            end
          end
        end

      elseif name == "npc_dota_treants_air" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("treants_creeps_spec_shackles")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:HasFlyMovementCapability() then
                thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
                return 0.7
              end
            end
          end
        end
      
      elseif name == "npc_dota_undead_mage" or name == "npc_dota_undead_mage_spec" then
        function entity:UnitAbilitiesAI()
          local blast_ability = thisEntity:FindAbilityByName("undead_creeps_mage_nether_blast")
          if blast_ability and blast_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 450, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), blast_ability, thisEntity:entindex())
              return 1
            end
          end
          local lifesteal_ability = thisEntity:FindAbilityByName("undead_creeps_mage_lifesteal")
          if lifesteal_ability and lifesteal_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:GetHealth() < targets[i]:GetMaxHealth() - 150 then
                thisEntity:CastAbilityOnTarget(targets[i], lifesteal_ability, thisEntity:entindex())
                return 0.4
              end
            end
          end
          local armor_ability = thisEntity:FindAbilityByName("undead_creeps_mage_cooldown_pass")
          if armor_ability and armor_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_FARTHEST, false)
            local enemy_targets = FindUnitsInRadius(team, position, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags - DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false)
            if #enemy_targets > 0 then
              for i=1, #targets do
                if targets[i]:GetMaxHealth() > targets[i]:GetHealth() then
                  thisEntity:CastAbilityOnTarget(targets[i], armor_ability, thisEntity:entindex())
                  return 0.4
                end
              end
            end
          end
          local ability3 = thisEntity:FindAbilityByName("undead_creeps_mage_summon")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets =  FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.6
            end
          end
        end
      
      elseif name == "npc_dota_undead_air_spec" or name == "npc_dota_undead_air" then
        function entity:UnitAbilitiesAI()
          local purge_ability = thisEntity:FindAbilityByName("undead_creeps_air_purge")
          if purge_ability and purge_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              for i,v in ipairs(targets) do
                local mods = v:FindAllModifiers()
                for j,d in ipairs(mods) do
                  if not d:IsDebuff() and d:GetDuration() > 1 then
                    thisEntity:CastAbilityOnPosition(v:GetAbsOrigin(), purge_ability, thisEntity:entindex())
                    return 0.4
                  end
                end
              end
            end
          end
          local ability2 = thisEntity:FindAbilityByName("undead_creeps_air_frost")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability2, thisEntity:entindex())
              return 0.3
            end
          end
        end
      
      elseif name == "npc_dota_undead_siege" then
        function entity:UnitAbilitiesAI()
          local rot_ability = thisEntity:FindAbilityByName("undead_creeps_siege_rot")
          if rot_ability and rot_ability:IsActivated() and rot_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), rot_ability, thisEntity:entindex())
              return 1
            end
          end
        end
      
      elseif name == "npc_dota_undead_hero_tank" then
        function entity:UnitAbilitiesAI()
          local skeletons_ability = thisEntity:FindAbilityByName("undead_hero_tank_summon_skeleton")
          if skeletons_ability and skeletons_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(skeletons_ability, thisEntity:entindex())
              return 0.7
            end
          end
          local lifesteal_ability = thisEntity:FindAbilityByName("undead_hero_tank_lifesteal_aura")
          if lifesteal_ability and lifesteal_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets =  FindUnitsInRadius(team, position, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(lifesteal_ability, thisEntity:entindex())
              return 0.6
            end
          end
        end
      
      elseif name == "npc_dota_undead_hero_mage" then
        function entity:UnitAbilitiesAI()
          local chain_ability = thisEntity:FindAbilityByName("undead_hero_mage_chain_frost")
          if chain_ability and chain_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnTarget(targets[1], chain_ability, thisEntity:entindex())
              return 1
            end
          end
          local armor_ability = thisEntity:FindAbilityByName("undead_hero_mage_frost_armor")
          if armor_ability and armor_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_FARTHEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], armor_ability, thisEntity:entindex())
              return 1
            end
          end
          local vortex_ability = thisEntity:FindAbilityByName("undead_hero_mage_ice_vortex")
          if vortex_ability and vortex_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), vortex_ability, thisEntity:entindex())
              return 1
            end
          end
        end
      
      elseif name == "npc_dota_undead_hero_mage_spec" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("undead_hero_mage_spec_swarm")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnTarget(targets[1], ability1, thisEntity:entindex())
              return 0.8
            end
          end
          local ability2 = thisEntity:FindAbilityByName("undead_hero_mage_spec_pulse")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.2
            end
          end
          local ability3 = thisEntity:FindAbilityByName("undead_hero_mage_spec_decay")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability3, thisEntity:entindex())
              return 0.8
            end
          end
        end
      
      elseif name == "npc_dota_undead_hero_asassin" then
        function entity:UnitAbilitiesAI()
          local eat_ability = thisEntity:FindAbilityByName("undead_hero_asassin_eat")
          if eat_ability and eat_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local entargets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #entargets > 0 then
              local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
              local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
              for i=1, #targets do
                if targets[i] ~= thisEntity and not targets[i]:IsCustomHero() and targets[i]:GetLevel() < 3 then
                  thisEntity:CastAbilityOnTarget(targets[i], eat_ability, thisEntity:entindex())
                  return 0.7
                end
              end
            end
          end
        end
      
      elseif name == "npc_dota_undead_hero_pusher" then
        function entity:UnitAbilitiesAI()
          local eat_ability = thisEntity:FindAbilityByName("undead_hero_pusher_eat")
          if eat_ability and eat_ability:IsFullyCastable() and thisEntity:GetMaxHealth() > thisEntity:GetHealth() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i] ~= thisEntity and not targets[i]:IsCustomHero() and targets[i]:GetLevel() < 3 then
                thisEntity:CastAbilityOnTarget(targets[i], eat_ability, thisEntity:entindex())
                return 0.7
              end
            end
          end
          local aoe_ability = thisEntity:FindAbilityByName("undead_hero_pusher_aoe_damage")
          if aoe_ability and aoe_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets =  FindUnitsInRadius(team, position, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(aoe_ability, thisEntity:entindex())
              return 1
            end
          end
          local tombstone_ability = thisEntity:FindAbilityByName("undead_hero_pusher_tombstone")
          if tombstone_ability and tombstone_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets =  FindUnitsInRadius(team, position, nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(tombstone_ability, thisEntity:entindex())
              return 1
            end
          end
        end
      
      elseif name == "npc_dota_humans_mage" or name == "npc_dota_humans_mage_spec" then
        function entity:UnitAbilitiesAI()
          local respawn_ability = thisEntity:FindAbilityByName("humans_creeps_mage_reincarnation")
          if respawn_ability and respawn_ability:IsFullyCastable() and respawn_ability:IsActivated() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets =  FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(respawn_ability, thisEntity:entindex())
              return 0.8
            end
          end
          local heal_ability = thisEntity:FindAbilityByName("humans_creeps_mage_heal")
          if heal_ability and heal_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 675, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:GetHealth() < targets[i]:GetMaxHealth() - 150 then
                thisEntity:CastAbilityOnTarget(targets[i], heal_ability, thisEntity:entindex())
                return 1
              end
            end
          end
          local blizzard_ability = thisEntity:FindAbilityByName("humans_creeps_mage_blizzard")
          if blizzard_ability and blizzard_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), blizzard_ability, thisEntity:entindex())
              return 1
            end
          end
          local shield_ability = thisEntity:FindAbilityByName("humans_creeps_mage_shield")
          if shield_ability and shield_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_FARTHEST, false)
              for i=1, #targets do
                if targets[i]:GetMaxHealth() > targets[i]:GetHealth() then
                  thisEntity:CastAbilityOnTarget(targets[i], shield_ability, thisEntity:entindex())
                  return 1
                end
              end
            end
          end
        end
      
      elseif name == "npc_dota_humans_hero_tank" then
        function entity:UnitAbilitiesAI()
          local respawn_ability = thisEntity:FindAbilityByName("humans_hero_tank_reincarnation")
          if respawn_ability and respawn_ability:IsFullyCastable() and respawn_ability:IsActivated() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets =  FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(respawn_ability, thisEntity:entindex())
              return 0.8
            end
          end
          local stomp_ability = thisEntity:FindAbilityByName("humans_hero_tank_stomp")
          if stomp_ability and stomp_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(stomp_ability, thisEntity:entindex())
              return 0.8
            end
          end
          local heal_ability = thisEntity:FindAbilityByName("humans_hero_tank_heal")
          if heal_ability and heal_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:GetMaxHealth() > targets[i]:GetHealth() then
                thisEntity:CastAbilityOnTarget(thisEntity, heal_ability, thisEntity:entindex())
                return 1
              end
            end
          end
        end
      
      elseif name == "npc_dota_humans_hero_mage" then
        function entity:UnitAbilitiesAI()
          local fire_ability = thisEntity:FindAbilityByName("humans_hero_mage_fire_strike")
          if fire_ability and fire_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(fire_ability, thisEntity:entindex())
              return 0.8
            end
          end
          local illuminate_ability = thisEntity:FindAbilityByName("humans_hero_mage_illuminate")
          if illuminate_ability and illuminate_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), illuminate_ability, thisEntity:entindex())
              return illuminate_ability:GetLevel()+1
            end
          end
          local blizz_ability = thisEntity:FindAbilityByName("humans_hero_mage_blizzard")
          if blizz_ability and blizz_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 2 then
              thisEntity:CastAbilityNoTarget(blizz_ability, thisEntity:entindex())
              return 2.8
            end
          end
        end
      
      elseif name == "npc_dota_humans_hero_asassin" then
        function entity:UnitAbilitiesAI()
          ability1 = thisEntity:FindAbilityByName("humans_hero_asassin_dagger")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability1, thisEntity:entindex())
              return 1
            end
          end
        end
    
      -- elseif name == "npc_dota_humans_hero_asassin_spec" then
      --   function entity:UnitAbilitiesAI()
      --     local ability2 = thisEntity:FindAbilityByName("humans_hero_asassin_spec_multishot")
      --     if ability2 and ability2:IsFullyCastable() then
      --       local team = thisEntity:GetTeamNumber()
      --       local position = thisEntity:GetAbsOrigin()
      --       local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
      --       local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
      --       local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
      --       if #targets > 1 then
      --         thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability2, thisEntity:entindex())
      --         return 2
      --       end
      --     end
      --   end
    
      elseif name == "npc_dota_humans_hero_pusher" then
        function entity:UnitAbilitiesAI()
          local arrows_ability = thisEntity:FindAbilityByName("humans_hero_pusher_arrows")
          if arrows_ability and arrows_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), arrows_ability, thisEntity:entindex())
              return 0.6
            end
          end
          local armor_ability = thisEntity:FindAbilityByName("humans_hero_pusher_armor_buff")
          if armor_ability and armor_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(armor_ability, thisEntity:entindex())
              return 0.8
            end
          end
        end
      elseif name == "npc_dota_humans_air" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("humans_creeps_air_antiair")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:HasFlyMovementCapability() then
                thisEntity:CastAbilityOnTarget(targets[i], ability1, thisEntity:entindex())
                return 0.6
              end
            end
          end
          local ability2 = thisEntity:FindAbilityByName("humans_creeps_air_salo_obet")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:GetHealth() < targets[i]:GetMaxHealth() - 150 then
                thisEntity:CastAbilityOnTarget(targets[i], ability2, thisEntity:entindex())
                return 0.4
              end
            end
          end
          local ability3 = thisEntity:FindAbilityByName("humans_creeps_air_heal")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 520, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              if thisEntity:HasFlyMovementCapability() then
                thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
                return 0.3
              end
            end
          end
        end
      
      elseif name == "npc_dota_orcs_melee" then
        function entity:UnitAbilitiesAI()
          local heal_ability = thisEntity:FindAbilityByName("orcs_creeps_spec_self_heal")
          if heal_ability and heal_ability:IsFullyCastable() then
            if thisEntity:GetHealth() < thisEntity:GetMaxHealth() then
              thisEntity:CastAbilityNoTarget(heal_ability, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_orcs_mage" then
        function entity:UnitAbilitiesAI()
          local shield_ability = thisEntity:FindAbilityByName("orcs_creeps_mage_lightnings_shield")
          if shield_ability and shield_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            -- local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              local targetsF = FindUnitsInRadius(team, targets[1]:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_CLOSEST, false)
              -- local targetsF = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_FARTHEST, false)
              if #targetsF > 0 then
                local mod = targetsF[1]:FindModifierByName("modifier_orcs_creeps_mage_lightnings_shield")
                if not mod then
                  thisEntity:CastAbilityOnTarget(targetsF[1], shield_ability, thisEntity:entindex())
                  return 0.4
                end
              end
            end
          end
          local bolt_ability = thisEntity:FindAbilityByName("orcs_creeps_mage_bolt")
          if bolt_ability and bolt_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], bolt_ability, thisEntity:entindex())
              return 1
            end
          end
          local shake_ability = thisEntity:FindAbilityByName("orcs_creeps_mage_shake")
          if shake_ability and shake_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], shake_ability, thisEntity:entindex())
              return 2.7
            end
          end
          local ward_ability = thisEntity:FindAbilityByName("orcs_creeps_mage_healing_ward")
          if ward_ability and ward_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_FARTHEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(position + (position - targets[1]:GetAbsOrigin())/4, ward_ability, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_orcs_air" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("orcs_creeps_air_net")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 1100, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:HasFlyMovementCapability() then
                thisEntity:CastAbilityOnTarget(targets[i], ability1, thisEntity:entindex())
                return 0.3
              end
            end
          end
          local napalm_ability = thisEntity:FindAbilityByName("orcs_creeps_air_stickynapalm")
          if napalm_ability and napalm_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), napalm_ability, thisEntity:entindex())
              return 1
            end
          end
          local ability = thisEntity:FindAbilityByName("orcs_creeps_air_molotoff")
          if ability and ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability, thisEntity:entindex())
              return 0.5
            end
          end
        end
      
      elseif name == "npc_dota_orcs_wolf" then
        function entity:UnitAbilitiesAI()
          local buff_ability = thisEntity:FindAbilityByName("orcs_creeps_wolf_feral_roar")
          if buff_ability and buff_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(buff_ability, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_orcs_hero_tank" then
        function entity:UnitAbilitiesAI()
          local cleave_ability = thisEntity:FindAbilityByName("orcs_hero_tank_cleave")
          if cleave_ability and cleave_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(cleave_ability, thisEntity:entindex())
              return 0.8
            end
          end
          local agr_ability = thisEntity:FindAbilityByName("orcs_hero_tank_berserkers_call")
          if agr_ability and agr_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(agr_ability, thisEntity:entindex())
              return 1
            end
          end
          local blade_ability = thisEntity:FindAbilityByName("orcs_hero_tank_culling_blade")
          if blade_ability and blade_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              local level = blade_ability:GetLevel()
              local kill_threshold = blade_ability:GetLevelSpecialValueFor( "kill_threshold" , level - 1  )
              if targets[i]:GetHealth() < kill_threshold then
                thisEntity:CastAbilityOnTarget(targets[i], blade_ability, thisEntity:entindex())
                return 1
              end
            end
          end
        end
      
      elseif name == "npc_dota_orcs_hero_tank_spec" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("orcs_hero_tank_spec_fakir")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.9
            end
          end
          local ability2 = thisEntity:FindAbilityByName("orcs_hero_tank_spec_fire_show")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability2, thisEntity:entindex())
              return 0.3
            end
          end
          local ability3 = thisEntity:FindAbilityByName("orcs_hero_tank_spec_midas")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.3
            end
          end
        end
      
      elseif name == "npc_dota_orcs_hero_mage" then
        function entity:UnitAbilitiesAI()
          local storm_ability = thisEntity:FindAbilityByName("orcs_hero_mage_static_storm")
          if storm_ability and storm_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), storm_ability, thisEntity:entindex())
              return 1
            end
          end
          local armor_ability = thisEntity:FindAbilityByName("orcs_hero_mage_static_buff")
          if armor_ability and armor_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(thisEntity, armor_ability, thisEntity:entindex())
              return 1
            end
          end
          local void_ability = thisEntity:FindAbilityByName("orcs_hero_mage_void")
          if void_ability and void_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), void_ability, thisEntity:entindex())
              return 1
            end
          end
        end
      
      elseif name == "npc_dota_orcs_hero_pusher" then
        function entity:UnitAbilitiesAI()
          local spray_ability = thisEntity:FindAbilityByName("orcs_hero_pusher_acid_spray")
          if spray_ability and spray_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), spray_ability, thisEntity:entindex())
              return 1
            end
          end
          local bomb_ability = thisEntity:FindAbilityByName("orcs_hero_pusher_bomb")
          if bomb_ability and bomb_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), bomb_ability, thisEntity:entindex())
              return 1
            end
          end
          local berserk_ability = thisEntity:FindAbilityByName("orcs_hero_pusher_rage")
          if berserk_ability and berserk_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets =  FindUnitsInRadius(team, position, nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(berserk_ability, thisEntity:entindex())
              return 0.8
            end
          end
        end
      
      elseif name == "npc_dota_dwarfs_hero_tank" then
        function entity:UnitAbilitiesAI()
          local chains_ability = thisEntity:FindAbilityByName("dwarfs_hero_tank_battery_assault")
          if chains_ability and chains_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(chains_ability, thisEntity:entindex())
              return 0.8
            end
          end
          local aoe_ability = thisEntity:FindAbilityByName("dwarfs_hero_tank_delayed_aoe")
          if aoe_ability and aoe_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 2 then
              thisEntity:CastAbilityNoTarget(aoe_ability, thisEntity:entindex())
              return 0.8
            end
          end
          aoe_ability = thisEntity:FindAbilityByName("dwarfs_hero_tank_plazmasphere")
          if aoe_ability and aoe_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(aoe_ability, thisEntity:entindex())
              return 0.8
            end
          end
        end
      
      elseif name == "npc_dota_dwarfs_hero_mage" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("dwarfs_hero_mage_march")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.9
            end
          end
          local ability2 = thisEntity:FindAbilityByName("dwarfs_hero_mage_laguna_blade")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability2, thisEntity:entindex())
              return 0.9
            end
          end
          local ability3 = thisEntity:FindAbilityByName("dwarfs_hero_mage_summon_clock")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets =  FindUnitsInRadius(team, position, nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.6
            end
          end
        end
      
      elseif name == "npc_dota_dwarfs_hero_mage_spec" then
        function entity:UnitAbilitiesAI()
          local barrage_ability = thisEntity:FindAbilityByName("dwarfs_hero_mage_spec_rocket_barrage")
          if barrage_ability and barrage_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(barrage_ability, thisEntity:entindex())
              return 0.4
            end
          end
          local missiles_ability = thisEntity:FindAbilityByName("dwarfs_hero_mage_spec_homing_missile")
          if missiles_ability and missiles_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 2 then
              thisEntity:CastAbilityNoTarget(missiles_ability, thisEntity:entindex())
              return 0.8
            end
          end
          local cannon_ability = thisEntity:FindAbilityByName("dwarfs_hero_mage_spec_flak_cannon")
          if cannon_ability and cannon_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(cannon_ability, thisEntity:entindex())
              return 0.4
            end
          end
          local call_down_ability = thisEntity:FindAbilityByName("dwarfs_hero_mage_spec_call_down")
          if call_down_ability and call_down_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), call_down_ability, thisEntity:entindex())
              return 1
            end
          end
        end
      
      elseif name == "npc_dota_dwarfs_hero_asassin" then
        function entity:UnitAbilitiesAI()
          local shotgun_ability = thisEntity:FindAbilityByName("dwarfs_hero_asassin_shotgun")
          if shotgun_ability and shotgun_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), shotgun_ability, thisEntity:entindex())
              return 1
            end
          end
        end
      
      elseif name == "npc_dota_dwarfs_hero_pusher" then
        function entity:UnitAbilitiesAI()
          local armor_up_ability = thisEntity:FindAbilityByName("dwarfs_hero_pusher_armor_up")
          if armor_up_ability and armor_up_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets =  FindUnitsInRadius(team, position, nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(armor_up_ability, thisEntity:entindex())
              return 0.7
            end
          end
          local shield_ability = thisEntity:FindAbilityByName("dwarfs_hero_pusher_shield")
          if shield_ability and shield_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets =  FindUnitsInRadius(team, position, nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(shield_ability, thisEntity:entindex())
              return 0.4
            end
          end
          local chakram_ability = thisEntity:FindAbilityByName("dwarfs_hero_pusher_chakram")
          if chakram_ability and chakram_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), chakram_ability, thisEntity:entindex())
              return 1
            end
          end
        end
      
      elseif name == "npc_dota_dwarfs_mage" then
        function entity:UnitAbilitiesAI()
          local laser_ability = thisEntity:FindAbilityByName("dwarfs_creeps_mage_laser")
          if laser_ability and laser_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], laser_ability, thisEntity:entindex())
              return 1
            end
          end
          local missile_ability = thisEntity:FindAbilityByName("dwarfs_creeps_mage_seeking_missile")
          if missile_ability and missile_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(missile_ability, thisEntity:entindex())
              return 0.7
            end
          end
          local gear_ability = thisEntity:FindAbilityByName("dwarfs_creeps_mage_spec_gear")
          if gear_ability and gear_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(gear_ability, thisEntity:entindex())
              return 0.7
            end
          end
        end
    
      elseif name == "npc_dota_dwarfs_timber" then
        function entity:UnitAbilitiesAI()
          local regen_ability = thisEntity:FindAbilityByName("dwarfs_creeps_timber_repair")
          if regen_ability and regen_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:GetMaxHealth() > targets[i]:GetHealth() then
                thisEntity:CastAbilityOnTarget(targets[i], regen_ability, thisEntity:entindex())
                return 0.4
              end
            end
          end
        end
      
      elseif name == "npc_dota_elves_hero_tank" then
        function entity:UnitAbilitiesAI()
          local summon_ability = thisEntity:FindAbilityByName("elves_hero_tank_summon_bear")
          if summon_ability and summon_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets =  FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(summon_ability, thisEntity:entindex())
              return 0.7
            end
          end
          local aura_ability = thisEntity:FindAbilityByName("elves_hero_tank_regen_aura")
          if aura_ability and aura_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            local newtargets = {}
            for i=1, #targets do
              if targets[i]:GetMaxHealth() > targets[i]:GetHealth() then
                table.insert(newtargets,targets[i])
              end
            end
            if #newtargets > 4 then
              thisEntity:CastAbilityNoTarget(aura_ability, thisEntity:entindex())
              return 0.7
            end
          end
        end
      
      elseif name == "npc_dota_elves_hero_mage" then
        function entity:UnitAbilitiesAI()
          local arcs_ability = thisEntity:FindAbilityByName("elves_hero_mage_arcs")
          if arcs_ability and arcs_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_FARTHEST, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnTarget(targets[1], arcs_ability, thisEntity:entindex())
              return 0.6
            end
          end
          local slave_ability = thisEntity:FindAbilityByName("elves_hero_mage_dragon_slave")
          if slave_ability and slave_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), slave_ability, thisEntity:entindex())
              return 0.8
            end
          end
          local summon_ability = thisEntity:FindAbilityByName("elves_hero_mage_summon_spirits")
          if summon_ability and summon_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets =  FindUnitsInRadius(team, position, nil, 750, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(summon_ability, thisEntity:entindex())
              return 0.5
            end
          end
        end
      
      elseif name == "npc_dota_elves_hero_asassin" then
        function entity:UnitAbilitiesAI()
          local refraction_ability = thisEntity:FindAbilityByName("elves_hero_asassin_refraction")
          if refraction_ability and refraction_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets =  FindUnitsInRadius(team, position, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(refraction_ability, thisEntity:entindex())
              return 0.3
            end
          end
          local invisibility_ability = thisEntity:FindAbilityByName("elves_hero_asassin_invisibility")
          if invisibility_ability and invisibility_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets =  FindUnitsInRadius(team, position, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(invisibility_ability, thisEntity:entindex())
              return 0.6
            end
          end
        end
      
      elseif name == "npc_dota_elves_hero_asassin_spec" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("elves_hero_asassin_spec_starfall")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.7
            end
          end
          local ability4 = thisEntity:FindAbilityByName("elves_hero_asassin_spec_ulta")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets =  FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
              return 0.7
            end
          end
        end
      
      elseif name == "npc_dota_elves_hero_pusher" then
        function entity:UnitAbilitiesAI()
          local lightning_ability = thisEntity:FindAbilityByName("elves_hero_pusher_arc_lightning")
          if lightning_ability and lightning_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnTarget(targets[1], lightning_ability, thisEntity:entindex())
              return 0.8
            end
          end
          local heal_ability = thisEntity:FindAbilityByName("elves_hero_pusher_heal")
          if heal_ability and heal_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:GetHealth() < targets[i]:GetMaxHealth() - 150 then
                thisEntity:CastAbilityNoTarget(heal_ability, thisEntity:entindex())
                return 0.9
              end
            end
          end
        end
      
      elseif name == "npc_dota_elves_mage" or name == "npc_dota_elves_mage_spec" then
        function entity:UnitAbilitiesAI()
          local armor_ability = thisEntity:FindAbilityByName("elves_creeps_mage_armor")
          if armor_ability and armor_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
              targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
              for i=1, #targets do
                if targets[i]:GetMaxHealth() > targets[i]:GetHealth() then
                  thisEntity:CastAbilityOnTarget(targets[i], armor_ability, thisEntity:entindex())
                  return 0.5
                end
              end
            end
          end
          local bless_ability = thisEntity:FindAbilityByName("elves_creeps_mage_blessing")
          if bless_ability and bless_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:GetMaxHealth() - 100 > targets[i]:GetHealth() then
                thisEntity:CastAbilityOnTarget(targets[i], bless_ability, thisEntity:entindex())
                return 0.5
              end
            end
          end
          local starfall_ability = thisEntity:FindAbilityByName("elves_creeps_mage_starfall")
          if starfall_ability and starfall_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(starfall_ability, thisEntity:entindex())
              return 1
            end
          end
          local aoe_ability = thisEntity:FindAbilityByName("elves_creeps_mage_aoe_debuff")
          if aoe_ability and aoe_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), aoe_ability, thisEntity:entindex())
              return 0.4
            end
          end
        end
    
      elseif name == "npc_dota_elves_range" then
        function entity:UnitAbilitiesAI()
          local ability = thisEntity:FindAbilityByName("elves_creeps_range_powershot")
          if ability and ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability, thisEntity:entindex())
              return 1.5
            end
          end
        end
      
      elseif name == "npc_dota_elves_air" then
        function entity:UnitAbilitiesAI()
          local shadow_wave_ability = thisEntity:FindAbilityByName("elves_creeps_air_shadow_wave")
          if shadow_wave_ability and shadow_wave_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:GetHealth() < targets[i]:GetMaxHealth() - 150 then
                thisEntity:CastAbilityOnTarget(targets[i], shadow_wave_ability, thisEntity:entindex())
                return 0.7
              end
            end
          end
        end
      
      elseif name == "npc_dota_elves_air_spec" then
        function entity:UnitAbilitiesAI()
          local shadow_wave_ability = thisEntity:FindAbilityByName("elves_creeps_air_shadow_wave")
          if shadow_wave_ability and shadow_wave_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:GetHealth() < targets[i]:GetMaxHealth() - 150 then
                thisEntity:CastAbilityOnTarget(targets[i], shadow_wave_ability, thisEntity:entindex())
                return 0.7
              end
            end
          end
          local liquid_fire_ability = thisEntity:FindAbilityByName("elves_creeps_air_spec_liquid_fire")
          if liquid_fire_ability and liquid_fire_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:HasFlyMovementCapability() then
                thisEntity:CastAbilityOnTarget(targets[i], liquid_fire_ability, thisEntity:entindex())
                return 0.7
              end
            end
          end
        end
      
      elseif name == "npc_dota_spiders_hero_tank" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("spiders_hero_tank_burrowstrike")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local range = {350,450,550,650}
            local targets = FindUnitsInRadius(team, position, nil, range[ability1:GetLevel()], DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_FARTHEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnTarget(targets[1], ability1, thisEntity:entindex())
              return 1
            end
          end
          local ability2 = thisEntity:FindAbilityByName("spiders_hero_tank_sandstorm")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 1
            end
          end
          local ability3 = thisEntity:FindAbilityByName("spiders_hero_tank_epicenter")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 2.5
            end
          end
        end
      
      elseif name == "npc_dota_spiders_hero_mage" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("spiders_hero_mage_impale")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_FARTHEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 1
            end
          end
          local ability2 = thisEntity:FindAbilityByName("spiders_hero_mage_manaburn")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO
            local flags = DOTA_UNIT_TARGET_FLAG_MANA_ONLY + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability2, thisEntity:entindex())
              return 0.7
            end
          end
          local ability3 = thisEntity:FindAbilityByName("spiders_hero_mage_carapace")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.2
            end
          end
          local ability4 = thisEntity:FindAbilityByName("spiders_hero_mage_burrow")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
              return 0.2
            end
          end
        end
      
      elseif name == "npc_dota_spiders_hero_asassin" then
        function entity:UnitAbilitiesAI()
          local aura_ability = thisEntity:FindAbilityByName("spiders_hero_asassin_shukuchi")
          if aura_ability and aura_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, thisEntity:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              local cache = thisEntity:GetOrigin()
              thisEntity:CastAbilityNoTarget(aura_ability, thisEntity:entindex())
              local dir = (targets[1]:GetOrigin()-thisEntity:GetAbsOrigin()):Normalized()
              local i = 8
              Timers:CreateTimer(.15,function()
                thisEntity:MoveToPosition(thisEntity:GetAbsOrigin()+(dir*1000))
                i = i - 1
                if i > 0 then
                  return 0.075
                else
                  return nil
                end
              end)
    
                Timers:CreateTimer(0.75,function()
                  thisEntity:MoveToPosition(cache)
                end)
              return 1.5
            end
          end
        end
      
      elseif name == "npc_dota_spiders_hero_pusher" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("spiders_hero_pusher_spawn_spiderlings")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnTarget(targets[1], ability1, thisEntity:entindex())
              return 0.8
            end
          end
          local ability2 = thisEntity:FindAbilityByName("spiders_hero_pusher_web")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_FARTHEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(position, ability2, thisEntity:entindex())
              return 1
            end
          end
          local ability3 = thisEntity:FindAbilityByName("spiders_hero_pusher_rage")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets =  FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 1
            end
          end
        end
    
      elseif name == "npc_dota_spiders_hero_pusher_spec" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("spiders_hero_pusher_spec_gale")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_FARTHEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.3
            end
          end
          local ability2 = thisEntity:FindAbilityByName("spiders_hero_pusher_spec_ward")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.3
            end
          end
          local ability3 = thisEntity:FindAbilityByName("spiders_hero_pusher_spec_banana")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.3
            end
          end
        end
      
      elseif name == "npc_dota_spiders_range" then
        function entity:UnitAbilitiesAI()
          local ability2 = thisEntity:FindAbilityByName("spiders_creeps_range_antiair")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:HasFlyMovementCapability() then
                thisEntity:CastAbilityOnTarget(targets[i], ability2, thisEntity:entindex())
                return 0.6
              end
            end
          end
          local ability1 = thisEntity:FindAbilityByName("spiders_creeps_range_net")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:HasFlyMovementCapability() then
                thisEntity:CastAbilityOnTarget(targets[i], ability1, thisEntity:entindex())
                return 0.9
              end
            end
          end
        end
    
      elseif name == "npc_dota_spiders_spec_spider" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("spiders_creeps_range_net")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 150, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:HasFlyMovementCapability() then
                thisEntity:CastAbilityOnTarget(targets[i], ability1, thisEntity:entindex())
                return 0.9
              end
            end
          end
        end
    
      elseif name == "npc_dota_spiders_mage" then
        function entity:UnitAbilitiesAI()
          local ability4 = thisEntity:FindAbilityByName("spiders_creeps_mage_web")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if not targets[i]:HasFlyMovementCapability() then
                thisEntity:CastAbilityOnTarget(targets[i], ability4, thisEntity:entindex())
                return 0.6
              end
            end
          end
          local ability1 = thisEntity:FindAbilityByName("spiders_creeps_mage_rage")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(thisEntity, ability1, thisEntity:entindex())
              return 0.6
            end
          end
          local ability3 = thisEntity:FindAbilityByName("spiders_creeps_mage_visage")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 1
            end
          end
          local ability2 = thisEntity:FindAbilityByName("spiders_creeps_mage_venomous_gale")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability2, thisEntity:entindex())
              return 1
            end
          end
        end
    
      elseif name == "npc_dota_spiders_arme" then
        function entity:UnitAbilitiesAI()
          local ability = thisEntity:FindAbilityByName("spiders_creeps_arme_roar")
          if ability and ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability, thisEntity:entindex())
              return 0.6
            end
          end
        end
    
      elseif name == "npc_dota_nagas_hero_tank" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("nagas_hero_tank_spawning_pond")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.65
            end
          end
          local ability4 = thisEntity:FindAbilityByName("nagas_hero_tank_corrosive_haze")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_nagas_hero_mage" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("nagas_hero_mage_arcs")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability1, thisEntity:entindex())
              return 0.6
            end
          end
          local ability3 = thisEntity:FindAbilityByName("nagas_hero_mage_tripple_gush")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability3, thisEntity:entindex())
              return 0.6
            end
          end
          local ability4 = thisEntity:FindAbilityByName("nagas_hero_mage_tornado")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability4, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_nagas_hero_asassin" then
        function entity:UnitAbilitiesAI()
          local ability4 = thisEntity:FindAbilityByName("nagas_hero_asassin_shadow_dance")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 and thisEntity:GetHealth() < thisEntity:GetMaxHealth() - 300 then
              thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
              return 0.6
            end
          end
        end
    
      elseif name == "npc_dota_nagas_hero_asassin_spec" then
        function entity:UnitAbilitiesAI()
          local ability4 = thisEntity:FindAbilityByName("nagas_hero_asassin_spec_waveform")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
              return 0.3
            end
          end
        end
    
      elseif name == "npc_dota_nagas_hero_pusher" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("nagas_hero_pusher_gush")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.6
            end
          end
          local ability2 = thisEntity:FindAbilityByName("nagas_hero_pusher_shell")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 and thisEntity:GetHealth() < thisEntity:GetMaxHealth() then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.3
            end
          end
          local ability4 = thisEntity:FindAbilityByName("nagas_hero_pusher_torrent_storm")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
              return 0.6
            end
          end
        end
    
      elseif name == "npc_dota_nagas_mage" then
        function entity:UnitAbilitiesAI()
          local shell_ability = thisEntity:FindAbilityByName("nagas_creeps_mage_shell")
          if shell_ability and shell_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_FARTHEST, false)
            for i=1, #targets do
              if targets[i]:GetMaxHealth() > targets[i]:GetHealth() then
                thisEntity:CastAbilityOnTarget(targets[i], shell_ability, thisEntity:entindex())
                return 0.5
              end
            end
          end
          local strike_ability = thisEntity:FindAbilityByName("nagas_creeps_mage_adaptive_strike")
          if strike_ability and strike_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], strike_ability, thisEntity:entindex())
              return 0.6
            end
          end
          local ability3 = thisEntity:FindAbilityByName("nagas_creeps_mage_curse_of_the_sea")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.8
            end
          end
          local purge_ability = thisEntity:FindAbilityByName("nagas_creeps_mage_purge")
          if purge_ability and purge_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              for i,v in ipairs(targets) do
                local mods = v:FindAllModifiers()
                for j,d in ipairs(mods) do
                  if not d:IsDebuff() and d:GetDuration() > 1 then
                    thisEntity:CastAbilityOnPosition(v:GetAbsOrigin(), purge_ability, thisEntity:entindex())
                    return 0.4
                  end
                end
              end
            end
          end
        end
    
      elseif name == "npc_dota_demons_hero_tank" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("demons_hero_tank_firestorm")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_FARTHEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.8
            end
          end
          local ability2 = thisEntity:FindAbilityByName("demons_hero_tank_pitofmalice")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_FARTHEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability2, thisEntity:entindex())
              return 0.8
            end
          end
        end
    
      elseif name == "npc_dota_demons_hero_mage" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("demons_hero_mage_pillar_of_flame")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.8
            end
          end
          local ability2 = thisEntity:FindAbilityByName("demons_hero_mage_sacrifice")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.6
            end
          end
          local ability4 = thisEntity:FindAbilityByName("demons_hero_mage_welcome_hell")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability4, thisEntity:entindex())
              return 0.9
            end
          end
        end
    
      elseif name == "npc_dota_demons_hero_asassin" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("demons_hero_asassin_illusion")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.5
            end
          end
          local ability2 = thisEntity:FindAbilityByName("demons_hero_asassin_wave_of_hatred")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              -- thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability2, thisEntity:entindex())
              thisEntity:CastAbilityOnTarget(targets[1], ability2, thisEntity:entindex())
              return 0.7
            end
          end
          local ability4 = thisEntity:FindAbilityByName("demons_hero_asassin_metamorfosis")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
              return 0.3
            end
          end
        end
    
      elseif name == "npc_dota_demons_hero_pusher" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("demons_hero_pusher_eat")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
            local targets = FindUnitsInRadius(team, position, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability1, thisEntity:entindex())
              return 0.6
            end
          end
          local ability2 = thisEntity:FindAbilityByName("demons_hero_pusher_fireearth")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.3
            end
          end
          local ability4 = thisEntity:FindAbilityByName("demons_hero_pusher_death_star")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              if #targets > 2 or targets[1]:IsCustomHero() then
                if thisEntity:GetHealth() < thisEntity:GetMaxHealth()*0.60 then
                  thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
                  return 0.3
                end
              end
            end
          end
        end
    
      elseif name == "npc_dota_demons_hero_pusher_spec" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("demons_hero_pusher_spec_meteor")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnTarget(targets[1], ability1, thisEntity:entindex())
              return 0.2
            end
          end
          local ability2 = thisEntity:FindAbilityByName("demons_hero_pusher_spec_golems")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.2
            end
          end
          local ability3 = thisEntity:FindAbilityByName("demons_hero_pusher_spec_disruption")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              for i=1, #targets do
                if targets[i]:IsCustomHero() then
                  thisEntity:CastAbilityOnTarget(targets[i], ability3, thisEntity:entindex())
                  return 0.5
                end
              end 
              thisEntity:CastAbilityOnTarget(targets[1], ability3, thisEntity:entindex())
              return 0.5
            end
          end
          local ability4 = thisEntity:FindAbilityByName("demons_hero_pusher_spec_upheaval")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
              return 0.6
            end
          end
        end
    
      elseif name == "npc_dota_demons_mage" then
        function entity:UnitAbilitiesAI()
          local ability_spec = thisEntity:FindAbilityByName("demons_creeps_mage_golem")
          if ability_spec and ability_spec:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability_spec, thisEntity:entindex())
              return 0.25
            end
          end
          local ability1 = thisEntity:FindAbilityByName("demons_creeps_mage_shadow_poison")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.6
            end
          end
          local ability2 = thisEntity:FindAbilityByName("demons_creeps_mage_shadow_word")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 650, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              local mod = targets[i]:FindModifierByName("modifier_demons_creeps_mage_shadow_word_buff")
              if targets[i]:GetMaxHealth() - 100 > targets[i]:GetHealth() and targets[i]:GetHealth() > 200 and not mod then
                thisEntity:CastAbilityOnTarget(targets[i], ability2, thisEntity:entindex())
                return 0.7
              end
            end
          end
          local ability3 = thisEntity:FindAbilityByName("demons_creeps_mage_soul_siphon")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability3, thisEntity:entindex())
              return 0.6
            end
          end
          local ability4 = thisEntity:FindAbilityByName("demons_creeps_mage_lifesteal")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(thisEntity, ability4, thisEntity:entindex())
              return 0.6
            end
          end
        end
    
      elseif name == "npc_dota_demons_air" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("demons_creeps_spec_astral")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability1, thisEntity:entindex())
              return 0.7
            end
          end
        end
    
      elseif name == "npc_dota_elementals_hero_tank" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("elementals_hero_tank_stump")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.7
            end
          end
          local ability3 = thisEntity:FindAbilityByName("elementals_hero_tank_remnant")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability3, thisEntity:entindex())
              return 0.8
            end
          end
        end
    
      elseif name == "npc_dota_elementals_hero_mage" then
        function entity:UnitAbilitiesAI()
          local ability2 = thisEntity:FindAbilityByName("elementals_hero_mage_summon_ents")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.6
            end
          end
          local ability4 = thisEntity:FindAbilityByName("elementals_hero_mage_black_hole")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability4, thisEntity:entindex())
              return 4.5
            end
          end
        end
    
      elseif name == "npc_dota_elementals_hero_asassin" then
        function entity:UnitAbilitiesAI()
          local ability4 = thisEntity:FindAbilityByName("elementals_hero_asassin_sleight_of_fist")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              -- thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability4, thisEntity:entindex())
              thisEntity:CastAbilityOnTarget(targets[1], ability4, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_elementals_hero_pusher" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("elementals_hero_pusher_resonant_pulse")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.3
            end
          end
          local ability2 = thisEntity:FindAbilityByName("elementals_hero_pusher_void_portal")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.3
            end
          end
          local ability3 = thisEntity:FindAbilityByName("elementals_hero_pusher_astral_step")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability3, thisEntity:entindex())
              return 0.5
            end
          end
          local ability4 = thisEntity:FindAbilityByName("elementals_hero_pusher_summon_mini")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
              return 0.6
            end
          end
        end
    
      elseif name == "npc_dota_elementals_mage" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("elementals_creeps_mage_electric_vortex")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.8
            end
          end
          local ability2 = thisEntity:FindAbilityByName("elementals_creeps_mage_eye_storm")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability2, thisEntity:entindex())
              return 0.7
            end
          end
          local ability3 = thisEntity:FindAbilityByName("elementals_creeps_mage_ats")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.6
            end
          end
        end
    
      elseif name == "npc_dota_elementals_air" then
        function entity:UnitAbilitiesAI()
          local ability2 = thisEntity:FindAbilityByName("elementals_creeps_spec_nova")
          if ability2 and ability2:IsFullyCastable() and ability2:IsActivated() then
            thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
            return 0.3
          end
        end
    
      elseif name == "npc_dota_elementals_siege" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("elementals_creeps_siege_illusion")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_diretide_hero_pusher" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("diretide_hero_pusher_shield")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.3
            end
          end
          local ability2 = thisEntity:FindAbilityByName("diretide_hero_pusher_moon")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.6
            end
          end
          local ability3 = thisEntity:FindAbilityByName("diretide_hero_pusher_pumpkin")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.3
            end
          end
          local ability4 = thisEntity:FindAbilityByName("diretide_hero_pusher_jetpack")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
              return 4
            end
          end
        end
    
      elseif name == "npc_dota_diretide_hero_asassin" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("diretide_hero_asassin_dash")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 1.2
            end
          end
          local ability3 = thisEntity:FindAbilityByName("diretide_hero_asassin_dagger")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability3, thisEntity:entindex())
              return 0.7
            end
          end
          local ability4 = thisEntity:FindAbilityByName("diretide_hero_asassin_dismember")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 750, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            for i=1, #targets do
              if targets[i]:IsCustomHero() and not targets[i]:IsIllusion() then
                thisEntity:CastAbilityOnTarget(targets[i], ability4, thisEntity:entindex())
                return 0.7
              end
            end
          end
        end
    
      elseif name == "npc_dota_diretide_hero_mage" then
        function entity:UnitAbilitiesAI()
          local ability2 = thisEntity:FindAbilityByName("diretide_hero_mage_summon_spiders")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.6
            end
          end
          local ability3 = thisEntity:FindAbilityByName("diretide_hero_mage_crippling_fear")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 475, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.4
            end
          end
          local ability4 = thisEntity:FindAbilityByName("diretide_hero_mage_sphere")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
              return 0.6
            end
          end
        end
    
      elseif name == "npc_dota_diretide_hero_tank" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("diretide_hero_tank_swallow")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.5
            end
          end
          local ability3 = thisEntity:FindAbilityByName("diretide_hero_tank_bonds")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.3
            end
          end
          local ability4 = thisEntity:FindAbilityByName("diretide_hero_tank_lifesteal_aura")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 220, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
              return 0.3
            end
          end
        end
    
      elseif name == "npc_dota_diretide_range" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("diretide_creeps_range_dust")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.4
            end
          end
        end
    
      elseif name == "npc_dota_diretide_mage" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("diretide_creeps_mage_maledict")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.6
            end
          end
          local ability2 = thisEntity:FindAbilityByName("diretide_creeps_mage_skull")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability2, thisEntity:entindex())
              return 0.7
            end
          end
          local ability3 = thisEntity:FindAbilityByName("diretide_creeps_mage_shield")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:GetMaxHealth() > targets[i]:GetHealth() then
                thisEntity:CastAbilityOnTarget(targets[i], ability3, thisEntity:entindex())
                return 0.7
              end
            end
          end
          local ability4 = thisEntity:FindAbilityByName("diretide_creeps_mage_grave")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              target_type = DOTA_UNIT_TARGET_BASIC
              flags = DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
              targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
              for i=1, #targets do
                if targets[i]:GetHealthPercent() < 51 then
                  thisEntity:CastAbilityOnTarget(targets[i], ability4, thisEntity:entindex())
                  return 0.4
                end
              end
            end
          end
        end
    
      elseif name == "npc_dota_diretide_arme" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("diretide_creeps_arme_hunger")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.3
            end
          end
        end
    
      elseif name == "npc_dota_diretide_air" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("diretide_creeps_air_nightmare")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.7
            end
          end
          local ability2 = thisEntity:FindAbilityByName("diretide_creeps_air_siphon")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.4
            end
          end
        end
    
      elseif name == "npc_dota_diretide_aura_range" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("diretide_creeps_aura_range_cookie")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 800, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:GetMaxHealth() - 100 > targets[i]:GetHealth() then
                thisEntity:CastAbilityOnTarget(targets[i], ability1, thisEntity:entindex())
                return 0.6
              end
            end
          end
        end
    
      elseif name == "npc_dota_frostivus_hero_tank" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("frostivus_hero_tank_sphere")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.6
            end
          end
          local ability2 = thisEntity:FindAbilityByName("frostivus_hero_tank_fissure")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability2, thisEntity:entindex())
              return 0.6
            end
          end
        end
    
      elseif name == "npc_dota_frostivus_hero_mage" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("frostivus_hero_mage_frozen_blast")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.5
            end
          end
          local ability3 = thisEntity:FindAbilityByName("frostivus_hero_mage_ice_walls")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.3
            end
          end
          local ability4 = thisEntity:FindAbilityByName("frostivus_hero_mage_ice_blast")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
              return 0.3
            end
          end
        end
    
      elseif name == "npc_dota_frostivus_hero_asassin" then
        function entity:UnitAbilitiesAI()
          local ability4 = thisEntity:FindAbilityByName("frostivus_hero_asassin_invisible")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
              return 0.7
            end
          end
        end
    
      elseif name == "npc_dota_frostivus_hero_pusher" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("frostivus_hero_pusher_circle")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.6
            end
          end
          local ability3 = thisEntity:FindAbilityByName("frostivus_hero_pusher_sigil")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.3
            end
          end
          local ability4 = thisEntity:FindAbilityByName("frostivus_hero_pusher_tree_volley")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability4, thisEntity:entindex())
              return 2.3
            end
          end
        end
    
      elseif name == "npc_dota_frostivus_range" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("frostivus_creeps_range_whirling_axes")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              -- thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              thisEntity:CastAbilityOnTarget(targets[1], ability1, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_frostivus_mage" then
        function entity:UnitAbilitiesAI()
          local ability5 = thisEntity:FindAbilityByName("frostivus_creeps_mage_embrace")
          if ability5 and ability5:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:GetHealthPercent() < 35 then
                thisEntity:CastAbilityOnTarget(targets[i], ability5, thisEntity:entindex())
                return 0.5
              end
            end
          end
          local ability4 = thisEntity:FindAbilityByName("frostivus_creeps_mage_sinister")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
            local targets = FindUnitsInRadius(team, position, nil, 670, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_FARTHEST, false)
            for i=1, #targets do
              if targets[i]:GetLevel() == 1 and not targets[i]:HasModifier("modifier_frostivus_creeps_mage_sinister_debuff") then
                thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
                return 2.3
              end
            end
          end
          local ability1 = thisEntity:FindAbilityByName("frostivus_creeps_mage_ice_shards")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.3
            end
          end
          local ability2 = thisEntity:FindAbilityByName("frostivus_creeps_mage_splinter_blast")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.7
            end
          end
          local ability3 = thisEntity:FindAbilityByName("frostivus_creeps_mage_shield")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.6
            end
          end
        end
    
      elseif name == "npc_dota_frostivus_siege" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("frostivus_creeps_siege_snowball")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability1, thisEntity:entindex())
              return 0.3
            end
          end
          local ability2 = thisEntity:FindAbilityByName("frostivus_creeps_siege_damage_aura")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.3
            end
          end
        end

      elseif name == "npc_dota_frostivus_tusk" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("frostivus_creeps_tusk_aura")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_dragons_hero_tank" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("dragons_hero_tank_eat")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability1, thisEntity:entindex())
              return 0.6
            end
          end
          local ability2 = thisEntity:FindAbilityByName("dragons_hero_tank_inner_fire")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.3
            end
          end
          local ability3 = thisEntity:FindAbilityByName("dragons_hero_tank_flames")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.3
            end
          end
        end
    
      elseif name == "npc_dota_dragons_hero_mage" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("dragons_hero_mage_freezing_expl")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.5
            end
          end
          local ability2 = thisEntity:FindAbilityByName("dragons_hero_mage_freezing_field")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 375, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.4
            end
          end
          local ability3 = thisEntity:FindAbilityByName("dragons_hero_mage_ice_path")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability3, thisEntity:entindex())
              return 1
            end
          end
          local ability4 = thisEntity:FindAbilityByName("dragons_hero_mage_mystic_flare")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability4, thisEntity:entindex())
              return 1
            end
          end
        end
    
      elseif name == "npc_dota_dragons_hero_mage_spec" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("dragons_hero_mage_spec_ice_lab")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.6
            end
          end
          local ability2 = thisEntity:FindAbilityByName("dragons_hero_mage_spec_icarus_dive")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability2, thisEntity:entindex())
              return 1.5
            end
          end
          local ability3 = thisEntity:FindAbilityByName("dragons_hero_mage_spec_ice_breath")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability3, thisEntity:entindex())
              return 0.5
            end
          end
          local ability4 = thisEntity:FindAbilityByName("dragons_hero_mage_spec_sunray")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
              return 0.6
            end
          end
        end
    
      elseif name == "npc_dota_dragons_hero_pusher" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("dragons_hero_pusher_spring")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.6
            end
          end
          local ability3 = thisEntity:FindAbilityByName("dragons_hero_pusher_rage")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.5
            end
          end
          local ability4 = thisEntity:FindAbilityByName("dragons_hero_pusher_solar_guardian")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
              return 0.5
            end
          end
        end
      
      elseif name == "npc_dota_dragons_arme" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("dragons_creeps_arme_helix")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.4
            end
          end
          local ability2 = thisEntity:FindAbilityByName("dragons_creeps_arme_stomp")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.8
            end
          end
        end
    
      elseif name == "npc_dota_dragons_range" then
        function entity:UnitAbilitiesAI()
          local ability2 = thisEntity:FindAbilityByName("dragons_creeps_range_fire_breathe")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability2, thisEntity:entindex())
              return 0.4
            end
          end
        end
    
      elseif name == "npc_dota_dragons_mage" then
        function entity:UnitAbilitiesAI()
          local mark_ability = thisEntity:FindAbilityByName("dragons_creeps_mage_mark")
          if mark_ability and mark_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], mark_ability, thisEntity:entindex())
              return 1
            end
          end
          local buff_ability = thisEntity:FindAbilityByName("dragons_creeps_mage_lifesteal")
          if buff_ability and buff_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(thisEntity, buff_ability, thisEntity:entindex())
              return 0.6
            end
          end
          local blizzard_ability = thisEntity:FindAbilityByName("dragons_creeps_mage_blizzard")
          if blizzard_ability and blizzard_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), blizzard_ability, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_dragons_air" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("dragons_creeps_air_fireball")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.5
            end
          end
          local ability2 = thisEntity:FindAbilityByName("dragons_creeps_air_antiair")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
            local targets = FindUnitsInRadius(team, position, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:HasFlyMovementCapability() then
                thisEntity:CastAbilityOnTarget(targets[i], ability2, thisEntity:entindex())
                return 0.6
              end
            end
          end
        end
    
      elseif name == "npc_dota_beastmen_hero_tank" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("beastmen_hero_tank_totem")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 375, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.4
            end
          end
          local ability2 = thisEntity:FindAbilityByName("beastmen_hero_tank_echo_slam")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 1
            end
          end
        end
    
      elseif name == "npc_dota_beastmen_hero_mage" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("beastmen_hero_mage_attendants")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.5
            end
          end
          local ability2 = thisEntity:FindAbilityByName("beastmen_hero_mage_heal")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.5
            end
          end
          local ability3 = thisEntity:FindAbilityByName("beastmen_hero_mage_summon_hawk")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.2
            end
          end
          local ability4 = thisEntity:FindAbilityByName("beastmen_hero_mage_penitence")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnTarget(targets[1], ability4, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_beastmen_hero_asassin" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("beastmen_hero_asassin_strike")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.5
            end
          end
          local ability4 = thisEntity:FindAbilityByName("beastmen_hero_asassin_illusion")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 and thisEntity:GetHealth() < thisEntity:GetMaxHealth() then
              thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
              return 0.4
            end
          end
        end
    
      elseif name == "npc_dota_beastmen_hero_pusher" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("beastmen_hero_pusher_lycan")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability1, thisEntity:entindex())
              return 0.4
            end
          end
          local ability2 = thisEntity:FindAbilityByName("beastmen_hero_pusher_howl")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.5
            end
          end
          local ability3 = thisEntity:FindAbilityByName("beastmen_hero_pusher_summon_wolf")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.5
            end
          end
          local ability4 = thisEntity:FindAbilityByName("beastmen_hero_pusher_shapeshift")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
              return 0.3
            end
          end
        end
      
      elseif name == "npc_dota_beastmen_arme" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("beastmen_creeps_arme_shockwave")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability1, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_beastmen_range" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("beastmen_creeps_range_boomerang")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability1, thisEntity:entindex())
              return 0.4
            end
          end
        end
    
      elseif name == "npc_dota_beastmen_mage" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("beastmen_creeps_mage_rage")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.4
            end
          end
          local armor_ability = thisEntity:FindAbilityByName("beastmen_creeps_mage_armor")
          if armor_ability and armor_ability:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
              flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
              targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
              if #targets > 1 then
                thisEntity:CastAbilityOnTarget(targets[1], armor_ability, thisEntity:entindex())
                return 1
              end
            end
          end
          local ability2 = thisEntity:FindAbilityByName("beastmen_creeps_mage_roar")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability2, thisEntity:entindex())
              return 0.4
            end
          end
        end
    
      elseif name == "npc_dota_beastmen_air" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("beastmen_creeps_air_seed")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_beastmen_siege" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("beastmen_creeps_siege_hairball")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnTarget(targets[1], ability1, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_primordials_hero_tank" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("primordials_hero_tank_stump")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 2.3
            end
          end
          local ability2 = thisEntity:FindAbilityByName("primordials_hero_tank_illusion")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.3
            end
          end
          local ability3 = thisEntity:FindAbilityByName("primordials_hero_tank_splitter")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_primordials_hero_mage" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("primordials_hero_mage_bolt")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.4
            end
          end
          local ability2 = thisEntity:FindAbilityByName("primordials_hero_mage_nimbus")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability2, thisEntity:entindex())
              return 0.4
            end
          end
          local ability3 = thisEntity:FindAbilityByName("primordials_hero_mage_shard")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.3
            end
          end
        end
    
      elseif name == "npc_dota_primordials_hero_mage_spec" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("primordials_hero_mage_bolt")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.4
            end
          end
          local ability2 = thisEntity:FindAbilityByName("primordials_hero_mage_nimbus")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability2, thisEntity:entindex())
              return 0.4
            end
          end
          local ability3 = thisEntity:FindAbilityByName("treants_hero_mage_spec_thorn_bush")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 1
            end
          end
          local ability4 = thisEntity:FindAbilityByName("treants_hero_mage_spec_forest_curse")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability4, thisEntity:entindex())
              return 1
            end
          end
          local ability5 = thisEntity:FindAbilityByName("treants_hero_mage_spec_gust")
          if ability5 and ability5:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetOrigin(), ability5, thisEntity:entindex())
              return 1
            end
          end
          local ability6 = thisEntity:FindAbilityByName("treants_hero_mage_seed")
          if ability6 and ability6:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 450, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability6, thisEntity:entindex())
              return 1
            end
          end
          local ability7 = thisEntity:FindAbilityByName("treants_hero_mage_nature_arc")
          if ability7 and ability7:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability7, thisEntity:entindex())
              return 1
            end
          end
          local ability8 = thisEntity:FindAbilityByName("undead_hero_mage_spec_swarm")
          if ability8 and ability8:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnTarget(targets[1], ability8, thisEntity:entindex())
              return 0.8
            end
          end
          local ability9 = thisEntity:FindAbilityByName("undead_hero_mage_spec_pulse")
          if ability9 and ability9:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability9, thisEntity:entindex())
              return 0.2
            end
          end
          local ability10 = thisEntity:FindAbilityByName("undead_hero_mage_spec_decay")
          if ability10 and ability10:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability10, thisEntity:entindex())
              return 0.8
            end
          end
          local ability11 = thisEntity:FindAbilityByName("undead_hero_mage_frost_armor")
          if ability11 and ability11:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability11, thisEntity:entindex())
              return 1
            end
          end
          local ability12 = thisEntity:FindAbilityByName("undead_hero_mage_ice_vortex")
          if ability12 and ability12:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability12, thisEntity:entindex())
              return 1
            end
          end
          local ability13 = thisEntity:FindAbilityByName("humans_hero_mage_fire_strike")
          if ability13 and ability13:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 400, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability13, thisEntity:entindex())
              return 0.8
            end
          end
          local ability14 = thisEntity:FindAbilityByName("humans_hero_mage_illuminate")
          if ability14 and ability14:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability14, thisEntity:entindex())
              return ability14:GetLevel()+1
            end
          end
          local ability15 = thisEntity:FindAbilityByName("orcs_hero_mage_static_buff")
          if ability15 and ability15:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability15, thisEntity:entindex())
              return 1
            end
          end
          local ability16 = thisEntity:FindAbilityByName("orcs_hero_mage_void")
          if ability16 and ability16:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability16, thisEntity:entindex())
              return 1
            end
          end
          local ability18 = thisEntity:FindAbilityByName("dwarfs_hero_mage_spec_rocket_barrage")
          if ability18 and ability18:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability18, thisEntity:entindex())
              return 0.4
            end
          end
          local ability19 = thisEntity:FindAbilityByName("dwarfs_hero_mage_spec_homing_missile")
          if ability19 and ability19:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 2 then
              thisEntity:CastAbilityNoTarget(ability19, thisEntity:entindex())
              return 0.8
            end
          end
          local ability20 = thisEntity:FindAbilityByName("dwarfs_hero_mage_spec_flak_cannon")
          if ability20 and ability20:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets =  FindUnitsInRadius(team, position, nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability20, thisEntity:entindex())
              return 0.4
            end
          end
          local ability21 = thisEntity:FindAbilityByName("dwarfs_hero_mage_march")
          if ability21 and ability21:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability21, thisEntity:entindex())
              return 0.9
            end
          end
          local ability22 = thisEntity:FindAbilityByName("dwarfs_hero_mage_laguna_blade")
          if ability22 and ability22:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability22, thisEntity:entindex())
              return 0.9
            end
          end
          local ability24 = thisEntity:FindAbilityByName("elves_hero_mage_arcs")
          if ability24 and ability24:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 750, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnTarget(targets[1], ability24, thisEntity:entindex())
              return 0.6
            end
          end
          local ability25 = thisEntity:FindAbilityByName("elves_hero_mage_dragon_slave")
          if ability25 and ability25:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability25, thisEntity:entindex())
              return 0.8
            end
          end
          local ability26 = thisEntity:FindAbilityByName("spiders_hero_mage_impale")
          if ability26 and ability26:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_FARTHEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability26, thisEntity:entindex())
              return 0.8
            end
          end
          local ability27 = thisEntity:FindAbilityByName("spiders_hero_mage_manaburn")
          if ability27 and ability27:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO
            local flags = DOTA_UNIT_TARGET_FLAG_MANA_ONLY + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability27, thisEntity:entindex())
              return 0.7
            end
          end
          local ability28 = thisEntity:FindAbilityByName("spiders_hero_mage_carapace")
          if ability28 and ability28:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability28, thisEntity:entindex())
              return 0.2
            end
          end
          local ability29 = thisEntity:FindAbilityByName("nagas_hero_mage_arcs")
          if ability29 and ability29:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability29, thisEntity:entindex())
              return 0.6
            end
          end
          local ability31 = thisEntity:FindAbilityByName("nagas_hero_mage_tripple_gush")
          if ability31 and ability31:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability31, thisEntity:entindex())
              return 0.6
            end
          end
          local ability32 = thisEntity:FindAbilityByName("demons_hero_mage_pillar_of_flame")
          if ability32 and ability32:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 625, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability32, thisEntity:entindex())
              return 0.8
            end
          end
          local ability33 = thisEntity:FindAbilityByName("demons_hero_mage_sacrifice")
          if ability33 and ability33:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability33, thisEntity:entindex())
              return 0.6
            end
          end
          local ability36 = thisEntity:FindAbilityByName("frostivus_hero_mage_frozen_blast")
          if ability36 and ability36:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability36, thisEntity:entindex())
              return 0.5
            end
          end
          local ability38 = thisEntity:FindAbilityByName("frostivus_hero_mage_ice_walls")
          if ability38 and ability38:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability38, thisEntity:entindex())
              return 0.3
            end
          end
          local ability39 = thisEntity:FindAbilityByName("dragons_hero_mage_spec_ice_lab")
          if ability39 and ability39:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability39, thisEntity:entindex())
              return 0.6
            end
          end
          local ability40 = thisEntity:FindAbilityByName("dragons_hero_mage_spec_icarus_dive")
          if ability40 and ability40:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability40, thisEntity:entindex())
              return 1.5
            end
          end
          local ability41 = thisEntity:FindAbilityByName("dragons_hero_mage_spec_ice_breath")
          if ability41 and ability41:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability41, thisEntity:entindex())
              return 0.5
            end
          end
          local ability42 = thisEntity:FindAbilityByName("dragons_hero_mage_freezing_expl")
          if ability42 and ability42:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability42, thisEntity:entindex())
              return 0.5
            end
          end
          local ability43 = thisEntity:FindAbilityByName("dragons_hero_mage_freezing_field")
          if ability43 and ability43:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 375, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability43, thisEntity:entindex())
              return 0.4
            end
          end
          local ability44 = thisEntity:FindAbilityByName("dragons_hero_mage_ice_path")
          if ability44 and ability44:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability44, thisEntity:entindex())
              return 1
            end
          end
          local ability45 = thisEntity:FindAbilityByName("beastmen_hero_mage_attendants")
          if ability45 and ability45:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability45, thisEntity:entindex())
              return 0.5
            end
          end
          local ability46 = thisEntity:FindAbilityByName("beastmen_hero_mage_heal")
          if ability46 and ability46:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability46, thisEntity:entindex())
              return 0.5
            end
          end
          local ability47 = thisEntity:FindAbilityByName("invaders_hero_mage_orb")
          if ability47 and ability47:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability47, thisEntity:entindex())
              return 0.4
            end
          end
          local ability48 = thisEntity:FindAbilityByName("invaders_hero_mage_storm")
          if ability48 and ability48:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability48, thisEntity:entindex())
              return 0.4
            end
          end
          local ability49 = thisEntity:FindAbilityByName("invaders_hero_mage_flux")
          if ability49 and ability49:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability49, thisEntity:entindex())
              return 0.5
            end
          end
          local ability50 = thisEntity:FindAbilityByName("pirates_hero_mage_tentacles")
          if ability50 and ability50:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 750, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability50, thisEntity:entindex())
              return 0.4
            end
          end
          local ability51 = thisEntity:FindAbilityByName("pirates_hero_mage_wind")
          if ability51 and ability51:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability51, thisEntity:entindex())
              return 0.4
            end
          end
          local ability52 = thisEntity:FindAbilityByName("pirates_hero_mage_torrent")
          if ability52 and ability52:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 650, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability52, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_primordials_hero_asassin" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("primordials_hero_asassin_spectral_dagger")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.3
            end
          end
          local ability3 = thisEntity:FindAbilityByName("primordials_hero_asassin_illusion")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.4
            end
          end
        end
    
      elseif name == "npc_dota_primordials_hero_pusher" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("primordials_hero_pusher_rock")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnTarget(targets[1], ability1, thisEntity:entindex())
              return 0.6
            end
          end
          local ability2 = thisEntity:FindAbilityByName("primordials_hero_pusher_trample")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 5
            end
          end
        end
    
      elseif name == "npc_dota_primordials_range" then
        function entity:UnitAbilitiesAI()
          local ability3 = thisEntity:FindAbilityByName("primordials_creeps_range_terrorwave")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability3, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_primordials_mage" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("primordials_creeps_mage_mark")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability1, thisEntity:entindex())
              return 0.35
            end
          end
          local ability2 = thisEntity:FindAbilityByName("primordials_creeps_mage_flames")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.4
            end
          end
          local ability3 = thisEntity:FindAbilityByName("primordials_creeps_mage_fortunes")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability3, thisEntity:entindex())
              return 0.4
            end
          end
        end
    
      elseif name == "npc_dota_invaders_hero_tank" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("invaders_hero_tank_aoe")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.4
            end
          end
          local ability2 = thisEntity:FindAbilityByName("invaders_hero_tank_ascetics_cap")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.3
            end
          end
          local ability3 = thisEntity:FindAbilityByName("invaders_hero_tank_spirits")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 255, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_invaders_hero_tank_spec" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("invaders_hero_tank_chrono")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.3
            end
          end
        end
    
      elseif name == "npc_dota_invaders_hero_mage" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("invaders_hero_mage_orb")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.4
            end
          end
          local ability2 = thisEntity:FindAbilityByName("invaders_hero_mage_storm")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.4
            end
          end
          local ability3 = thisEntity:FindAbilityByName("invaders_hero_mage_flux")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability3, thisEntity:entindex())
              return 0.5
            end
          end
          local ability4 = thisEntity:FindAbilityByName("invaders_hero_mage_split")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability4, thisEntity:entindex())
              return 1
            end
          end
        end
    
      elseif name == "npc_dota_invaders_hero_asassin" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("invaders_hero_asassin_dissimilate")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.3
            end
          end
          local ability2 = thisEntity:FindAbilityByName("invaders_hero_asassin_overcharge")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.2
            end
          end
          local ability4 = thisEntity:FindAbilityByName("invaders_hero_asassin_grip")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            for i=1, #targets do
              if targets[i]:IsCustomHero() and not targets[i]:IsIllusion() then
                thisEntity:CastAbilityOnTarget(targets[i], ability4, thisEntity:entindex())
                return 0.4
              end
            end
          end
        end
    
      elseif name == "npc_dota_invaders_hero_pusher" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("invaders_hero_pusher_dilation")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.4
            end
          end
          local ability2 = thisEntity:FindAbilityByName("invaders_hero_pusher_ion_shell")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.6
            end
          end
          local ability3 = thisEntity:FindAbilityByName("invaders_hero_pusher_mekanism")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability3, thisEntity:entindex())
              return 0.4
            end
          end
          local ability4 = thisEntity:FindAbilityByName("invaders_hero_pusher_void")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability4, thisEntity:entindex())
              return 0.4
            end
          end
        end
      
      elseif name == "npc_dota_invaders_air" then
        function entity:UnitAbilitiesAI()
          local ability2 = thisEntity:FindAbilityByName("invaders_creeps_air_blast")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.3
            end
          end
        end
      
      elseif name == "npc_dota_invaders_arme" then
        function entity:UnitAbilitiesAI()
          local ability2 = thisEntity:FindAbilityByName("invaders_creeps_arme_block_pass")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.4
            end
          end
        end
    
      elseif name == "npc_dota_invaders_melee" then
        function entity:UnitAbilitiesAI()
          local ability2 = thisEntity:FindAbilityByName("invaders_creeps_melee_shield")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.4
            end
          end
        end
    
      elseif name == "npc_dota_invaders_mage" then
        function entity:UnitAbilitiesAI()
          local ability5 = thisEntity:FindAbilityByName("invaders_creeps_mage_armor")
          if ability5 and ability5:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 475, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:GetMaxHealth() > targets[i]:GetHealth() then
                thisEntity:CastAbilityOnTarget(targets[i], ability5, thisEntity:entindex())
                return 0.5
              end
            end
          end
          local ability1 = thisEntity:FindAbilityByName("invaders_creeps_mage_shadow_wave")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
            for i=1, #targets do
              if targets[i]:GetMaxHealth() > targets[i]:GetHealth() then
                thisEntity:CastAbilityOnTarget(targets[i], ability1, thisEntity:entindex())
                return 0.5
              end
            end
          end
          local ability2 = thisEntity:FindAbilityByName("invaders_creeps_mage_brain_sap")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability2, thisEntity:entindex())
              return 0.5
            end
          end
          local ability3 = thisEntity:FindAbilityByName("invaders_creeps_mage_surge")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
              if #targets > 0 then
                thisEntity:CastAbilityOnTarget(targets[1], ability3, thisEntity:entindex())
                return 0.3
              end
            end
          end
          local ability4 = thisEntity:FindAbilityByName("invaders_creeps_mage_nightmare")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability4, thisEntity:entindex())
              return 0.8
            end
          end
        end
    
      elseif name == "npc_dota_invaders_siege" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("invaders_creeps_siege_bulldoze")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.2
            end
          end
        end
    
      elseif name == "npc_dota_pirates_hero_tank" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("pirates_hero_tank_drink")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.4
            end
          end
          local ability2 = thisEntity:FindAbilityByName("pirates_hero_tank_brew")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_FARTHEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability2, thisEntity:entindex())
              return 0.4
            end
          end
          local ability3 = thisEntity:FindAbilityByName("pirates_hero_tank_bomb")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 350, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_FARTHEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnTarget(targets[1], ability3, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_pirates_hero_mage" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("pirates_hero_mage_tentacles")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.4
            end
          end
          local ability2 = thisEntity:FindAbilityByName("pirates_hero_mage_wind")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 550, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.4
            end
          end
          local ability3 = thisEntity:FindAbilityByName("pirates_hero_mage_torrent")
          if ability3 and ability3:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability3, thisEntity:entindex())
              return 0.5
            end
          end
          local ability4 = thisEntity:FindAbilityByName("pirates_hero_mage_cold_feet")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_FARTHEST, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability4, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_pirates_hero_asassin" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("pirates_hero_asassin_shot")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
            for i=1, #targets do
              if targets[i]:IsCustomHero() and not targets[i]:IsIllusion() then
                thisEntity:CastAbilityOnTarget(targets[i], ability1, thisEntity:entindex())
                return 0.4
              end
            end
          end
        end
    
      elseif name == "npc_dota_pirates_hero_pusher" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("pirates_hero_pusher_zombie")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 500, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.4
            end
          end
          local ability2 = thisEntity:FindAbilityByName("pirates_hero_pusher_ravage")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 1 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.6
            end
          end
          local ability4 = thisEntity:FindAbilityByName("pirates_hero_pusher_ghost_ship")
          if ability4 and ability4:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_FARTHEST, false)
            if #targets > 1 then
              thisEntity:CastAbilityOnTarget(targets[1], ability4, thisEntity:entindex())
              return 0.7
            end
          end
        end
    
      elseif name == "npc_dota_pirates_mage" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("pirates_creeps_mage_spirt")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 570, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability1, thisEntity:entindex())
              return 0.5
            end
          end
          local ability2 = thisEntity:FindAbilityByName("pirates_creeps_mage_molotov")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 570, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability2, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      elseif name == "npc_dota_nights_hero_tank" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("nights_hero_tank_midnight")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityNoTarget(ability1, thisEntity:entindex())
              return 0.4
            end
          end
        end
    
      elseif name == "npc_dota_nights_hero_mage" then
        function entity:UnitAbilitiesAI()
          local ability2 = thisEntity:FindAbilityByName("nights_hero_mage_eclipse")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 850, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 2 then
              thisEntity:CastAbilityNoTarget(ability2, thisEntity:entindex())
              return 0.4
            end
          end
        end
    
      elseif name == "npc_dota_nights_mage" then
        function entity:UnitAbilitiesAI()
          local ability1 = thisEntity:FindAbilityByName("nights_creeps_mage_ice_cover")
          if ability1 and ability1:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            local targets = FindUnitsInRadius(team, position, nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnPosition(targets[1]:GetAbsOrigin(), ability1, thisEntity:entindex())
              return 0.3
            end
          end
          local ability2 = thisEntity:FindAbilityByName("nights_creeps_mage_mark")
          if ability2 and ability2:IsFullyCastable() then
            local team = thisEntity:GetTeamNumber()
            local position = thisEntity:GetAbsOrigin()
            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
            local targets = FindUnitsInRadius(team, position, nil, 570, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
            if #targets > 0 then
              thisEntity:CastAbilityOnTarget(targets[1], ability2, thisEntity:entindex())
              return 0.5
            end
          end
        end
    
      else
        function entity:UnitAbilitiesAI() return end
      end
    
    end

    getAbils(thisEntity)
    thisEntity.abilities_init = true
  end

  Timers:CreateTimer(0.1, getAbilsTimer)
  
  local thinkFunction = function()
    if thisEntity:IsNull() then return end
    --if thisEntity:IsCustomHero() then --управление героем
    --  thisEntity:SetControllableByPlayer(thisEntity:GetPlayerOwnerID(), true)
    --  return 
    --end
    if not thisEntity:IsAlive() then return end
  
    if GameRules:IsGamePaused() then
      return 0.1
    end
  
    if thisEntity.abilities_init and not thisEntity:IsSilenced() then
      local UnitAbilitiesAIReturn = thisEntity:UnitAbilitiesAI()
      if UnitAbilitiesAIReturn ~= nil then
        return UnitAbilitiesAIReturn
      end
    end

    if thisEntity.ai_items and not thisEntity:IsMuted() then
      local useItemsReturn = thisEntity:useItems()
      if useItemsReturn ~= nil then
        return useItemsReturn
      end
    end
  
    local old_target = thisEntity:GetAggroTarget()
  
    local agr = thisEntity:FindModifierByName("agr_mod")
    if agr then
      local agr_target = agr:GetCaster()
      if agr_target and agr_target:IsAlive() then
        if agr_target ~= old_target then
          thisEntity:Stop()
          -- thisEntity:SetAggroTarget(agr_target)
          -- thisEntity:SetForceAttackTarget(agr_target)
          thisEntity:MoveToTargetToAttack(agr_target)
          return agr:GetDuration()
        end
      end
    end
  
    local attack_capability = thisEntity:GetAttackCapability()
  
    if attack_capability ~= 0 then
  
      if thisEntity:IsDisarmed() then
        return 0.1
      end
  
      local team = thisEntity:GetTeamNumber()
      local position = thisEntity:GetAbsOrigin()
      local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
      local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
      local searchRange = 860
      local targets = nil
      local buildings = {}
      local attack_range = thisEntity:GetBaseAttackRange()
      if attack_range <= 400 then attack_range = 400 end
      
      if old_target and old_target:IsAlive() and not old_target:IsInvulnerable() and old_target:GetTeam() ~= team and not old_target:IsAttackImmune() and (old_target:GetAbsOrigin() - position):Length2D() < 800 and (attack_capability ~= 1 or not old_target:HasFlyMovementCapability() or old_target:HasModifier("modifier_remove_fly")) then
        if old_target:IsAncient() then
          ----------------------------------------------------------
          targets = FindUnitsInRadius(team, position, nil, searchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
          
          if attack_capability == 1 then
            for k, v in pairs(targets) do
              if v:HasFlyMovementCapability() and not v:HasModifier("modifier_remove_fly") then
                targets[k] = nil
              end
            end
          end
  
          for k, v in pairs(targets) do
            if v:IsAncient() then
              table.insert(buildings,v)
              targets[k] = nil
            end
          end
          ----------------------------------------------------------
  
          if #targets > 0 then
            for _, v in pairs(targets) do
              if (v:GetAbsOrigin() - position):Length2D() < attack_range then
                thisEntity:Stop()
                -- thisEntity:SetAggroTarget(v)
                -- thisEntity:SetForceAttackTarget(v)
                thisEntity:MoveToTargetToAttack(v)
                return .3
              end
            end
          end
        end
        return .3
      end
  
      ----------------------------------------------------------
      targets = FindUnitsInRadius(team, position, nil, searchRange, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
  
      if attack_capability == 1 and not thisEntity:IsCustomHero() then
        for k, v in pairs(targets) do
          if v:HasFlyMovementCapability() and not v:HasModifier("modifier_remove_fly") then
            targets[k] = nil
          end
        end
      end
  
      if thisEntity.hero_killer then
        local heroes = {}
        for k, v in pairs(targets) do
          if v:IsAncient() then
            table.insert(buildings,v)
            targets[k] = nil
          end
          if v:IsCustomHero() then
            table.insert(heroes,v)
            targets[k] = nil
          end
        end
        ----------------------------------------------------------
    
        if #heroes > 0 then
          for _, v in pairs(heroes) do
            thisEntity:Stop()
            -- thisEntity:SetAggroTarget(v)
            -- thisEntity:SetForceAttackTarget(v)
            thisEntity:MoveToTargetToAttack(v)
            return .3
          end
        elseif #targets > 0 then
          for _, v in pairs(targets) do
            thisEntity:Stop()
            -- thisEntity:SetAggroTarget(v)
            -- thisEntity:SetForceAttackTarget(v)
            thisEntity:MoveToTargetToAttack(v)
            return .3
          end
        elseif #buildings > 0 then
          thisEntity:Stop()
          -- thisEntity:SetAggroTarget(buildings[1])
          -- thisEntity:SetForceAttackTarget(buildings[1])
          thisEntity:MoveToTargetToAttack(buildings[1])
          return .3
        end
      else
        for k, v in pairs(targets) do
          if v:IsAncient() then
            table.insert(buildings,v)
            targets[k] = nil
          end
        end
        ----------------------------------------------------------
    
        if #targets > 0 then
          for _, v in pairs(targets) do
            thisEntity:Stop()
            -- thisEntity:SetAggroTarget(v)
            -- thisEntity:SetForceAttackTarget(v)
            thisEntity:MoveToTargetToAttack(v)
            return .3
          end
        elseif #buildings > 0 then
          thisEntity:Stop()
          -- thisEntity:SetAggroTarget(buildings[1])
          -- thisEntity:SetForceAttackTarget(buildings[1])
          thisEntity:MoveToTargetToAttack(buildings[1])
          return .3
        end
      end
      
    end
  
    if thisEntity.to_point then
      thisEntity:MoveToPosition(thisEntity.to_point)
    end
  
    return .4
  end  

	thisEntity:SetContextThink( "AIThink", thinkFunction, 0.2 )
end

-- function FindEnemiesInRadius( unit, radius, point )
--   local team = unit:GetTeamNumber()
--   local position = point or unit:GetAbsOrigin()
--   local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
--   local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
--   return FindUnitsInRadius(team, position, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
-- end