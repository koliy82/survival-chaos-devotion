function OnSpellStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel()
	if level > 0 and ability:IsCooldownReady() and caster:GetMana() >= ability:GetManaCost(level - 1) then
    	local vCaster = caster:GetAbsOrigin()
		local vTarget
		
		local radius = ability:GetLevelSpecialValueFor("radius", level - 1)
		local speed = ability:GetLevelSpecialValueFor("speed", level - 1)

		local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_FARTHEST, false)
		if #units > 0 then
			ability:StartCooldown(ability:GetEffectiveCooldown(level))
			caster:SpendMana(ability:GetManaCost(level - 1), ability)
			vTarget = units[1]

			local info = {
			Target = vTarget,
			Source = caster,
			Ability = ability,
			EffectName = "",
			iMoveSpeed = speed,
			bDodgeable = false,
			}
			ProjectileManager:CreateTrackingProjectile(info)

    		local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_pudge/pudge_meathook.vpcf", PATTACH_CUSTOMORIGIN, caster )
    		ParticleManager:SetParticleAlwaysSimulate( pfx )
			ParticleManager:SetParticleControlEnt( pfx, 0, caster, PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", vCaster, true )
			ParticleManager:SetParticleControl( pfx, 1, vTarget:GetAbsOrigin() )
			ParticleManager:SetParticleControl( pfx, 2, Vector( speed, 0, 0 ) )
			ParticleManager:SetParticleControl( pfx, 3, Vector( 1, 0, 0 ) )
			ParticleManager:SetParticleControl( pfx, 4, Vector( 1, 0, 0 ) )
			ParticleManager:SetParticleControl( pfx, 5, Vector( 0, 0, 0 ) )
			ParticleManager:SetParticleControlEnt( pfx, 7, caster, PATTACH_CUSTOMORIGIN, nil, vCaster, true )
		end
	end
end

function OnProjectileHitUnit( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
    local vCaster = caster:GetAbsOrigin()
	local vTarget = target:GetAbsOrigin()

	local len = -(math.abs( ( vTarget - vCaster ):Length2D() ) * 0.8 )

	local knockbackModifierTable =
	{
		should_stun = 1,
		knockback_duration = 1,
		duration = keys.stun_duration,
		knockback_distance = len,
		knockback_height = 0,
		center_x = vCaster.x,
		center_y = vCaster.y,
		center_z = vCaster.z
	}
	target:AddNewModifier( caster, nil, "modifier_knockback", knockbackModifierTable )
	local damage = ability:GetLevelSpecialValueFor( "damage" , ability:GetLevel() - 1  )
	ApplyCustomDamage(target, caster, damage * caster:GetDisplayAttackSpeed() / 100, 6, ability)
end