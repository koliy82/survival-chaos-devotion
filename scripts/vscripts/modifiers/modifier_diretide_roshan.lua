LinkLuaModifier( "modifier_diretide_roshan_barrack", "modifiers/modifier_diretide_roshan", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_diretide_roshan_barrack_debuff", "modifiers/modifier_diretide_roshan", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_diretide_roshan_barrack_curse", "modifiers/modifier_diretide_roshan", LUA_MODIFIER_MOTION_NONE )

modifier_diretide_roshan = class({})

function modifier_diretide_roshan:OnCreated( params )
    if IsServer() then
        self.parent = self:GetParent()
        Timers:CreateTimer(0.1, function()
            self:SetStackCount(_G.diretide.diretide_race_count)
        end)
	end
	self.damage_table = {20, -10, -40, -10}
	self.bonus_damage_table = {20, 16, 12, 16}
	self.speed_table = {275, 225, 175, 175}
	self.speed = 100
	self:StartIntervalThink(1)
end

function modifier_diretide_roshan:IsHidden()
	return true
end

function modifier_diretide_roshan:OnIntervalThink()
	local stacks = self:GetStackCount()
	self.bonus_damage = math.floor(GameRules:GetDOTATime(false, false) / 180) * self.bonus_damage_table[stacks] + self.damage_table[stacks]
	self.speed = self.speed_table[stacks]
end

function modifier_diretide_roshan:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE
	}
	return funcs
end

function modifier_diretide_roshan:GetModifierBaseAttack_BonusDamage()
    return self.bonus_damage
end

function modifier_diretide_roshan:GetModifierMoveSpeedOverride()
    return self.speed
end

function modifier_diretide_roshan:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_DISARMED] = IsClient() or not self.parent.can_attack,
		-- [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		-- [MODIFIER_STATE_UNSELECTABLE] = true
	}
end

modifier_diretide_roshan_barrack = class({})

function modifier_diretide_roshan_barrack:IsHidden()
    return false
end

function modifier_diretide_roshan_barrack:IsDebuff()
    return true
end

function modifier_diretide_roshan_barrack:GetEffectName()
    return "particles/hw_fx/candy_carrying_overhead_candy.vpcf"
end

function modifier_diretide_roshan_barrack:GetEffectAttachType()
    return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

modifier_diretide_roshan_truesight = class({})

function modifier_diretide_roshan_truesight:IsHidden()
	return true
end

function modifier_diretide_roshan_truesight:IsAura()
	return true
end

function modifier_diretide_roshan_truesight:GetAuraRadius()
	return 500
end

function modifier_diretide_roshan_truesight:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_diretide_roshan_truesight:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_diretide_roshan_truesight:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_diretide_roshan_truesight:GetModifierAura()
    return "modifier_truesight"
end

--------------------------------------------------------------------------------

modifier_diretide_roshan_barrack_curse = class({})

function modifier_diretide_roshan_barrack_curse:IsHidden()
	return false
end

function modifier_diretide_roshan_barrack_curse:OnCreated(event)
    if IsServer() then
        ListenToGameEvent('custom_spawn_unit', self.OnSpawnUnit, self)
    end
end

function modifier_diretide_roshan_barrack_curse:OnDestroy()
    if IsServer() then
        StopListeningToAllGameEvents(self)
    end
end

function modifier_diretide_roshan_barrack_curse:OnSpawnUnit(event)
    local spawner_unit = EntIndexToHScript(event.spawner_unit)
    if self:GetParent() == spawner_unit then
        local caster = self:GetCaster()
        local unit = EntIndexToHScript(event.unit)
        if not unit:IsCustomHero() then
            unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_diretide_roshan_barrack_debuff", {})
        end
    end
end

--------------------------------------------------------------------------------

modifier_diretide_roshan_barrack_debuff = class({})

function modifier_diretide_roshan_barrack_debuff:IsHidden()
	return false
end

function modifier_diretide_roshan_barrack_debuff:IsPurgable()
	return false
end

function modifier_diretide_roshan_barrack_debuff:OnCreated(event)
	self.armor = -4
	self.ats = -10
end

function modifier_diretide_roshan_barrack_debuff:DeclareFunctions()
	local funcs = 
	{
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}

	return funcs
end

function modifier_diretide_roshan_barrack_debuff:GetModifierPhysicalArmorBonus( params )
    return self.armor
end

function modifier_diretide_roshan_barrack_debuff:GetModifierAttackSpeedBonus_Constant( params )
    return self.ats
end