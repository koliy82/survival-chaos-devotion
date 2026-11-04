LinkLuaModifier( "modifier_beastmen_race_bonus", "abilities/beastmen_race_bonus", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_beastmen_race_bonus_barack", "abilities/beastmen_race_bonus", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_beastmen_race_bonus_buff", "abilities/beastmen_race_bonus", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_beastmen_ancient_bonus_priority_buff", "abilities/beastmen_race_bonus", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_beastmen_race_bonus_barack_aura", "abilities/beastmen_race_bonus", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

beastmen_race_bonus = class ({})

function beastmen_race_bonus:GetIntrinsicModifierName()
	return "modifier_beastmen_race_bonus"
end

beastmen_ancient_race_bonus_priority = class ({})

function beastmen_ancient_race_bonus_priority:GetIntrinsicModifierName()
	return "modifier_beastmen_ancient_bonus_priority_buff"
end

--------------------------------------------------------------------------------

modifier_beastmen_race_bonus = class({})

function modifier_beastmen_race_bonus:IsHidden()
	return true
end

function modifier_beastmen_race_bonus:OnCreated(event)
    if IsServer() then
        local caster = self:GetCaster()
        local ability = self:GetAbility()
        local id = caster:GetPlayerOwnerID()
        local baracks = {}
        for _,barack in pairs(_G.playersinfo[id].baracks) do
            barack:AddNewModifier(caster, self:GetAbility(), "modifier_beastmen_race_bonus_barack_aura", {})
            table.insert( baracks, barack )
        end
        local new_target_num = RandomInt(1, #baracks)
        local mod_target = baracks[new_target_num]
        mod_target:AddNewModifier(caster, self:GetAbility(), "modifier_beastmen_race_bonus_barack", {})
        local timer = 240
        Timers:CreateTimer(timer - GameRules:GetDOTATime(false, true), function()
            mod_target:RemoveModifierByName("modifier_beastmen_race_bonus_barack")
            baracks = {}
            local old_alive = false
            local priority = nil
            for _,barack in pairs(_G.playersinfo[id].baracks) do
                if barack == mod_target then
                    old_alive = true
                else
                    table.insert( baracks, barack )
                end
                if barack == ability.priority then
                    priority = barack
                end
            end
            if #baracks == 0 then
                if old_alive then
                    mod_target:AddNewModifier(caster, self:GetAbility(), "modifier_beastmen_race_bonus_barack", {})
                end
            elseif #baracks == 1 then
                mod_target = baracks[1]
                mod_target:AddNewModifier(caster, self:GetAbility(), "modifier_beastmen_race_bonus_barack", {})
            elseif #baracks > 1 then
                if priority and priority ~= mod_target then
                    mod_target = priority
                    mod_target:AddNewModifier(caster, self:GetAbility(), "modifier_beastmen_race_bonus_barack", {})
                else
                    new_target_num = RandomInt(1, #baracks)
                    mod_target = baracks[new_target_num]
                    mod_target:AddNewModifier(caster, self:GetAbility(), "modifier_beastmen_race_bonus_barack", {})
                end
            end
            return timer
        end)
    end
end

--------------------------------------------------------------------------------

modifier_beastmen_race_bonus_barack_aura = class({})

function modifier_beastmen_race_bonus_barack_aura:IsHidden()
	return true
end

function modifier_beastmen_race_bonus_barack_aura:OnCreated(event)
    if IsServer() then
        ListenToGameEvent('custom_spawn_unit', self.OnSpawnUnit, self)
    end
end

function modifier_beastmen_race_bonus_barack_aura:OnDestroy()
    if IsServer() then
        StopListeningToAllGameEvents(self)
    end
end

function modifier_beastmen_race_bonus_barack_aura:OnSpawnUnit(event)
    local spawner_unit = EntIndexToHScript(event.spawner_unit)
    if self:GetParent() == spawner_unit then
        local caster = self:GetCaster()
        local unit = EntIndexToHScript(event.unit)
        if caster and unit and caster:HasAbility("beastmen_ancient_regen_aura") and unit:IsCustomHero() then
            unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_beastmen_race_bonus_buff", {})
        end
    end
end

--------------------------------------------------------------------------------

modifier_beastmen_race_bonus_barack = class({})

function modifier_beastmen_race_bonus_barack:IsHidden()
	return false
end

function modifier_beastmen_race_bonus_barack:GetEffectName()
    return "particles/econ/items/centaur/centaur_2022_immortal/centaur_2022_immortal_stampede_overhead.vpcf"
end

function modifier_beastmen_race_bonus_barack:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

function modifier_beastmen_race_bonus_barack:OnCreated(event)
    if IsServer() then
        ListenToGameEvent('custom_spawn_unit', self.OnSpawnUnit, self)
    end
end

function modifier_beastmen_race_bonus_barack:OnDestroy()
    if IsServer() then
        StopListeningToAllGameEvents(self)
    end
end

function modifier_beastmen_race_bonus_barack:OnSpawnUnit(event)
    local spawner_unit = EntIndexToHScript(event.spawner_unit)
    if self:GetParent() == spawner_unit then
        local caster = self:GetCaster()
        local unit = EntIndexToHScript(event.unit)
        if not unit:IsCustomHero() then
            unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_beastmen_race_bonus_buff", {})
        else
            if not caster:HasAbility("beastmen_ancient_regen_aura") then
                unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_beastmen_race_bonus_buff", {})
            end
        end
        if caster:HasAbility("beastmen_ancient_race_bonus_priority") then
            unit:AddNewModifier(self:GetCaster(), caster:FindAbilityByName("beastmen_ancient_race_bonus_priority"), "modifier_beastmen_ancient_bonus_priority_buff", {})
        end
    end
end

--------------------------------------------------------------------------------

modifier_beastmen_race_bonus_buff = class({})

function modifier_beastmen_race_bonus_buff:IsHidden()
	return false
end

function modifier_beastmen_race_bonus_buff:IsPurgable()
	return false
end

function modifier_beastmen_race_bonus_buff:OnCreated(event)
    local ability = self:GetAbility()
    if ability and not ability:IsNull() then
        self.armor = ability:GetLevelSpecialValueFor("armor", self:GetCaster():GetModifierStackCount("modifier_beastmen_race_bonus", self:GetCaster()))
        self.damage = ability:GetLevelSpecialValueFor("damage", self:GetCaster():GetModifierStackCount("modifier_beastmen_race_bonus", self:GetCaster()))
        self.ats = ability:GetLevelSpecialValueFor("ats", self:GetCaster():GetModifierStackCount("modifier_beastmen_race_bonus", self:GetCaster()))
        self.evasion = ability:GetLevelSpecialValueFor("evasion", self:GetCaster():GetModifierStackCount("modifier_beastmen_race_bonus", self:GetCaster()))
        self.regen = ability:GetLevelSpecialValueFor("regen", self:GetCaster():GetModifierStackCount("modifier_beastmen_race_bonus", self:GetCaster()))
        self.mana_regen = ability:GetLevelSpecialValueFor("mana_regen", self:GetCaster():GetModifierStackCount("modifier_beastmen_race_bonus", self:GetCaster()))
        self.cd_red = ability:GetLevelSpecialValueFor("cd_red", self:GetCaster():GetModifierStackCount("modifier_beastmen_race_bonus", self:GetCaster()))
    end
end

function modifier_beastmen_race_bonus_buff:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_EVASION_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE
	}

	return funcs
end

function modifier_beastmen_race_bonus_buff:GetModifierPhysicalArmorBonus( params )
    return self.armor
end

function modifier_beastmen_race_bonus_buff:GetModifierDamageOutgoing_Percentage( params )
    return self.damage
end

function modifier_beastmen_race_bonus_buff:GetModifierAttackSpeedBonus_Constant( params )
    return self.ats
end

function modifier_beastmen_race_bonus_buff:GetModifierEvasion_Constant( params )
    return self.evasion
end

function modifier_beastmen_race_bonus_buff:GetModifierConstantHealthRegen( params )
    return self.regen
end

function modifier_beastmen_race_bonus_buff:GetModifierConstantManaRegen( params )
    return self.mana_regen
end

function modifier_beastmen_race_bonus_buff:GetModifierPercentageCooldown( params )
    return self.cd_red
end

--------------------------------------------------------------------------------

modifier_beastmen_ancient_bonus_priority_buff = class({})

function modifier_beastmen_ancient_bonus_priority_buff:IsHidden()
	return true
end

function modifier_beastmen_ancient_bonus_priority_buff:IsPurgable()
	return false
end

function modifier_beastmen_ancient_bonus_priority_buff:OnCreated(event)
    local ability = self:GetAbility()
    if ability and not ability:IsNull() then
        self.armor = ability:GetLevelSpecialValueFor("armor", self:GetCaster():GetModifierStackCount("modifier_beastmen_race_bonus", self:GetCaster()))
        self.ats = ability:GetLevelSpecialValueFor("ats", self:GetCaster():GetModifierStackCount("modifier_beastmen_race_bonus", self:GetCaster()))
        self.regen = ability:GetLevelSpecialValueFor("regen", self:GetCaster():GetModifierStackCount("modifier_beastmen_race_bonus", self:GetCaster()))
        
    end
end

function modifier_beastmen_ancient_bonus_priority_buff:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT     
	}

	return funcs
end

function modifier_beastmen_ancient_bonus_priority_buff:GetModifierPhysicalArmorBonus( params )
    return self.armor
end

function modifier_beastmen_ancient_bonus_priority_buff:GetModifierAttackSpeedBonus_Constant( params )
    return self.ats
end

function modifier_beastmen_ancient_bonus_priority_buff:GetModifierConstantHealthRegen( params )
    return self.regen
end
