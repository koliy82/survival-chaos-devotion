if not dwarfs_hero_tank_plazmasphere then
	LinkLuaModifier("modifier_dwarfs_hero_tank_plazmasphere_aura", "abilities/dwarfs_hero_tank_plazmasphere", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_dwarfs_hero_tank_plazmasphere", "abilities/dwarfs_hero_tank_plazmasphere", LUA_MODIFIER_MOTION_NONE)
	dwarfs_hero_tank_plazmasphere = class({})
	function dwarfs_hero_tank_plazmasphere:OnSpellStart()
		local caster = self:GetCaster()
		local duration = self:GetSpecialValueFor("duration")
		local thinker = CreateModifierThinker(caster, self, "modifier_dwarfs_hero_tank_plazmasphere_aura", {duration = duration}, caster:GetOrigin(), caster:GetTeam(), false)
		thinker:EmitSound("Hero_ArcWarden.MagneticField")
		thinker:EmitSound("Hero_ArcWarden.SparkWraith.Cast")
		local radius = self:GetSpecialValueFor("radius")
        local nFXIndex1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_magnetic.vpcf", PATTACH_ABSORIGIN, thinker )
        ParticleManager:SetParticleControl( nFXIndex1, 0, thinker:GetOrigin() )
        ParticleManager:SetParticleControl( nFXIndex1, 1, Vector( radius, radius, radius ) )
        Timers:CreateTimer(duration-.1,function()
            ParticleManager:DestroyParticle(nFXIndex1, false)
            thinker:StopSound("Hero_ArcWarden.MagneticField")
        end)
	end
end
if not modifier_dwarfs_hero_tank_plazmasphere_aura then
	if IsServer() then
		modifier_dwarfs_hero_tank_plazmasphere_aura = class({
			IsAura = function() return true end,
			IsHidden = function() return true end,
			IsPurgable = function() return false end,
			GetAuraRadius = function(self) return self.radius end,
			GetAuraSearchFlags = function(self) return self.flags end,
			GetAuraSearchTeam = function(self) return self.team end,
			GetAuraSearchType = function(self) return self.type end,
			GetModifierAura = function(self) return "modifier_dwarfs_hero_tank_plazmasphere" end
		})
		function modifier_dwarfs_hero_tank_plazmasphere_aura:OnCreated(t)
				self.ability = self:GetAbility()
				self.armor = self.ability:GetSpecialValueFor("armor")
				self.radius = self.ability:GetSpecialValueFor("radius")
				self.flags = self.ability:GetAbilityTargetFlags()
				self.team = self.ability:GetAbilityTargetTeam()
				self.type = self.ability:GetAbilityTargetType()
		end
	else
		modifier_dwarfs_hero_tank_plazmasphere_aura = class({
			IsHidden = function() return true end,
		})
	end
end
if not modifier_dwarfs_hero_tank_plazmasphere then
	modifier_dwarfs_hero_tank_plazmasphere = class({
		IsHidden = function() return false end,
		GetTexture = function(self) return "arc_warden_magnetic_field" end,
		DeclareFunctions = function() return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS} end,
		GetModifierPhysicalArmorBonus = function(self) return -self:GetStackCount() end
	})
	function modifier_dwarfs_hero_tank_plazmasphere:OnCreated(t)
		if IsServer() then
			self:SetStackCount(-self:GetAuraOwner():FindModifierByName("modifier_dwarfs_hero_tank_plazmasphere_aura").armor)
		end
	end
end