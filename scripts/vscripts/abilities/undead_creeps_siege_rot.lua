function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    ability:SetActivated(false)
end

function OnSpellStart(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()
    local need_stacks = ability:GetLevelSpecialValueFor( "need_stacks" , level - 1  )
    local mod = caster:FindModifierByName("modifier_undead_creeps_siege_rot")
    mod:SetStackCount(mod:GetStackCount()-need_stacks)
end

function OnEnemyDeath(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()
    if level > 0 then
        local mod = caster:FindModifierByName("modifier_undead_creeps_siege_rot")
        mod:SetStackCount(mod:GetStackCount()+1)
        local need_stacks = ability:GetLevelSpecialValueFor( "need_stacks" , level - 1  )
        if mod:GetStackCount() >= need_stacks then
            ability:SetActivated(true)
        else
            ability:SetActivated(false)
        end
    end
end