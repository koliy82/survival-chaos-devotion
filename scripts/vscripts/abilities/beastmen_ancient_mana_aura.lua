LinkLuaModifier( "modifier_beastmen_ancient_mana_aura", "abilities/beastmen_ancient_mana_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_beastmen_ancient_mana_aura_barack", "abilities/beastmen_ancient_mana_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_beastmen_ancient_mana_aura_buff", "abilities/beastmen_ancient_mana_aura", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

beastmen_ancient_mana_aura = class ({})

function beastmen_ancient_mana_aura:GetIntrinsicModifierName()
	return "modifier_beastmen_ancient_mana_aura"
end

--------------------------------------------------------------------------------

modifier_beastmen_ancient_mana_aura = class({})

function modifier_beastmen_ancient_mana_aura:IsHidden()
	return true
end

function modifier_beastmen_ancient_mana_aura:OnCreated(event)
    if IsServer() then
        self.caster = self:GetCaster()
        self.owner_id = self.caster:GetPlayerOwnerID()
        ListenToGameEvent('entity_killed', self.OnEntityKilled, self)
    end
end

function modifier_beastmen_ancient_mana_aura:OnDestroy()
    if IsServer() then
        StopListeningToAllGameEvents(self)
    end
end

function modifier_beastmen_ancient_mana_aura:OnEntityKilled(event)
    local killedUnit = EntIndexToHScript( event.entindex_killed )
    local killerEntity = nil
	if event.entindex_attacker ~= nil then
        killerEntity = EntIndexToHScript( event.entindex_attacker )
    else
        return
	end
	
	if killedUnit and killedUnit:IsCustomHero() and killerEntity then
        local id = killerEntity:GetPlayerOwnerID()
        if self.owner_id == id then
            self.caster:GiveMana(self:GetAbility():GetSpecialValueFor("mana_per_kill"))
        end
	end
end

function modifier_beastmen_ancient_mana_aura:IsAura()
	return true
end

function modifier_beastmen_ancient_mana_aura:GetAuraRadius()
	return 9999999
end

function modifier_beastmen_ancient_mana_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_beastmen_ancient_mana_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_beastmen_ancient_mana_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_beastmen_ancient_mana_aura:GetModifierAura()
    return "modifier_beastmen_ancient_mana_aura_buff"
end

--------------------------------------------------------------------------------

modifier_beastmen_ancient_mana_aura_buff = class({})

function modifier_beastmen_ancient_mana_aura_buff:IsHidden()
	return false
end

function modifier_beastmen_ancient_mana_aura_buff:OnCreated(event)
    local ability = self:GetAbility()
    self.truesight_range = ability:GetSpecialValueFor("truesight_range")
    if IsServer() then
        local parent = self:GetParent()
        if parent:IsAncient() then
            if parent == self:GetCaster() then
                self:SetStackCount(ability:GetSpecialValueFor("bonus_ancient_mana_regen")*-10)
            end
            self.aura = true
        else
            self.aura = false
            --if parent:IsCustomHero() then
            --    self:SetStackCount(ability:GetSpecialValueFor("bonus_hero_mana_regen")*-10)
            --else
            --    self:SetStackCount(ability:GetSpecialValueFor("bonus_creep_mana_regen")*-10)
            --end
        end
    end
end

function modifier_beastmen_ancient_mana_aura_buff:IsAura()
	return self.aura
end

function modifier_beastmen_ancient_mana_aura_buff:GetAuraRadius()
	return self.truesight_range
end

function modifier_beastmen_ancient_mana_aura_buff:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_beastmen_ancient_mana_aura_buff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_beastmen_ancient_mana_aura_buff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_beastmen_ancient_mana_aura_buff:GetModifierAura()
    return "modifier_truesight"
end

function modifier_beastmen_ancient_mana_aura_buff:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT
	}

	return funcs
end

function modifier_beastmen_ancient_mana_aura_buff:GetModifierConstantManaRegen( params )
    return self:GetStackCount()*-1/10
end
