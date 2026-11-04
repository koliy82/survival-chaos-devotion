modifier_elite_unit = class({})

function modifier_elite_unit:IsHidden()
	return true
end

function modifier_elite_unit:OnCreated(event)
    if IsServer() then
        ListenToGameEvent('custom_spawn_unit', self.OnSpawnUnit, self)
    end
end

function modifier_elite_unit:OnDestroy()
    if IsServer() then
        StopListeningToAllGameEvents(self)
    end
end

function modifier_elite_unit:OnSpawnUnit(event)
    local spawner_unit = EntIndexToHScript(event.spawner_unit)
    if self:GetParent() == spawner_unit then
        local caster = self:GetCaster()
        local unit = EntIndexToHScript(event.unit)
		if string.find(unit:GetUnitName(), "mage") ~= nil and not unit:IsCustomHero() then
            Timers:CreateTimer(0, function()
                local unit_name = unit:GetUnitName()
                local id = unit:GetPlayerOwnerID()
                unit:SetBaseMaxHealth(_G.playersinfo[id].unitsinfo[unit_name].health)
                unit:SetMaxHealth(_G.playersinfo[id].unitsinfo[unit_name].health)
                unit:CalculateGenericBonuses()
                unit:SetHealth(_G.playersinfo[id].unitsinfo[unit_name].health)
			    unit:AddAbility("elite_unit_pass"):SetLevel(1)
            end)
		end
    end
end
