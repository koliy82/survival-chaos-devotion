LinkLuaModifier("modifier_frostivus_hero_mage_ice_walls_aura", "abilities/frostivus_hero_mage_ice_walls", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_frostivus_hero_mage_ice_walls", "abilities/frostivus_hero_mage_ice_walls", LUA_MODIFIER_MOTION_NONE)
function OnSpellStart( event )
	local caster = event.caster
    local ability = event.ability
    local forward = caster:GetForwardVector()
    local point = caster:GetAbsOrigin()
	local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )
	local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )

    local thinker = CreateModifierThinker(caster, ability, "modifier_frostivus_hero_mage_ice_walls_aura", {duration = duration}, point + forward * radius / 2, caster:GetTeam(), false)
    
    local pfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall_b.vpcf", PATTACH_ABSORIGIN, caster )
    ParticleManager:SetParticleControl(pfx1, 1, point + forward * radius)
    local new_direction = (RotatePosition(Vector(0, 0, 0), QAngle(0, -45, 0), forward)):Normalized()
    local pfx2 = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall_b.vpcf", PATTACH_ABSORIGIN, caster )
    ParticleManager:SetParticleControl(pfx2, 1, point + new_direction * (radius * 0.85))
    new_direction = (RotatePosition(Vector(0, 0, 0), QAngle(0, 45, 0), forward)):Normalized()
    local pfx3 = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_ice_wall_b.vpcf", PATTACH_ABSORIGIN, caster )
    ParticleManager:SetParticleControl(pfx3, 1, point + new_direction * (radius * 0.85))

    local mod = thinker:FindModifierByName("modifier_frostivus_hero_mage_ice_walls_aura")

    mod:AddParticle(pfx1, false, false, 0, false, false)
    mod:AddParticle(pfx2, false, false, 0, false, false)
    mod:AddParticle(pfx3, false, false, 0, false, false)
end

if IsServer() then
	modifier_frostivus_hero_mage_ice_walls_aura = class({
		IsAura = function() return true end,
		IsHidden = function() return true end,
		GetAuraRadius = function(self) return self.radius end,
		GetAuraSearchFlags = function(self) return self.flags end,
		GetAuraSearchTeam = function(self) return self.team end,
		GetAuraSearchType = function(self) return self.type end,
		GetModifierAura = function(self) return "modifier_frostivus_hero_mage_ice_walls" end
	})
	function modifier_frostivus_hero_mage_ice_walls_aura:OnCreated(t)
		self.ability = self:GetAbility()
		self.radius = self.ability:GetSpecialValueFor("radius")/2
		self.flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
		self.team = DOTA_UNIT_TARGET_TEAM_ENEMY
		self.type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	end
else
	modifier_frostivus_hero_mage_ice_walls_aura = class({
		IsHidden = function() return true end,
	})
end

modifier_frostivus_hero_mage_ice_walls = class({
	IsHidden = function() return false end,
	IsDebuff = function() return true end,
	-- GetTexture = function(self) return "arc_warden_magnetic_field" end,
	DeclareFunctions = function() return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    } end,
	GetModifierMoveSpeedBonus_Percentage = function(self) return self.move_slow end
})
function modifier_frostivus_hero_mage_ice_walls:OnCreated(t)
    self.ability = self:GetAbility()
    self.move_slow = self.ability:GetSpecialValueFor("move_slow")
    if IsServer() then
        self.damage = self.ability:GetSpecialValueFor("damage")
        self:StartIntervalThink(self.ability:GetSpecialValueFor("think_interval"))
    end
end
function modifier_frostivus_hero_mage_ice_walls:OnIntervalThink()
    if IsServer() then
        ApplyCustomDamage(self:GetParent(), self:GetCaster(), self.damage, 6, self.ability)
    end
end