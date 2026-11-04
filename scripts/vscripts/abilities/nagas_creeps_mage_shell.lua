function OnCreatedShield(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    target.ncms_absorb_per_hit = ability:GetLevelSpecialValueFor( "damage_absorb_per_hit" , level - 1  )
    target.ncms_absorb = ability:GetLevelSpecialValueFor( "damage_absorb" , level - 1  ) - target.ncms_absorb_per_hit
    if target.barrier_mod and not target.barrier_mod:IsNull() then
        target.barrier_mod:Destroy()
    end
    target.barrier_mod = target:AddBarrier(target.ncms_absorb_per_hit, 0, nil, caster, ability)

    
    local absorbFunc = function(event)
		local target = event.modifier:GetParent()

        if target and target.ncms_absorb_per_hit and target.ncms_absorb then
            if event.modifier.durability < target.ncms_absorb_per_hit then
                local add_b = math.min(target.ncms_absorb_per_hit - event.modifier.durability, target.ncms_absorb)
                target.ncms_absorb = target.ncms_absorb - add_b
                event.modifier.durability = event.modifier.durability + add_b
                if target.ncms_absorb <= 0 then
                    target:RemoveModifierByName("modifier_nagas_creeps_mage_shell")
                end
            end
        else
            target:RemoveModifierByName("modifier_nagas_creeps_mage_shell")
        end
    end
    
    table.insert( target.barrier_mod.OnDamageBarrier, absorbFunc )
end

function EndShield(event)
    local caster = event.caster
    local target = event.target
    target.ncms_absorb = nil
    target.ncms_absorb_per_hit = nil
    if target.barrier_mod and not target.barrier_mod:IsNull() then
        target.barrier_mod:Destroy()
    end
    target.barrier_mod = nil
end