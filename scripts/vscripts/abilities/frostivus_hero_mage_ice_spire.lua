function CreateWard(keys)
	local caster = keys.caster
	local ability = keys.ability
	local position = caster:GetAbsOrigin() + caster:GetForwardVector() * 300
	local owner = caster:GetOwner()
	
	caster.ward = CreateUnitByName("npc_dota_frostivus_hero_mage_ice_spire", position, true, owner, owner, caster:GetTeam())

	ability:ApplyDataDrivenModifier( caster, caster.ward, "modifier_frostivus_hero_mage_ice_spire_ward", {} )
end

function OnIntervalThink( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1

	local particle_name = "particles/units/heroes/hero_dragon_knight/dragon_knight_elder_dragon_frost.vpcf"
    local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() - 1 )
	
	local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

    local units = FindUnitsInRadius(caster.ward:GetTeamNumber(), caster.ward:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
	for _,unit in ipairs(units) do
        local info = 
		{
			Target = unit,
			Source = caster.ward,
			Ability = ability,	
			EffectName = particle_name,
		    iMoveSpeed = 600,
			vSourceLoc= caster.ward:GetAbsOrigin(),                -- Optional (HOW) поднять
			bDrawsOnMinimap = false,                          -- Optional
		    bDodgeable = false,                                -- Optional
		    bIsAttack = false,                                -- Optional
		    bVisibleToEnemies = true,                         -- Optional
		    bReplaceExisting = false,                         -- Optional
		    --flExpireTime = GameRules:GetGameTime() + 10,      -- Optional but recommended
			bProvidesVision = true,                           -- Optional
			iVisionRadius = 100,                              -- Optional
			iVisionTeamNumber = caster.ward:GetTeamNumber()        -- Optional
		}
		projectile = ProjectileManager:CreateTrackingProjectile(info)
		break
	end
end

function DestroyWard(keys)
	local caster = keys.caster
	
	caster.ward:ForceKill(false)
end