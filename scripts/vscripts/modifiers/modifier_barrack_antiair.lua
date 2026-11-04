LinkLuaModifier( "modifier_barrack_antiair", "modifiers/modifier_barrack_antiair.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_barrack_antiair_debuff", "modifiers/modifier_barrack_antiair.lua", LUA_MODIFIER_MOTION_NONE )

modifier_barrack_antiair = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    IsPermanent             = function(self) return true end,
    DeclareFunctions        = function(self) return {MODIFIER_EVENT_ON_ATTACK_LANDED} end,
})

function modifier_barrack_antiair:OnAttackLanded(event)
    local target = event.target

    if target:IsCustomHero() and target:HasFlyMovementCapability() then
        target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_barrack_antiair_debuff", {duration = 5})
    end
end

-------------------------------------------------------------------------------

modifier_barrack_antiair_debuff = class( {} )

function modifier_barrack_antiair_debuff:IsHidden()
	return false
end

function modifier_barrack_antiair_debuff:IsDebuff()
	return true
end

function modifier_barrack_antiair_debuff:OnCreated( event )
    if IsClient() then return end

    self:GetParent():SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
    FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), false)
end

function modifier_barrack_antiair_debuff:OnDestroy( event )
    if IsClient() then return end

    self:GetParent():SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
end

