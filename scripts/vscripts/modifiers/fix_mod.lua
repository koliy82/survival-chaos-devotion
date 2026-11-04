--LinkLuaModifier( "fix_mod", "modifiers/fix_mod.lua", LUA_MODIFIER_MOTION_NONE )
fix_mod = class({})

-- function fix_mod:OnCreated( kv )
--     if IsServer() then
--         self:GetAbility():OnEquipped()
--     end
-- end

function fix_mod:IsHidden()
    return true
end