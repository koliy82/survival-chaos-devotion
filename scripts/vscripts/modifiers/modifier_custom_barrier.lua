modifier_custom_barrier = class( {} )

function modifier_custom_barrier:OnCreated( params )
    if IsServer() then
        self.OnDamageBarrier = {}
        self.durability = params.durability
        self.damage_type = params.damage_type
    end
end

function modifier_custom_barrier:IsHidden()
	return false
end

function modifier_custom_barrier:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_custom_barrier:DamageBarrier(damage)
    if IsServer() then
        self.durability = self.durability - damage
        local params = {}
        params.modifier = self
        if self.durability <= 0 then
            local ret = -self.durability
            self.durability = 0
            for _,func in pairs(self.OnDamageBarrier) do
                params.absorb = damage - ret
                func(params)
            end
            if self.durability <= 0 then
                self:Destroy()
            end
            return ret
        else
            for _,func in pairs(self.OnDamageBarrier) do
                params.absorb = damage
                func(params)
            end
            return 0
        end
    end
end