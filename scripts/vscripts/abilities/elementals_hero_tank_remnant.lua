LinkLuaModifier( "modifier_elementals_hero_tank_remnant", "abilities/elementals_hero_tank_remnant", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_elementals_hero_tank_remnant_kick", "abilities/elementals_hero_tank_remnant", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_elementals_hero_tank_remnant_slow_move", "abilities/elementals_hero_tank_remnant", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_elementals_hero_tank_remnant_slow_attack", "abilities/elementals_hero_tank_remnant", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_elementals_hero_tank_remnant_damage_red", "abilities/elementals_hero_tank_remnant", LUA_MODIFIER_MOTION_NONE )

elementals_hero_tank_remnant = {}

function elementals_hero_tank_remnant:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCaster():GetAbsOrigin()+ (5 * self:GetCaster():GetForwardVector())
	local duration = self:GetSpecialValueFor("duration")
	local stone = CreateUnitByName( "npc_dota_earth_spirit_stone", point, true, nil, nil, self:GetCaster():GetTeamNumber() )

	stone:AddNewModifier(
		caster,
		self,
		"modifier_elementals_hero_tank_remnant",
		nil
	)

	stone:AddNewModifier(
		caster,
		self,
		"modifier_elementals_hero_tank_remnant",
		{ duration = 1 }
	)
	
	local dirX = point.x-caster:GetAbsOrigin().x
	local dirY = point.y-caster:GetAbsOrigin().y
	
	self:Kick( stone, dirX, dirY, true )
end

function elementals_hero_tank_remnant:Kick( target, x, y, isRemnant )
	local damage = self:GetSpecialValueFor("damage")
	local radius = self:GetSpecialValueFor("radius")
	local speed = self:GetSpecialValueFor("speed")
	local distance = self:GetSpecialValueFor("rock_distance")

	local mod = target:AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_elementals_hero_tank_remnant_kick",
		{
			x = x,
			y = y,
			r = distance,
		}
	)

	local info = {
		Source = self:GetCaster(),
		Ability = self,
		vSpawnOrigin = target:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = "",
	    fDistance = distance,
	    fStartRadius = radius,
	    fEndRadius =radius,
		vVelocity = Vector(x,y,0):Normalized() * speed,
	
		bHasFrontalCone = false,
		bReplaceExisting = false,
		
		bProvidesVision = false,

		ExtraData = {
			isRemnant = isRemnant,
			damage = damage
		}
	}
	ProjectileManager:CreateLinearProjectile(info)

	local effect_cast = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_earth_spirit/espirit_bouldersmash_caster.vpcf",
		PATTACH_WORLDORIGIN,
		nil
	)
	ParticleManager:SetParticleControl( effect_cast, 1, target:GetAbsOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( "Hero_EarthSpirit.BoulderSmash.Cast", self:GetCaster() )

	local effect_cast = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_earth_spirit/espirit_bouldersmash_target.vpcf",
		PATTACH_ABSORIGIN_FOLLOW,
		target
	)
	ParticleManager:SetParticleControlForward( effect_cast, 1, Vector(x,y,0):Normalized() )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( distance/speed, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	EmitSoundOn( "Hero_EarthSpirit.BoulderSmash.Target", target )
end

function elementals_hero_tank_remnant:OnProjectileHit_ExtraData( hTarget, vLocation, extraData )
	if not hTarget then return end

	if extraData.isRemnant==1 then
		hTarget:AddNewModifier(
			self:GetCaster(),
			self,
			"modifier_elementals_hero_tank_remnant_slow_move",
			{
				duration = self:GetSpecialValueFor("duration"),
			}
		)
		hTarget:AddNewModifier(
			self:GetCaster(),
			self,
			"modifier_elementals_hero_tank_remnant_slow_attack",
			{
				duration = self:GetSpecialValueFor("duration"),
			}
		)
		hTarget:AddNewModifier(
			self:GetCaster(),
			self,
			"modifier_elementals_hero_tank_remnant_damage_red",
			{
				duration = self:GetSpecialValueFor("duration"),
			}
		)
	end

	EmitSoundOn( "Hero_EarthSpirit.BoulderSmash.Damage", hTarget )

	ApplyCustomDamage(hTarget, self:GetCaster(), extraData.damage, 6, self)

	return false
end

modifier_elementals_hero_tank_remnant = {}

function modifier_elementals_hero_tank_remnant:IsHidden()
	return true
end

function modifier_elementals_hero_tank_remnant:IsPurgable()
	return false
end

function modifier_elementals_hero_tank_remnant:OnCreated( kv )
	if IsServer() then
		local caster_origin = self:GetCaster():GetAbsOrigin()
		local effect_cast = ParticleManager:CreateParticle( 
			"particles/econ/items/earth_spirit/earth_spirit_vanquishingdemons_summons/espirit_stoneremnant_vanquishingdemons.vpcf",
			PATTACH_ABSORIGIN_FOLLOW,
			self:GetParent()
		)
		ParticleManager:SetParticleControl( effect_cast, 1, self:GetParent():GetAbsOrigin() )

		self:AddParticle(
			effect_cast,
			false,
			false,
			-1,
			false,
			false
		)

		EmitSoundOn( "Hero_EarthSpirit.StoneRemnant.Impact", self:GetParent() )
	end
end

function modifier_elementals_hero_tank_remnant:OnDestroy( kv )
	if IsServer() then
		self:GetParent():ForceKill( false )
		EmitSoundOn( "Hero_EarthSpirit.StoneRemnant.Destroy", self:GetParent() )
	end
end

function modifier_elementals_hero_tank_remnant:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true
	}
end

modifier_elementals_hero_tank_remnant_kick = {}

function modifier_elementals_hero_tank_remnant_kick:IsHidden()
	return false
end

function modifier_elementals_hero_tank_remnant_kick:IsDebuff()
	return true
end

function modifier_elementals_hero_tank_remnant_kick:IsStunDebuff()
	return false
end

function modifier_elementals_hero_tank_remnant_kick:IsPurgable()
	return false
end

function modifier_elementals_hero_tank_remnant_kick:OnCreated( kv )
	if IsServer() then
		self.distance = kv.r
		self.direction = Vector(kv.x,kv.y,0):Normalized()
		self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.origin = self:GetParent():GetAbsOrigin()

		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
	end
end

function modifier_elementals_hero_tank_remnant_kick:OnRefresh( kv )
	if IsServer() then
		self.distance = kv.r
		self.direction = Vector(kv.x,kv.y,0):Normalized()
		self.speed = self:GetAbility():GetSpecialValueFor( "speed" )
		self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
		self.origin = self:GetParent():GetAbsOrigin()

		if self:ApplyHorizontalMotionController() == false then 
			self:Destroy()
		end
	end	
end

function modifier_elementals_hero_tank_remnant_kick:OnDestroy( kv )
	if IsServer() then
		self:GetParent():InterruptMotionControllers( true )
	end
end

function modifier_elementals_hero_tank_remnant_kick:UpdateHorizontalMotion( me, dt )
	local pos = self:GetParent():GetAbsOrigin()

	if (pos-self.origin):Length2D()>=self.distance then
		self:Destroy()
		return
	end

	local target = pos + self.direction * (self.speed*dt)

	self:GetParent():SetAbsOrigin( target )
end

function modifier_elementals_hero_tank_remnant_kick:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

function modifier_elementals_hero_tank_remnant_kick:DeclareFunctions()
	return { MODIFIER_PROPERTY_OVERRIDE_ANIMATION }
end

function modifier_elementals_hero_tank_remnant_kick:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end

modifier_elementals_hero_tank_remnant_slow_move = {}

function modifier_elementals_hero_tank_remnant_slow_move:IsHidden()
	return false
end

function modifier_elementals_hero_tank_remnant_slow_move:IsDebuff()
	return true
end

function modifier_elementals_hero_tank_remnant_slow_move:IsStunDebuff()
	return false
end

function modifier_elementals_hero_tank_remnant_slow_move:IsPurgable()
	return true
end

function modifier_elementals_hero_tank_remnant_slow_move:OnCreated( kv )
	self.slow = self:GetAbility():GetSpecialValueFor( "move_slow" )
end

function modifier_elementals_hero_tank_remnant_slow_move:OnRefresh( kv )
	self.slow = self:GetAbility():GetSpecialValueFor( "move_slow" )	
end
function modifier_elementals_hero_tank_remnant_slow_move:DeclareFunctions()
	return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end
function modifier_elementals_hero_tank_remnant_slow_move:GetModifierMoveSpeedBonus_Percentage()
	return -self.slow
end

modifier_elementals_hero_tank_remnant_slow_attack = {}

function modifier_elementals_hero_tank_remnant_slow_attack:IsHidden()
	return false
end

function modifier_elementals_hero_tank_remnant_slow_attack:IsDebuff()
	return true
end

function modifier_elementals_hero_tank_remnant_slow_attack:IsStunDebuff()
	return false
end

function modifier_elementals_hero_tank_remnant_slow_attack:IsPurgable()
	return true
end

function modifier_elementals_hero_tank_remnant_slow_attack:OnCreated( kv )
	self.as_slow = self:GetAbility():GetSpecialValueFor( "as_bonus" )
end

function modifier_elementals_hero_tank_remnant_slow_attack:OnRefresh( kv )
	self.as_slow = self:GetAbility():GetSpecialValueFor( "as_bonus" )	
end
function modifier_elementals_hero_tank_remnant_slow_attack:DeclareFunctions()
	return { MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT }
end
function modifier_elementals_hero_tank_remnant_slow_attack:GetModifierAttackSpeedBonus_Constant()
	return -self.as_slow
end

modifier_elementals_hero_tank_remnant_damage_red = {}

function modifier_elementals_hero_tank_remnant_damage_red:IsHidden()
	return false
end

function modifier_elementals_hero_tank_remnant_damage_red:IsDebuff()
	return true
end

function modifier_elementals_hero_tank_remnant_damage_red:IsStunDebuff()
	return false
end

function modifier_elementals_hero_tank_remnant_damage_red:IsPurgable()
	return true
end

function modifier_elementals_hero_tank_remnant_damage_red:OnCreated( kv )
	self.red = self:GetAbility():GetSpecialValueFor( "damage_bonus" )
end

function modifier_elementals_hero_tank_remnant_damage_red:OnRefresh( kv )
	self.red = self:GetAbility():GetSpecialValueFor( "damage_bonus" )	
end
function modifier_elementals_hero_tank_remnant_damage_red:DeclareFunctions()
	return { MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE }
end
function modifier_elementals_hero_tank_remnant_damage_red:GetModifierDamageOutgoing_Percentage()
	return -self.red
end