function SpawnHero(event)
	local caster = event.caster
	local ability = event.ability
	local hero = event.hero

    local id = caster:GetPlayerOwnerID()
	if caster:GetLevel() >= event.barrack_level and _G.playersinfo[id].ancient and _G.playersinfo[id].ancient:GetLevel() >= event.ancient_level then
    	local race_bonus = _G.playersinfo[id].ancient:FindAbilityByName("dragons_race_bonus")
	
		if race_bonus then
			local level = race_bonus:GetLevel()
    	    if level > 0 then
				race_bonus:ApplyDataDrivenModifier(_G.playersinfo[id].ancient, _G.playersinfo[id].ancient, "modifier_dragons_race_bonus_"..hero.."_buff", {})
				if _G.playersinfo[id].ancient:FindAbilityByName("dragons_ancient_race_aura") then
					race_bonus:ApplyDataDrivenModifier(_G.playersinfo[id].ancient, _G.playersinfo[id].ancient, "modifier_dragons_race_bonus_"..hero.."_debuff", {})
				end
			end
		end
	end
end