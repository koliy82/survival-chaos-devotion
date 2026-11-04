function WrathOfNature( event )
	local caster = event.caster -- the hero
	local thinker = event.target -- the thinker, point where the abilty was clicked
	local ability = event.ability
	local abilityTargetType = ability:GetAbilityTargetType()

	local max_targets = ability:GetLevelSpecialValueFor("max_targets", ability:GetLevel()-1)
	local damage = ability:GetLevelSpecialValueFor("damage", ability:GetLevel()-1)
	local damage_percent_add = ability:GetSpecialValueFor("damage_percent_add") * 0.01
	local jump_delay = ability:GetSpecialValueFor("jump_delay")
	local particleName = "particles/units/heroes/hero_furion/furion_wrath_of_nature.vpcf"
	for k,v in pairs(event) do
		print(k,v)
	end
	local enemies = FindUnitsInRadius(caster:GetTeamNumber(), thinker:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_ENEMY, abilityTargetType, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false)
	local visible_enemies = {}
	for _,enemy in pairs(enemies) do
		if enemy:CanEntityBeSeenByMyTeam(caster) == true then
			table.insert(visible_enemies, enemy)
		end
	end
	local target_number = 1
	local main_target = visible_enemies[target_number]
	local damage_table = {}
	damage_table.victim = main_target
	damage_table.attacker = caster					
	damage_table.damage_type = 6
	damage_table.damage = damage
	if damage_table.victim then
		ApplyCustomDamage(damage_table.victim, damage_table.attacker, damage_table.damage, damage_table.damage_type, ability)
		local targets_hit = 1
		local previous_target = main_target
		Timers:CreateTimer(DoUniqueString("WrathOfNature"), {
			callback = function()
				target_number = target_number + 1
				local next_target = visible_enemies[target_number]
				if next_target and IsValidEntity(next_target) and next_target:CanEntityBeSeenByMyTeam(caster) then
					targets_hit = targets_hit + 1
					damage_table.damage = damage_table.damage + (damage * damage_percent_add)
					damage_table.victim = next_target
					ApplyCustomDamage(damage_table.victim, damage_table.attacker, damage_table.damage, damage_table.damage_type, ability)

					local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
					ParticleManager:SetParticleControlEnt(particle, 0, previous_target, PATTACH_POINT_FOLLOW, "attach_hitloc", previous_target:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle, 1, next_target, PATTACH_POINT_FOLLOW, "attach_hitloc", next_target:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle, 2, next_target, PATTACH_POINT_FOLLOW, "attach_hitloc", next_target:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle, 3, next_target, PATTACH_POINT_FOLLOW, "attach_hitloc", next_target:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(particle, 4, next_target, PATTACH_POINT_FOLLOW, "attach_hitloc", next_target:GetAbsOrigin(), true)

					if next_target:IsCustomHero() then
						next_target:EmitSound("Hero_Furion.WrathOfNature_Damage")
					else
						next_target:EmitSound("Hero_Furion.WrathOfNature_Damage.Creep")
					end
					if targets_hit < max_targets then
						previous_target = next_target
						return jump_delay
					end
				else
					if targets_hit < max_targets and target_number < #visible_enemies then
						return jump_delay
					else
						return
					end
				end
			end
		})
	end
	
end