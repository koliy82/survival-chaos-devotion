-- function SetLevel(event)
--     local caster = event.caster
--     local ability = event.ability
    
--     local main_ability = caster:FindAbilityByName("primordials_creeps_siege_telekinesis")
--     if main_ability and main_ability:GetLevel() > 0 then
--         ability:SetLevel(main_ability:GetLevel())
--     end
-- end

function OnCreated(event)
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    local min_eff = ability:GetLevelSpecialValueFor( "min_eff" , level - 1  )
    target.barrack_timer = target.barrack_timer + min_eff
    target.min_eff = min_eff
end

function OnDestroy(event)
    local target = event.target
    local ability = event.ability
    target.barrack_timer = target.barrack_timer - target.min_eff
    target.min_eff = nil
end