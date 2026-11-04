LinkLuaModifier( "modifier_elementals_weather", "modifiers/modifier_elementals_weather.lua", LUA_MODIFIER_MOTION_NONE )
local elementals = {}

function elementals:Init()
	-- если выбрать спец постройку после выхода крипов, то первый эффект начнётся после таймера
    local effects = {"modifier_elementals_spec_chaos_element_pass_as_buff",
		"modifier_elementals_spec_chaos_element_pass_armor_debuff",
		"modifier_elementals_spec_chaos_element_pass_armor_buff", 
		"modifier_elementals_spec_chaos_element_pass_damage_buff", 
		"modifier_elementals_spec_chaos_element_pass_damage_debuff", 
		"modifier_elementals_spec_chaos_element_pass_mana_castle_debuff", 
		"modifier_elementals_spec_chaos_element_pass_mana_castle_buff", 
		"modifier_elementals_spec_chaos_element_pass_as_towers_buff",
		"modifier_elementals_spec_chaos_element_pass_damage_buildings_debuff",
		"modifier_elementals_spec_chaos_element_pass_hero_armor_debuff",
		"modifier_elementals_spec_chaos_element_pass_hero_armor_buff",
        "modifier_elementals_spec_chaos_element_pass_armor_buildings_buff"}
	-- в таблицу добавляются модификаторы из главной пассивки спец постройки
    local random = RandomInt(1, #effects)
    elementals.timer = 20
    elementals.weather = CreateUnitByName("npc_elementals_weather", Vector(0,0,0), true, nil, nil, DOTA_TEAM_NEUTRALS)
    elementals.weather:AddNewModifier(elementals.weather, nil, "modifier_elementals_weather", {})
	
    table.insert(_G.onstartgame, elementals)
end

function elementals:StartGame()
    elementals:Earth()
    Timers:CreateTimer(elementals.timer, function()
        elementals:Earth()
        return elementals.timer
    end)
end

function elementals:Fire()

end

function elementals:Ice()

end

function elementals:Earth()
    elementals:SendMessage("weather_earth")
    local pulse_period = 1
    local radius = 300
    local stun_duration = 2
    
    for i = 0, elementals.timer / pulse_period do
        Timers:CreateTimer(pulse_period * i, function()
	        local units = FindUnitsInRadius(elementals.weather:GetTeamNumber(), elementals.weather:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false)
	        if #units > 0 then
                local nFXIndex = ParticleManager:CreateParticle( "particles/rain_fx/econ_rain.vpcf", PATTACH_WORLDORIGIN, nil )
		        ParticleManager:SetParticleControl( nFXIndex, 0, units[1]:GetOrigin() )
		        --ParticleManager:SetParticleControl( nFXIndex, 1, Vector( radius, 1, 1 ) )
		        ParticleManager:ReleaseParticleIndex( nFXIndex )
                --EmitSoundOn("Hero_EarthShaker.EchoSlam", elementals.weather)
                local targets = FindUnitsInRadius(elementals.weather:GetTeamNumber(), units[1]:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_ANY_ORDER, false)
                for _, target in ipairs(targets) do
                    if string.find(target:GetUnitName(), "elementals") ~= nil then
                    else
                        target:AddNewModifier(elementals.weather, nil, "modifier_stunned", {duration = stun_duration})
                    end
                end
            end
        end)
    end
end

function elementals:Air()

end

function elementals:Storm()

end

function elementals:Void()

end

function elementals:Rain()

end

function elementals:SendMessage(message)
    
    Timers:CreateTimer(0.1, function()
            local gameEvent = {}
            gameEvent["player_id"] = 0
            gameEvent["teamnumber"] = -1
            gameEvent["locstring_value"] = message
            gameEvent["message"] = "#Combat_Message_weather"
            FireGameEvent( "dota_combat_event_message", gameEvent )
    end)
end

elementals:Init()
return elementals