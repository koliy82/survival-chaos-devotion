function OnCreated(event)
    local caster = event.caster
    local ability = event.ability

    ability.max_durability_mult = 1
    ability.pause_regen_mult = 1
    ability.regen_mult = 1
    
	local level = ability:GetLevel()
	local durability = ability:GetLevelSpecialValueFor( "durability" , level - 1  )
    ability.barrier_mod = caster:AddBarrier(durability, 0, nil, caster, ability)
	ability.barrier_mod.debuff_duration = ability:GetLevelSpecialValueFor( "debuff_duration" , level - 1  )
	ability.barrier_mod.pause_regen = ability:GetLevelSpecialValueFor( "pause_regen" , level - 1  )
	ability.barrier_mod.regen = ability:GetLevelSpecialValueFor( "regen" , level - 1  )
    ability.barrier_mod.debuff_slow_regen = ability:GetLevelSpecialValueFor( "debuff_slow_regen" , level - 1  )
    ability.barrier_mod.max_durability = durability
    ability.barrier_mod.last_damage = 0
    
    ability.barrier_mod:StartIntervalThink(1)

    function ability.barrier_mod:OnIntervalThink()
        if GameRules:GetDOTATime(false,false) - ability.barrier_mod.last_damage > ability.barrier_mod.pause_regen then
            if caster:FindModifierByName("modifier_frostivus_barrack_shield_debuff") ~= nil then
                ability.barrier_mod.durability = ability.barrier_mod.durability + ability.barrier_mod.regen - ability.barrier_mod.debuff_slow_regen
            else
                ability.barrier_mod.durability = ability.barrier_mod.durability + ability.barrier_mod.regen
            end
        end
        if ability.barrier_mod.durability >= ability.barrier_mod.max_durability then
            ability.barrier_mod.durability = ability.barrier_mod.max_durability
            if caster:FindModifierByName("modifier_frostivus_barrack_shield_regen_buff") == nil then
                ability:ApplyDataDrivenModifier(caster, caster, "modifier_frostivus_barrack_shield_regen_buff", {})
            end
        else
            if caster:FindModifierByName("modifier_frostivus_barrack_shield_regen_buff") ~= nil then
                caster:RemoveModifierByName("modifier_frostivus_barrack_shield_regen_buff")
            end
        end
        ability.barrier_mod:SetStackCount(ability.barrier_mod.durability)
    end

    table.insert( ability.barrier_mod.OnDamageBarrier, function()
        if ability.barrier_mod.durability <= 0 then
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_frostivus_barrack_shield_debuff", {duration = ability.barrier_mod.debuff_duration})
            ability.barrier_mod.durability = 0.01
            ability.barrier_mod.last_damage = GameRules:GetDOTATime(false,false)
        end
    end )
    
    function ability:ApplyAuraBonus(data)
        ability.barrier_mod.debuff_duration = ability.barrier_mod.debuff_duration * (100 - data.red_debuff_time) / 100
        ability.max_durability_mult = 1 + data.bonus_shield / 100
        ability.regen_mult = 1 + data.bonus_shield_regen / 100
        --ability.pause_regen_mult = 1 + data.red_stop_time / 100

        local event = {}
        event.ability = ability
        ability:Custom_OnUpgrade(event)
    end

    function ability:Custom_OnUpgrade(event)
        local ability = event.ability
        local level = ability:GetLevel()
        local now_durability_part = ability.barrier_mod.durability / ability.barrier_mod.max_durability
        ability.barrier_mod.max_durability = ability:GetLevelSpecialValueFor( "durability" , level - 1  ) * ability.max_durability_mult
        ability.barrier_mod.pause_regen = ability:GetLevelSpecialValueFor( "pause_regen" , level - 1  ) * ability.pause_regen_mult
        ability.barrier_mod.regen = ability:GetLevelSpecialValueFor( "regen" , level - 1  ) * ability.regen_mult
        ability.barrier_mod.debuff_slow_regen = ability:GetLevelSpecialValueFor( "debuff_slow_regen" , level - 1  )
        ability.barrier_mod.durability = ability.barrier_mod.max_durability * now_durability_part
    end
end

function OnUpgrade(event)
    local ability = event.ability
    ability:Custom_OnUpgrade(event)
end