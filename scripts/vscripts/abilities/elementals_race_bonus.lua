function Thinker(event)
	local caster = event.caster
	local id = caster:GetPlayerOwnerID()
    local ability = _G.playersinfo[id].ancient:FindAbilityByName("elementals_race_bonus")

	if _G.playersinfo[id].ancient and GameRules:State_Get() >= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and (ability:IsCooldownReady() or event.change) then

    	local effects ={"modifier_elementals_fire",
						"modifier_elementals_ice",
						"modifier_elementals_earth", 
						"modifier_elementals_air", 
						"modifier_elementals_storm", 
						"modifier_elementals_void"}
		
    	local random = RandomInt(1, #effects)
		ability:StartCooldown(ability:GetEffectiveCooldown(ability:GetLevel()) - 1)

		for i = 1, #effects do
			_G.playersinfo[id].ancient:RemoveModifierByName(effects[i])
		end

		local choose = effects[random]
		if event.change then
			local abilities ={"elementals_spec_chaos_element_elementals_fire",
			"elementals_spec_chaos_element_elementals_ice",
			"elementals_spec_chaos_element_elementals_earth",
			"elementals_spec_chaos_element_elementals_air",
			"elementals_spec_chaos_element_elementals_storm",
			"elementals_spec_chaos_element_elementals_void"}

			choose = event.change
			for i = 1, #abilities do
				_G.playersinfo[id].spec:RemoveAbility(abilities[i])
				caster:FindAbilityByName("elementals_spec_chaos_element_change"):SetLevel(1)
			end
		end

		if _G.playersinfo[id].ancient:FindAbilityByName("elementals_ancient_armor_aura") then
			local random2 = RandomInt(1, #effects - 1)
			local choose2 = effects[random2]
			if choose == choose2 then
				choose2 = effects[random2 + 1]
			end
			ability:ApplyDataDrivenModifier(_G.playersinfo[id].ancient, _G.playersinfo[id].ancient, choose2, {})
		end
		ability:ApplyDataDrivenModifier(_G.playersinfo[id].ancient, _G.playersinfo[id].ancient, choose, {})


		Timers:CreateTimer(0.1, function()
            local gameEvent = {}
            gameEvent["player_id"] = id
            gameEvent["teamnumber"] = caster:GetTeam()
            gameEvent["locstring_value"] = "#DOTA_Tooltip_" .. choose
            gameEvent["message"] = "#Combat_Message_chaos_element"
            FireGameEvent( "dota_combat_event_message", gameEvent )
    	end)
	end	
end

function ApplyBuffToBuildings(event)
    local caster = event.caster
	local effect = event.effect
	local ability = event.ability
    local id = caster:GetPlayerOwnerID()

	for k, v in pairs(_G.playersinfo[id].baracks) do
		if event.decrease_cooldown and event.ability:GetLevel() == 2 then
			if event.destroy then
				v.barrack_timer = v.barrack_timer + event.decrease_cooldown
			else
				v.barrack_timer = v.barrack_timer - event.decrease_cooldown
			end
		elseif event.decrease_cooldown_hero and event.ability:GetLevel() == 2 then
			if event.destroy then
				v:FindAbilityByName("spawn_hero_elementals_tank"):SetLevel(1)
				v:FindAbilityByName("spawn_hero_elementals_mage"):SetLevel(1)
				v:FindAbilityByName("spawn_hero_elementals_asassin"):SetLevel(1)
				v:FindAbilityByName("spawn_hero_elementals_pusher"):SetLevel(1)
			else
				v:FindAbilityByName("spawn_hero_elementals_tank"):SetLevel(2)
				v:FindAbilityByName("spawn_hero_elementals_mage"):SetLevel(2)
				v:FindAbilityByName("spawn_hero_elementals_asassin"):SetLevel(2)
				v:FindAbilityByName("spawn_hero_elementals_pusher"):SetLevel(2)
			end
		else
			if event.destroy then
				v:RemoveModifierByNameAndCaster(effect, caster)
			else
				ability:ApplyDataDrivenModifier(caster, v, effect, {})
			end
		end
	end
	if event.only_barracks then return end

	for k, v in pairs(_G.playersinfo[id].towers) do
		if event.destroy then
			v:RemoveModifierByNameAndCaster(effect, caster)
		else
			ability:ApplyDataDrivenModifier(caster, v, effect, {})
		end
	end

	if caster then
		if event.destroy then
			caster:RemoveModifierByNameAndCaster(effect, caster)
		else
			ability:ApplyDataDrivenModifier(caster, caster, effect, {})
		end
	end
end