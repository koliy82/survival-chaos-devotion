function OnSpellStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	local gear_level = ability:GetLevel()
	if gear_level > 0 then
        local owner = caster:GetOwner()
		
		local life_time = ability:GetLevelSpecialValueFor( "life_time", ability:GetLevel() - 1 )
		local hp = ability:GetLevelSpecialValueFor( "hp", ability:GetLevel() - 1 )
		local armor = ability:GetLevelSpecialValueFor( "armor", ability:GetLevel() - 1 )

		local spawn_location = caster:GetAbsOrigin() + caster:GetForwardVector() * 100

		local gear_type = nil
		local gear_ability = nil
		local rand_gear = RandomInt( 1,3 )
		if rand_gear == 1 then 
			gear_type = "npc_dota_dwarfs_gear_type_1"
			gear_ability = "dwarfs_creeps_mage_spec_gear_type_1"
		elseif rand_gear == 2 then 
			gear_type = "npc_dota_dwarfs_gear_type_2"
			gear_ability = "dwarfs_creeps_mage_spec_gear_type_2"
		elseif rand_gear == 3 then 
			gear_type = "npc_dota_dwarfs_gear_type_3"
			gear_ability = "dwarfs_creeps_mage_spec_gear_type_3"
		end
		local gear_unit = CreateUnitByName(gear_type, spawn_location, true, owner, owner, caster:GetTeam())
		FindClearSpaceForUnit( gear_unit, spawn_location, false )
        gear_unit:SetMaxHealth(hp)
        gear_unit:SetBaseMaxHealth(hp)
		gear_unit:SetHealth(hp)
		gear_unit:SetPhysicalArmorBaseValue(armor)

		gear_unit.FirstOwner = caster.FirstOwner

		gear_unit:AddAbility(gear_ability):SetLevel(ability:GetLevel())
		
		gear_unit:AddNewModifier(caster, ability, "modifier_kill", {duration = life_time})

		ability:ApplyDataDrivenModifier(caster, gear_unit, "modifier_dwarfs_creeps_mage_spec_gear_passive", {})
	end
end

function CheckBuff(keys)
	local caster	= keys.caster
	local ability	= keys.ability
	local modifier_name	= keys.modifier
	
	local radius = ability:GetLevelSpecialValueFor("type1_radius", ability:GetLevel() - 1)
	
	local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	local target_types = DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

	local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
	--local buff_exist
	local unit_under_buff
	local new_target
	
	for i,unit in ipairs(units) do
		if unit:FindModifierByNameAndCaster(modifier_name, caster) and unit:GetMaxHealth() ~= unit:GetHealth() then
			--ability:ApplyDataDrivenModifier( caster, unit, modifier_name, {})
			unit_under_buff = unit
			--buff_exist = true
			break
		end
		if unit:GetMaxHealth() > unit:GetHealth() and not unit:FindModifierByName(modifier_name) then
			unit_under_buff = unit
		end
	end
	
	--if not buff_exist and new_target then
	--	unit_under_buff = new_target
	--end

	if unit_under_buff then
		ability:ApplyDataDrivenModifier( caster, unit_under_buff, modifier_name, {})
		local nfx = ParticleManager:CreateParticle('particles/units/heroes/hero_rattletrap/rattletrap_cog_attack.vpcf', PATTACH_ABSORIGIN, caster)
    	ParticleManager:SetParticleControlEnt(nfx, 0, unit_under_buff, PATTACH_POINT_FOLLOW, "attach_hitloc", unit_under_buff:GetAbsOrigin(), true)
    	ParticleManager:SetParticleControlEnt(nfx, 1, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
    	ParticleManager:ReleaseParticleIndex(nfx)
    	--unit_under_buff:EmitSound("Hero_Rattletrap.Power_Cogs_Impact")
	end
end

function CreateMine(keys)
	local ability = keys.ability
	local caster = keys.caster
	local owner = caster:GetOwner()
	local direction = caster:GetForwardVector()
	local team = caster:GetTeam()
	local position = caster:GetAbsOrigin() + 50 * direction
	ability.starting_position = position
	ability.level = ability:GetLevel() - 1

	local targets = FindUnitsInRadius(team, caster:GetAbsOrigin(), nil, 600, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false)
	local target = nil
			
	if #targets > 0 then
		for k,v in pairs(targets) do
			target = v:GetAbsOrigin()
			targets[k] = nil
			break
		end
	else
		return
	end
	-- Creates the missile
	local unit = CreateUnitByName("npc_dota_techies_land_mine", position, true, owner, owner, team)
	-- Applies the modifer that moves the missile
	ability:ApplyDataDrivenModifier(caster, unit, "modifier_dwarfs_creeps_mage_spec_gear_type2_move", {})
	
	ability.mark = ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_x_spot_mark_red_fxset.vpcf", PATTACH_ABSORIGIN, caster) 
	ParticleManager:SetParticleControl(ability.mark, 0, target)
	
	unit.target = target
end

function MoveMine(keys)
	local caster = keys.caster
	local ability = keys.ability
	local unit = keys.target
	local target = unit.target

	local interval = 0.02
		
	local vector_distance = target - unit:GetAbsOrigin()
	local distance = (vector_distance):Length2D()
	local direction = (vector_distance):Normalized()

	if distance < 50 then
				
		local particle = ParticleManager:CreateParticle(keys.particle2, PATTACH_ABSORIGIN, caster) 
		ParticleManager:SetParticleControl(particle, 0, target)
		EmitSoundOn(keys.sound3, unit)
				
		local damage = ability:GetLevelSpecialValueFor( "type2_damage", ability.level )
		local radius = ability:GetLevelSpecialValueFor( "type2_radius", ability.level )

		local targets = FindUnitsInRadius(unit:GetTeam(), unit:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false)
		for k,v in pairs(targets) do
			ApplyCustomDamage(v, unit, damage, 6, ability)
		end

		ParticleManager:DestroyParticle( ability.mark, true )	
		EmitSoundOn(keys.sound4, unit)
		unit:ForceKill(false)
				
		unit:AddNoDraw()
	else
		local speed = ability:GetLevelSpecialValueFor( "type2_speed", ability.level ) * interval
		unit:SetForwardVector(Vector(direction.x/2, direction.y/2, -1))--needfix
		unit:SetAbsOrigin(unit:GetAbsOrigin() + direction * speed)
	end
end