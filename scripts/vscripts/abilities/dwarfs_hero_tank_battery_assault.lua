if not dwarfs_hero_tank_battery_assault then 
	LinkLuaModifier("modifier_dwarfs_hero_tank_battery_assault", "abilities/dwarfs_hero_tank_battery_assault", LUA_MODIFIER_MOTION_NONE)
	dwarfs_hero_tank_battery_assault = class({
		OnSpellStart = function(self)
			local caster = self.GetCaster(self)
			caster:AddNewModifier(caster, self, "modifier_dwarfs_hero_tank_battery_assault", {duration = self.GetSpecialValueFor(self,"duration")})
		end
	})
	modifier_dwarfs_hero_tank_battery_assault = class({
		IsPurgable = function() return false end,
		OnCreated = function(self)
			if IsClient() then return end
		    self.ability = self.GetAbility(self)
		    self.damage = self.ability:GetAbilityDamage()
		    self.radius = self.ability:GetSpecialValueFor("radius")
		    self.stun_duration = self.ability:GetSpecialValueFor("stun_duration")
		    self.StartIntervalThink(self, self.ability:GetSpecialValueFor("interval") )
		end,
		OnRefresh = function(self)
			self.OnCreated(self)
		end,
		OnIntervalThink = function(self)
			if IsClient() then return end
		    local parent = self.GetParent(self)
		    local parentPos = parent:GetAbsOrigin()
		    local enemies = FindUnitsInRadius(parent:GetTeamNumber(), 
		    parentPos, 
		    nil, 
		    self.radius, 
		    DOTA_UNIT_TARGET_TEAM_ENEMY, 
		    DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		    DOTA_UNIT_TARGET_FLAG_NONE, 
		    FIND_ANY_ORDER, 
		    false)
		    local valid = {}
		    for i,v in ipairs(enemies) do
		    	if not v:HasAbility("unit_building_core") then
		    		table.insert(valid, v)
		    	end
		    end
		    
		    local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_battery_assault.vpcf", PATTACH_POINT_FOLLOW,parent)
		    ParticleManager:SetParticleControl(nfx, 1, parentPos)
		    ParticleManager:ReleaseParticleIndex(nfx)
		    EmitSoundOn( "Hero_Rattletrap.Battery_Assault_Launch", parent )
		    local enemy = valid[RandomInt(1,#valid)]
		    if not enemy then return end
			local targetPos = enemy:GetAbsOrigin()
			
		    enemy:AddNewModifier(parent,self.ability,'modifier_stunned',{duration = self.stun_duration})
    		ApplyCustomDamage(enemy, parent, self.damage, 1)

		    local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_rattletrap/rattletrap_battery_shrapnel.vpcf", PATTACH_POINT_FOLLOW, parent)
		    ParticleManager:SetParticleControl(nfx, 1, targetPos)
		    ParticleManager:ReleaseParticleIndex(nfx)
		    EmitSoundOn( "Hero_Rattletrap.Battery_Assault_Impact", enemy )
		end,
	})
end