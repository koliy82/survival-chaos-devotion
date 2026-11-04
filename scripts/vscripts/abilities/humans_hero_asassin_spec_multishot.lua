function OnSpellStart(event)
    local target = event.target
	local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()
	-- ability.direction = (caster:GetCursorPosition() - caster:GetAbsOrigin()):Normalized()
	ability.direction = caster:GetForwardVector()
    ability.arrow_damage_pct = ability:GetLevelSpecialValueFor("arrow_damage_pct" , level - 1  )

	ability.arrow_width = ability:GetLevelSpecialValueFor("arrow_width" , level - 1  )
    ability.arrow_speed = ability:GetLevelSpecialValueFor("arrow_speed" , level - 1  )
    ability.arrow_range_multiplier = ability:GetLevelSpecialValueFor("arrow_range_multiplier" , level - 1  )
    ability.arrow_angle = ability:GetLevelSpecialValueFor("arrow_angle" , level - 1  )
    ability.duration = ability:GetLevelSpecialValueFor("duration" , level - 1  )

    ability.start_angle = -20
    ability.count = 0
    EmitSoundOn("Hero_DrowRanger.Multishot.Channel", caster)
	
	ability:ApplyDataDrivenModifier(caster, caster,  "modifier_humans_hero_asassin_spec_multishot", {duration=ability.duration})
end
function OnIntervalThink(event)
	local caster = event.caster
    local ability = event.ability
	local sound = "Hero_DrowRanger.Multishot.FrostArrows" or "Hero_DrowRanger.Multishot.Attack"
	EmitSoundOn(sound, caster)
	local distance = caster:Script_GetAttackRange() * ability.arrow_range_multiplier
	local proj = "particles/units/heroes/hero_drow/drow_multishot_proj_linear_proj.vpcf"-- or "particles/units/heroes/hero_drow/drow_base_attack_linear_proj.vpcf"

	while (true) do
		local Qangle = QAngle(0 , ability.start_angle , 0)
		local endpos = RotatePosition(Vector(0,0,0), Qangle, ability.direction)
		local direction = endpos
		local info = {
			Ability = ability,
			EffectName = proj,
			vSpawnOrigin = caster:GetAttachmentOrigin(caster:ScriptLookupAttachment("attach_attack1")),
			fDistance = distance,
			fStartRadius = ability.arrow_width,
			fEndRadius = ability.arrow_width,
			Source = caster,
			bHasFrontalCone = false,
			bReplaceExisting = false,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
			iUnitTargetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			fExpireTime = GameRules:GetGameTime() + 10.0,
			bDeleteOnHit = true,
			vVelocity = direction * ability.arrow_speed,
			bProvidesVision = true,
			iVisionRadius = 100,
			iVisionTeamNumber = caster:GetTeamNumber()
		}

		ProjectileManager:CreateLinearProjectile( info )
		ability.start_angle = ability.start_angle + (ability.arrow_angle / 5)

		ability.count = ability.count + 1
		if ability.count >= 4 then
			ability.start_angle = -20
			ability.count = 0
			break
		end
	end
end

function OnProjectileHit(event)
	local target = event.target
	local caster = event.caster
	local ability = event.ability

	local damage = caster:GetAttackDamage() / 100 * ability.arrow_damage_pct
    ApplyCustomDamage(target, caster, damage, 6, ability)
	EmitSoundOn("Hero_DrowRanger.ProjectileImpact", target)
end