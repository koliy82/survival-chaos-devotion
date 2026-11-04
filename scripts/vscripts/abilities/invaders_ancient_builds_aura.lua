LinkLuaModifier( "modifier_neutral_locked", "modifiers/modifier_neutral_locked", LUA_MODIFIER_MOTION_NONE )

function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()
    local team = caster:GetTeam()

    function ability:OnCaptureNeutral(event)
        local neutral = EntIndexToHScript( event.neutral )
        local mod1 = neutral:FindModifierByNameAndCaster("modifier_invaders_ancient_builds_neutral_lock", caster)
        if mod1 then
            mod1:Destroy()
            local mod2 = neutral:FindModifierByName("modifier_invaders_ancient_builds_neutral_lock")
            if mod2 then
                mod2:Destroy()
            end
            neutral:SetNewCustomOwner(caster:GetOwner())
            neutral:FindModifierByName("modifier_invaders_ancient_builds_neutral_lock"):Destroy()
            neutral:AddNewModifier(caster, ability, "modifier_neutral_locked", {duration = ability:GetSpecialValueFor( "lock_duration" )})
        end
        if team == event.new_team then
            ability:ApplyDataDrivenModifier(caster, neutral, "modifier_invaders_ancient_builds_neutral_lock", {})
        end
    end

    ListenToGameEvent('capture_neutral', ability.OnCaptureNeutral, ability)
    
    if _G.playersinfo[id].ancient then
        ability:ApplyDataDrivenModifier(caster, _G.playersinfo[id].ancient, "modifier_invaders_ancient_builds_aura_buff", {})
	end
    for k, v in pairs(_G.playersinfo[id].baracks) do
        ability:ApplyDataDrivenModifier(caster, v, "modifier_invaders_ancient_builds_aura_buff", {})
	end
    for k, v in pairs(_G.playersinfo[id].towers) do
        ability:ApplyDataDrivenModifier(caster, v, "modifier_invaders_ancient_builds_aura_buff", {})
	end
end

function OnDestroy(event)
    local ability = event.ability
    StopListeningToAllGameEvents(ability)
end
