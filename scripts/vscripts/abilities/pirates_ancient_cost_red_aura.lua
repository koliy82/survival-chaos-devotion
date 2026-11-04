LinkLuaModifier( "modifier_pirates_ancient_cost_red_aura", "abilities/pirates_ancient_cost_red_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pirates_ancient_cost_red_aura_buff", "abilities/pirates_ancient_cost_red_aura", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

pirates_ancient_cost_red_aura = class ({})

function pirates_ancient_cost_red_aura:GetIntrinsicModifierName()
	return "modifier_pirates_ancient_cost_red_aura"
end

--------------------------------------------------------------------------------

modifier_pirates_ancient_cost_red_aura = class({})

function modifier_pirates_ancient_cost_red_aura:IsHidden()
	return true
end

function modifier_pirates_ancient_cost_red_aura:IsAura()
	return true
end

function modifier_pirates_ancient_cost_red_aura:GetAuraRadius()
	return 9999999
end

function modifier_pirates_ancient_cost_red_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_pirates_ancient_cost_red_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_pirates_ancient_cost_red_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_pirates_ancient_cost_red_aura:GetModifierAura()
    return "modifier_pirates_ancient_cost_red_aura_buff"
end

--------------------------------------------------------------------------------

modifier_pirates_ancient_cost_red_aura_buff = class({})

function modifier_pirates_ancient_cost_red_aura_buff:IsHidden()
	return false
end

function modifier_pirates_ancient_cost_red_aura_buff:OnCreated(event)
    local ability = self:GetAbility()
    self.damage = ability:GetLevelSpecialValueFor("damage", 0)
    self.armor = ability:GetLevelSpecialValueFor("armor", 0)
    -- self.regen = ability:GetLevelSpecialValueFor("regen", 0)
    self.mana_regen = ability:GetLevelSpecialValueFor("mana_regen", 0)
    -- self.ats = ability:GetLevelSpecialValueFor("ats", 0)
    self.cdr = ability:GetLevelSpecialValueFor("cdr", 0)
    if IsServer() then
        local parent = self:GetParent()
        if parent:IsCustomHero() then
            self:SetStackCount(1)
        end
    end
end

function modifier_pirates_ancient_cost_red_aura_buff:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        -- MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        -- MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
	}

	return funcs
end

function modifier_pirates_ancient_cost_red_aura_buff:GetModifierDamageOutgoing_Percentage( params )
    return self:GetStackCount()*self.damage
end

function modifier_pirates_ancient_cost_red_aura_buff:GetModifierPhysicalArmorBonus( params )
    return self:GetStackCount()*self.armor
end

-- function modifier_pirates_ancient_cost_red_aura_buff:GetModifierConstantHealthRegen( params )
--     return self:GetStackCount()*self.regen
-- end

function modifier_pirates_ancient_cost_red_aura_buff:GetModifierConstantManaRegen( params )
    return self:GetStackCount()*self.mana_regen
end

-- function modifier_pirates_ancient_cost_red_aura_buff:GetModifierAttackSpeedBonus_Constant( params )
--     return self:GetStackCount()*self.ats
-- end

function modifier_pirates_ancient_cost_red_aura_buff:GetModifierPercentageCooldown( params )
    return self:GetStackCount()*self.cdr
end

function OnCreated(event)
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    for k, v in pairs(_G.playersinfo[id].baracks) do
        v:FindAbilityByName("spawn_hero_pirates_tank"):SetLevel(2)
        v:FindAbilityByName("spawn_hero_pirates_mage"):SetLevel(2)
        v:FindAbilityByName("spawn_hero_pirates_asassin"):SetLevel(2)
        v:FindAbilityByName("spawn_hero_pirates_pusher"):SetLevel(2)
    end
end

--    local target = event.target
--    local ability = event.ability
--    local cost_red = ability:GetSpecialValueFor( "cost_red" )
--
--    ability.min_bounty = target:GetMinimumGoldBounty()
--    ability.max_bounty = target:GetMaximumGoldBounty()
--
--    target:SetMinimumGoldBounty(ability.min_bounty * ( 1 - cost_red / 100 ))
--    target:SetMaximumGoldBounty(ability.max_bounty * ( 1 - cost_red / 100 ))
--end
--
--function OnDestroy(event)
--    local target = event.target
--    local ability = event.ability
--
--    target:SetMinimumGoldBounty(ability.min_bounty)
--    target:SetMaximumGoldBounty(ability.max_bounty)
--end