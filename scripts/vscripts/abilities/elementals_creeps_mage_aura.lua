LinkLuaModifier( "modifier_elementals_creeps_mage_aura", "abilities/elementals_creeps_mage_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_elementals_creeps_mage_aura_buff", "abilities/elementals_creeps_mage_aura", LUA_MODIFIER_MOTION_NONE )

elementals_creeps_mage_aura = class ({})

--------------------------------------------------------------------------------

function elementals_creeps_mage_aura:GetIntrinsicModifierName()
	return "modifier_elementals_creeps_mage_aura"
end

--------------------------------------------------------------------------------

modifier_elementals_creeps_mage_aura = class({})

--------------------------------------------------------------------------------

function modifier_elementals_creeps_mage_aura:IsHidden()
	return true
end

function modifier_elementals_creeps_mage_aura:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_elementals_creeps_mage_aura:OnAbilityExecuted( keys )
	local ability = self:GetAbility()
    local caster = self:GetParent()
    local ability_level = ability:GetLevel()
    if ability_level > 0 and ability:IsCooldownReady() and caster:GetMana() >= ability:GetManaCost(ability_level - 1) then
        local cd_need = ability:GetLevelSpecialValueFor("cd_need", ability_level-1)
        local abil1 = caster:FindAbilityByName("elementals_creeps_mage_electric_vortex")
        local abil2 = caster:FindAbilityByName("elementals_creeps_mage_eye_storm")
        --if abil1 and abil2 then
            Timers:CreateTimer(0.01, function()
                if abil1 and abil2 and abil1:GetCooldownTimeRemaining() >= cd_need and abil2:GetCooldownTimeRemaining() >= cd_need then
                    local cd_minus = ability:GetLevelSpecialValueFor("cd_minus", ability_level-1)
                    local mana_recov = ability:GetLevelSpecialValueFor("mana_recov", ability_level-1)
                    local cd_remain = abil1:GetCooldownTimeRemaining()
                    abil1:EndCooldown()
                    abil1:StartCooldown(cd_remain - cd_minus)
                    cd_remain = abil2:GetCooldownTimeRemaining()
                    abil2:EndCooldown()
                    abil2:StartCooldown(cd_remain - cd_minus)
                    caster:GiveMana(mana_recov)
                    ability:StartCooldown(ability:GetEffectiveCooldown(ability_level))
                    caster:SpendMana(ability:GetManaCost(ability_level - 1), ability)
                end
            end)
        --end
    end
end

function modifier_elementals_creeps_mage_aura:IsAura()
	return true
end

function modifier_elementals_creeps_mage_aura:GetAuraRadius()
	return 600
end

function modifier_elementals_creeps_mage_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
end

function modifier_elementals_creeps_mage_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_elementals_creeps_mage_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_elementals_creeps_mage_aura:GetModifierAura()
    if IsServer() then return "modifier_elementals_creeps_mage_aura_buff" end
end

--------------------------------------------------------------------------------

modifier_elementals_creeps_mage_aura_buff = class({})

function modifier_elementals_creeps_mage_aura_buff:IsHidden()
	if self:GetParent():GetUnitName() == "npc_dota_elementals_mage" then
		return true
	else
		return false
    end
end

function modifier_elementals_creeps_mage_aura_buff:OnCreated( params ) --kv
	self.cd_red = self:GetAbility():GetSpecialValueFor( "cd_red" )
	self.mana_regen = self:GetAbility():GetSpecialValueFor( "mana_regen" )

	if IsServer() and self:GetParent():GetUnitName() ~= "npc_dota_elementals_mage" then
        self:SetStackCount(1)
    end

end

function modifier_elementals_creeps_mage_aura_buff:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}

	return funcs
end

function modifier_elementals_creeps_mage_aura_buff:GetModifierPercentageCooldown( params )
    return self.cd_red * self:GetStackCount()
end

function modifier_elementals_creeps_mage_aura_buff:GetModifierConstantManaRegen( params )
    return self.mana_regen * self:GetStackCount()
end