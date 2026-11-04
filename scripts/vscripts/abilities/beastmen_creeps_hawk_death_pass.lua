function OnIntervalThink( event )
	local caster = event.caster
	local ability = event.ability

	local mod = caster:FindModifierByName("modifier_beastmen_creeps_hawk_death_pass_check")
    mod:SetStackCount(mod:GetStackCount()+1)
	local death_time  = event.death_time
	local death_hp  = event.death_hp

	if caster:GetHealthPercent() > death_hp and mod:GetStackCount() ~= death_time then return end
	
	ability:ApplyDataDrivenModifier( caster, caster, "modifier_beastmen_creeps_caster_death_pass", {} )
	caster:RemoveModifierByName("modifier_beastmen_creeps_hawk_death_pass_check")

	--local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_shard_dive_impact.vpcf", PATTACH_CUSTOMORIGIN, caster)
	ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_shard_dive_blur.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)

	local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
    local targets =  FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
    if #targets > 0 then
		local dir = (targets[1]:GetOrigin()-caster:GetAbsOrigin()):Normalized()
		local distance = caster:GetAbsOrigin()+(dir*caster:GetBaseAttackRange())
		caster:MoveToPosition(distance)
		Timers:CreateTimer(2,function()
			local radius  = event.radius
			local damage  = event.damage

			local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_beastmaster/beastmaster_shard_dive_impact.vpcf", PATTACH_CUSTOMORIGIN, caster)
			ParticleManager:SetParticleControlEnt(pfx, 0, caster, PATTACH_POINT, "attach_hitloc", caster:GetAbsOrigin(), true)

			local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
			local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
			local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

			local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
	
			--for _, unit in pairs( units ) do
			--	ApplyCustomDamage(unit, caster, damage, 6, ability)
			--	break
			--end
			if units[1] and units[1]:IsAlive() then
				ApplyCustomDamage(units[1], caster, damage, 6, ability)
			end
			caster:ForceKill(false)
		  end)
	end
end