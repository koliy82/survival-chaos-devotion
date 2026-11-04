function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()
    local data = {}
	data.bonus_shield = ability:GetLevelSpecialValueFor( "bonus_shield" , level - 1  )
	data.bonus_shield_regen = ability:GetLevelSpecialValueFor( "bonus_shield_regen" , level - 1  )
	--data.red_stop_time = ability:GetLevelSpecialValueFor( "red_stop_time" , level - 1  )
	data.red_debuff_time = ability:GetLevelSpecialValueFor( "red_debuff_time" , level - 1  )
    local id = caster:GetPlayerOwnerID()

    for k, barack in pairs(_G.playersinfo[id].baracks) do
        local shield_abil = barack:FindAbilityByName("frostivus_barrack_shield")
        shield_abil:ApplyAuraBonus(data)
	end

    for k, v in pairs(_G.playersinfo[id].towers) do
        v:AddAbility("frostivus_barrack_shield"):SetLevel(2)
    end
end