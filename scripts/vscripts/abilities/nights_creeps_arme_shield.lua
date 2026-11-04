function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    
	local level = ability:GetLevel()
	local durability = ability:GetLevelSpecialValueFor( "durability" , level - 1  )
    ability.barrier_mod = caster:AddBarrier(durability, 0, nil, caster, ability)
	ability.barrier_mod.pause_regen = ability:GetLevelSpecialValueFor( "pause_regen" , level - 1  )
	ability.barrier_mod.night_regen = ability:GetLevelSpecialValueFor( "night_regen" , level - 1  )
	ability.barrier_mod.regen = ability:GetLevelSpecialValueFor( "regen" , level - 1  )
    ability.barrier_mod.max_durability = durability
    ability.barrier_mod.last_damage = 0
    
    ability.barrier_mod:StartIntervalThink(1)

    function ability.barrier_mod:OnIntervalThink()
        if GameRules:GetDOTATime(false,false) - ability.barrier_mod.last_damage > ability.barrier_mod.pause_regen then
            ability.barrier_mod.durability = ability.barrier_mod.durability + ability.barrier_mod.regen
        end
        if not GameRules:IsDaytime() or caster:HasModifier("modifier_nights_ancient_day_aura_buff") then
            ability.barrier_mod.durability = ability.barrier_mod.durability + ability.barrier_mod.night_regen
        end
        if ability.barrier_mod.durability >= ability.barrier_mod.max_durability then
            ability.barrier_mod.durability = ability.barrier_mod.max_durability
        end
        ability.barrier_mod:SetStackCount(ability.barrier_mod.durability)
    end

    table.insert( ability.barrier_mod.OnDamageBarrier, function()
        if ability.barrier_mod.durability <= 0 then
            ability.barrier_mod.durability = 0.01
        end
        ability.barrier_mod.last_damage = GameRules:GetDOTATime(false,false)
    end )
end