function OnCreated(event)
    -- event.target:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
    local ability = event.ability
    ability:ApplyDataDrivenModifier(event.caster, event.target, "modifier_remove_fly", {})
    FindClearSpaceForUnit(event.target, event.target:GetAbsOrigin(), false)
end

function OnDestroy(event)
    -- event.target:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
    event.target:RemoveModifierByName("modifier_remove_fly")
end