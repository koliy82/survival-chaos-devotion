function OnAttackLanded( event )
    local target = event.target

    if target:IsCustomHero() and target:HasFlyMovementCapability() then
        event.ability:ApplyDataDrivenModifier(event.caster, target, "modifier_repair_building_antiair_debuff", {duration = 20})
    end
end

function OnCreated(event)
    event.target:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
    FindClearSpaceForUnit(event.target, event.target:GetAbsOrigin(), false)
end

function OnDestroy(event)
    event.target:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
end