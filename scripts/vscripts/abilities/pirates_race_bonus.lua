LinkLuaModifier( "modifier_pirates_race_bonus_neutrals", "abilities/pirates_race_bonus", LUA_MODIFIER_MOTION_NONE )

function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    caster:AddNewModifier(caster, ability, "modifier_pirates_race_bonus_neutrals", {})
    local id = caster:GetPlayerOwnerID()

    function ability:OnBuildingUpgrade(event)
        local building = EntIndexToHScript( event.building )
        if id == building:GetPlayerOwnerID() and building:GetUnitName() == "npc_dota_custom_ancient" then
            ability:SetLevel(building:GetLevel())
        end
    end

    ListenToGameEvent('building_upgrade', ability.OnBuildingUpgrade, ability)
end

function OnDestroy(event)
    local ability = event.ability
    
    StopListeningToAllGameEvents(ability)
end

--------------------------------------------------------------------------------

modifier_pirates_race_bonus_neutrals = class({})

function modifier_pirates_race_bonus_neutrals:OnCreated( params )
    if IsServer() then
        self.team = self:GetCaster():GetTeam()
        self.max_neutrals = self:GetAbility():GetSpecialValueFor( "max_neutrals" )
        self.neutrals = 0
        self.bonus_gpt = 0
        ListenToGameEvent('capture_neutral', self.OnCaptureNeutral, self)
    end
end

function modifier_pirates_race_bonus_neutrals:OnDestroy()
    if IsServer() then
        StopListeningToAllGameEvents(self)
    end
end

function modifier_pirates_race_bonus_neutrals:OnCaptureNeutral(event)
    if self.team == event.old_team then
        self.neutrals = self.neutrals - 1
    end
    if self.team == event.new_team then
        self.neutrals = self.neutrals + 1
	end
    local works_neutrals = (math.min(self.neutrals, self.max_neutrals))
	local caster = self:GetCaster()
	local id = caster:GetPlayerOwnerID()
	local gpt = self:GetAbility():GetLevelSpecialValueFor("gpt", self:GetAbility():GetLevel() - 1)
	caster.gpt = caster.gpt - self.bonus_gpt + (gpt * works_neutrals)
	_G.playersinfo[id].gpt = _G.playersinfo[id].gpt - self.bonus_gpt + (gpt * works_neutrals)
	self.bonus_gpt = gpt * works_neutrals
end

function modifier_pirates_race_bonus_neutrals:IsHidden()
    return true
end

function modifier_pirates_race_bonus_neutrals:RemoveOnDeath()
    return false
end

function modifier_pirates_race_bonus_neutrals:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end

--------------------------------------------------------------------------------

--function CostRed(keys)
--    local target = keys.target
--    local ability = keys.ability
--    local cost_red = ability:GetSpecialValueFor( "cost_red" )
--
--    target:SetMinimumGoldBounty( target:GetMinimumGoldBounty() - cost_red )
--    target:SetMaximumGoldBounty( target:GetMaximumGoldBounty() - cost_red )
--end

function OnKill(keys)
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local gold_1 = ability:GetSpecialValueFor( "gold_1" )
    local gold_2 = ability:GetSpecialValueFor( "gold_2" )
    local chance_1 = ability:GetSpecialValueFor( "chance_1" )
    local id = caster:GetPlayerOwnerID()

    -- PlayerResource:ModifyGold(id, gold_1, false, DOTA_ModifyGold_CreepKill)
    if RollPercentage(chance_1) then
	    PlayerResource:ModifyGold(id, gold_1, false, DOTA_ModifyGold_CreepKill)
    else
	    PlayerResource:ModifyGold(id, gold_2, false, DOTA_ModifyGold_CreepKill)
    end
end