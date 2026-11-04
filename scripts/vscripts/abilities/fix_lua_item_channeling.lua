fix_lua_item_channeling = class({})

function fix_lua_item_channeling:GetChannelTime()
    return self:GetLevel()
end

function fix_lua_item_channeling:OnChannelFinish(bInterrupted)
    if IsServer() then
        self:GetCaster():RemoveAbility("fix_lua_item_channeling")
        self.fixed_item:OnChannelFinish(bInterrupted)
    end
end