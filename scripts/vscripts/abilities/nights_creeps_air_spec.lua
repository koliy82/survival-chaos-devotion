function attack( keys )
	local caster = keys.caster
	local ability = keys.ability
    local level = ability:GetLevel()
	-- local target = keys.target
	if level > 0 then
		
		local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
		local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
		local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS		
		local radius = ability:GetLevelSpecialValueFor( "radius", level - 1 )
		local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
		local max_targets = ability:GetLevelSpecialValueFor( "max_targets", level - 1 )
		for i,unit in pairs(units) do
			local info = {
				EffectName = "particles/units/heroes/hero_dark_willow/dark_willow_shadow_attack.vpcf",
				Ability = ability,
				iMoveSpeed = 1700,
				Source = caster,
				Target = unit,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2
			}
			ProjectileManager:CreateTrackingProjectile (info)
			if i >= max_targets then break end
		end
		local delay = ability:GetEffectiveCooldown(level)
	    ability:StartCooldown(delay)
		Timers:CreateTimer(delay,function()		
			if caster and caster:IsAlive() then
            	ability:ApplyDataDrivenModifier(caster, caster, "modifier_nights_creeps_air_spec_invis", {})
				-- Добавить спец эффект для невидимости?
			end
		end)
	end
end

function on_hit(keys)
	local caster = keys.caster
	local attack_damage = caster:GetAttackDamage()
	local target = keys.target
	local ability = keys.ability
	if target == nil then return end
	local damage_type = caster.custom_damage_type
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel() - 1 )
	ApplyCustomDamage(target, caster, attack_damage * damage / 100, damage_type)
end