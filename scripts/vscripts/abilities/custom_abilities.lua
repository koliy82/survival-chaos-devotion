function EnableAutoCast(event)
    local ability = event.ability
    if not ability:GetAutoCastState() then
        ability:ToggleAutoCast()
    end
end

function ForceKillTarget(event)
	local target = event.target or event.caster
    target:ForceKill(false)
end

function KillTarget(event)
    event.target:Kill(event.ability, event.caster)
end

function CustomLifesteal(event)
    local target = event.target
    if target:IsAncient() then return end
	local ability = event.ability
	if ability and ability:GetLevel() < 1 then return end
    local attacker = event.attacker
    local heal = attacker:GetAttackDamage()*event.lifesteal_prc/100
    attacker:Heal( heal, event.ability )
    
    if heal > 0 then
        local lifesteal_particle = "particles/generic_gameplay/generic_lifesteal.vpcf"
        local lifesteal_pfx = ParticleManager:CreateParticle(lifesteal_particle, PATTACH_ABSORIGIN_FOLLOW, attacker)
        -- ParticleManager:SetParticleControl(lifesteal_pfx, 0, event.caster:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
    end
end

function CustomPerformAttack(event)
    local caster = event.caster
    local target = event.target
    caster:PerformAttack(target, true, true, true, true, true, false, false )
end

function SplitShotLaunch( keys )
	local caster = keys.caster
	local caster_location = caster:GetAbsOrigin()
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	if ability_level < 0 then return end
	local attack_target = caster:GetAttackTarget()

	local team = caster:GetTeamNumber()
	local position = caster:GetAbsOrigin()
	local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS
	local max_targets = ability:GetLevelSpecialValueFor("arrow_count", ability_level)

	local split_shot_projectile = caster:GetRangedProjectileName()
	local split_shot_projectile_speed = caster:GetProjectileSpeed()
	local split_shot_projectile_range = caster:Script_GetAttackRange() + 250
	if caster:HasModifier("modifier_dwarfs_creeps_air_split_shot") then split_shot_projectile_range = caster:Script_GetAttackRange() + 125 end
	if caster:HasModifier("modifier_undead_hero_asassin_split_shot") then flags = flags + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS end
	local split_shot_targets = FindUnitsInRadius(team, position, nil, split_shot_projectile_range, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)

	for _,v in pairs(split_shot_targets) do
		if v ~= attack_target then
			local projectile_info = 
			{
				EffectName = split_shot_projectile,
				Ability = ability,
				vSpawnOrigin = caster_location,
				Target = v,
				Source = caster,
				bHasFrontalCone = false,
				iMoveSpeed = split_shot_projectile_speed,
				bReplaceExisting = false,
				bProvidesVision = false
			}
			ProjectileManager:CreateTrackingProjectile(projectile_info)
			max_targets = max_targets - 1
		end
		if max_targets <= 0 then break end
	end
end

function SplitShotDamage( keys )
	local target = keys.target
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local arrow_damage = ability:GetLevelSpecialValueFor("arrow_damage", ability_level)

	ApplyCustomDamage(target, caster, caster:GetAttackDamage() * arrow_damage / 100, caster.custom_damage_type, ability)
end

function ManaBurn(event)
    local ability = event.ability
    local target = event.target
    local mana = event.mana

	local target_mana = target:GetMana()
	if target_mana <= mana then
		target:SetMana(0)
	else
		target:SpendMana(mana, ability)
	end
end

function SpawnUnit(event)
    local caster = event.caster
    local ability = event.ability
	if ability and ability:GetLevel() == 0 then return end
	local unitname = event.UnitName
	local unitcount = event.UnitCount or 1
	local spawnradius = event.SpawnRadius or 150
	local duration = event.Duration
	local addmodifier = event.AddModifier
	local addability = event.AddAbility
	local addabilityfromcaster = event.AddAbilityFromCaster
	local hero_killer = event.HeroKiller == 1
	local nowOwner = caster:GetOwner()
	local owner = nowOwner
	if event.FirstOwner == 1 and caster.FirstOwner then
		owner = caster.FirstOwner
	end
	local pos = caster:GetAbsOrigin()
	local id = caster:GetPlayerOwnerID()
	if event.unit then
		pos = event.unit:GetAbsOrigin()
	end
	if event.OnTarget == 1 and event.target then
		pos = event.target:GetAbsOrigin()
	end

	if _G.playersinfo[id].unitsinfo[unitname] then
		if event.Health then
			_G.playersinfo[id].unitsinfo[unitname].health = event.Health
		end
		if event.Armor then
			_G.playersinfo[id].unitsinfo[unitname].armor = event.Armor
		end
		if event.Damage then
			_G.playersinfo[id].unitsinfo[unitname].min_damage = event.Damage
			_G.playersinfo[id].unitsinfo[unitname].max_damage = event.Damage
		end
		if event.MinDamage then
			_G.playersinfo[id].unitsinfo[unitname].min_damage = event.MinDamage
		end
		if event.MaxDamage then
			_G.playersinfo[id].unitsinfo[unitname].max_damage = event.MaxDamage
		end
	end
    
    for i=1, unitcount do
        local unit = CreateUnitByName(unitname, pos, true, owner, owner, caster:GetTeam())
        unit.previous_point = caster.previous_point
		unit.to_point = caster.to_point
		unit.hero_killer = hero_killer
		FindClearSpaceForUnit( unit, pos+RandomVector( spawnradius ), false )
		if owner ~= nowOwner then unit:SetOwner(nowOwner) end
		if duration then
			unit:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
		end
		if addmodifier then
			ability:ApplyDataDrivenModifier( caster, unit, addmodifier, {} )
		end
		if addability then
			unit:AddAbility(addability):SetLevel(ability:GetLevel())
		end
		if addabilityfromcaster then
			local abil = caster:FindAbilityByName(addabilityfromcaster)
			if abil then
				unit:AddAbility(addabilityfromcaster):SetLevel(abil:GetLevel())
			end
		end
    end
end

function CustomCleaveAttack(event)
    local caster = event.caster
	local target = event.target
	local ability = event.ability
	local cleave_radius = event.cleave_radius
	local cleave_percent = event.cleave_percent
	-- local cleave_effect = event.cleave_effect
	local pos

	if target then
		if target:IsAncient() then return end
		pos = target:GetAbsOrigin() + caster:GetForwardVector() * cleave_radius
	else
		pos = caster:GetAbsOrigin() + caster:GetForwardVector() * cleave_radius
	end

	local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	local cleave_targets = FindUnitsInRadius(caster:GetTeam(), pos, nil, cleave_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)

	local part = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf", PATTACH_ABSORIGIN, caster)
	for key,v in pairs(cleave_targets) do
		if v ~= target then
			ParticleManager:SetParticleControl(part, key+1, v:GetAbsOrigin())
			ApplyCustomDamage(v, caster, caster:GetAttackDamage() * cleave_percent / 100, caster.custom_damage_type, ability)
		end
	end
end

function CustomDamageReturn(event)
	local caster = event.caster
    local ability = event.ability
    local attacker = event.attacker

	if event.only_from_melee == 1 and attacker:IsRangedAttacker() then return end

    local damage = event.damage
    local damage_taken = event.DamageTaken

    local particle_cast = "particles/units/heroes/hero_dark_seer/dark_seer_ion_shell_damage.vpcf"

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, attacker )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0),
		true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		attacker,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0),
		true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )

    ApplyCustomDamage(attacker, caster, damage_taken * damage / 100, 6, ability)
end

function CustomManaBreak( event )
	local target = event.target
	local ability = event.ability
	local manaBurn = event.mana_per_hit
	-- local manaDamage = ability:GetLevelSpecialValueFor("damage_per_burn", (ability:GetLevel() - 1))

	-- local damageTable = {}
	-- damageTable.attacker = caster
	-- damageTable.victim = target
	-- damageTable.damage_type = ability:GetAbilityDamageType()
	-- damageTable.ability = ability

	if not target:IsMagicImmune() and not target:IsAncient() then
		-- Checking the mana of the target and calculating the damage
		-- if(target:GetMana() >= manaBurn) then
		--     damageTable.damage = manaBurn * manaDamage
		--     target:ReduceMana(manaBurn)
		-- else
		--     damageTable.damage = target:GetMana() * manaDamage

        local target_mana = target:GetMana()
        if target_mana <= manaBurn then
            target:SetMana(0)
        else
            target:SpendMana(manaBurn, ability)
        end

			--target:ReduceMana(manaBurn)
		-- end

		-- ApplyDamage(damageTable)
	end
end

function MakeHeroIllusions( keys )
	local caster = keys.caster
	local ability = keys.ability
	local hero_killer = keys.HeroKiller == 1

	-- Ability variables
	local unit_name = caster:GetUnitName()
	local origin = caster:GetAbsOrigin()
    local id = caster:GetPlayerOwnerID()
	
	for i=1,keys.illusions do
		local illusion = CreateUnitByName(unit_name, origin, true, caster:GetOwner(), caster:GetOwner(), caster:GetTeamNumber())
		
		illusion:RemoveAbility("hero_core")
		illusion:CreatureLevelUp(caster:GetLevel()-1)
		for abilitySlot=0,3 do
			local ability = caster:GetAbilityByIndex(abilitySlot)
			if ability ~= nil then 
				local abilityLevel = ability:GetLevel()
				local abilityName = ability:GetAbilityName()
				local illusionAbility = illusion:FindAbilityByName(abilityName)
				illusionAbility:SetLevel(abilityLevel)
			end
		end
		for i=0,8 do
			local item = caster:GetItemInSlot(i)
			if item ~= nil then
				illusion:AddItemByName(item:GetAbilityName())
			end
		end
		illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = keys.duration, outgoing_damage = keys.illusion_damage_outgoing, incoming_damage = keys.illusion_damage_incoming })
		illusion:MakeIllusion()
		if not keys.is_full_health then
			illusion:SetHealth(caster:GetHealth())
		else
			illusion:SetHealth(caster:GetMaxHealth())
		end
	    illusion.previous_point = caster.previous_point
	    illusion.to_point = caster.to_point
		illusion.hero_killer = hero_killer
	end
end

function MakeCreepIllusions( keys )
	local caster = keys.caster
	local ability = keys.ability
	local hero_killer = keys.HeroKiller == 1

	-- Ability variables
	local unit_name = caster:GetUnitName()
	local origin = caster:GetAbsOrigin()
	
	local nowOwner = caster:GetOwner()
	local owner = nowOwner
	if keys.FirstOwner == 1 and caster.FirstOwner then
		owner = caster.FirstOwner
	end

	for i=1,keys.illusions do
		local illusion = CreateUnitByName(unit_name, origin, true, owner, owner, caster:GetTeamNumber())
		if owner ~= nowOwner then unit:SetOwner(nowOwner) end
		illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = keys.duration, outgoing_damage = keys.illusion_damage_outgoing, incoming_damage = keys.illusion_damage_incoming })
		illusion:MakeIllusion()
		illusion:SetHealth(caster:GetHealth())
		if keys.apply_buff then
			ability:ApplyDataDrivenModifier(caster, illusion, keys.apply_buff, {})
		end
	    illusion.previous_point = caster.previous_point
	    illusion.to_point = caster.to_point
		illusion.hero_killer = hero_killer
	end
end

function AddCustomBarrier( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target or caster
	local barrier = tonumber(keys.barrier)
	local damage_type = tonumber(keys.damage_type)
	local duration = keys.duration
	local effect = keys.effect

	local mod = target:AddBarrier(barrier, damage_type, duration, caster, ability)
	if effect then
		local part = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, target)
		mod:AddParticle(part, false, false, 0, false, false)
	end
end

function ChangeResist( keys )
	local caster = keys.caster
	local target = keys.target or caster
    local damage_type = keys.damage_type
	local resist = keys.resist
	local revert = keys.revert
	local change_resist = (1 - resist / 100)
	if revert then
		change_resist = 1 / change_resist
	end
    if target.custom_damage_reduction then
        target.custom_damage_reduction[damage_type] = target.custom_damage_reduction[damage_type] * change_resist
    end
end

function SpellDamageIncrease(event)
	local ability = event.ability
	if ability and ability:GetLevel() > 0 then
		local bonus_damage_prc = event.bonus_damage_prc
		local caster = event.caster
		if event.multiplier then
			bonus_damage_prc = bonus_damage_prc * event.multiplier
		end
		if caster and bonus_damage_prc then
			caster.custom_damage_attack_multiplier[6] = 1 + bonus_damage_prc/100
		end
	end
end

function BlockDamage( event )
	local caster = event.caster
	local target = event.target
    local ability = event.ability
    local block_chance = event.chance
    if caster and target and ability then
        if RollPercentage(block_chance) then
            target.custom_block[0] = 999999
        else
            target.custom_block[0] = 0
        end
    end
end

function UseByAttack(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if not ability then return end
	if keys.target_is_not_hero then
		if target:IsCustomHero() then return end
	end
    local level = ability:GetLevel()
	if level > 0 and ability:IsCooldownReady() and caster:GetMana() >= ability:GetManaCost(level - 1) and not caster:IsSilenced() and not caster:IsIllusion() and not target:IsAncient() then
		ability:StartCooldown(ability:GetEffectiveCooldown(level))
		caster:SpendMana(ability:GetManaCost(level - 1), ability)

		if keys.modifier then
			local goal = caster
			if keys.goal_is_target then
				goal = target
				if keys.random then
					local team = caster:GetTeamNumber()
            		local position = target:GetAbsOrigin()
            		local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
            		local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
            		local targets = FindUnitsInRadius(team, position, nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
					
					goal = targets[1]
				end
			end
			if keys.create_thinker and goal and caster then
				local thinker = CreateModifierThinker( caster, ability, "", {Duration = keys.duration or 1}, goal:GetAbsOrigin(), caster:GetTeamNumber(), false)
				ability:ApplyDataDrivenModifier(caster, thinker, keys.modifier, {Duration = keys.duration or 1})
			else
				ability:ApplyDataDrivenModifier(caster, goal, keys.modifier, {Duration = keys.duration or 1})
			end
		end
	end
end

function ChangeArmorType(keys)
	local caster = keys.caster

	armor_types = {"light_armor", "medium_armor", "heavy_armor", "fort_armor", "hero_armor", "unarmored_armor"}

	caster:RemoveAbility(armor_types[caster.custom_armor_type])
	caster:RemoveModifierByName("modifier_"..armor_types[caster.custom_armor_type])

	caster:AddAbility(armor_types[keys.to_type]):SetLevel(1)
end

function IsNightTime(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	if not ability then return end
	if keys.target_is_not_hero then
		if target:IsCustomHero() then return end
	end
	if keys.target_is_not_caster then
		if target == caster then return end
	end

	local goal = caster
	if keys.goal_is_target then
		goal = target
	end

	local check_cast = false
	if not GameRules:IsDaytime() then check_cast = true end
	if not caster:IsCustomHero() and caster:HasModifier("modifier_nights_hero_tank_midnight_buff") then check_cast = true end
	if not caster:IsCustomHero() and caster:HasModifier("modifier_nights_ancient_day_aura_buff") then check_cast = true end

	if keys.modifier then
		if check_cast == true then
			ability:ApplyDataDrivenModifier(caster, goal, keys.modifier, {Duration = keys.duration or 1})
		end
	end
	if keys.applydamage then
		if check_cast == true then
			ApplyCustomDamage(target, caster, keys.applydamage, 6, ability)
		end
	end
	if keys.heal then
		if check_cast == true then
			caster:Heal( keys.heal, ability )
		end
	end

    --function ability:CheckCast(goal)
	--	if not GameRules:IsDaytime() then return true end
	--	if not goal:IsCustomHero() and goal:HasModifier("modifier_nights_hero_tank_midnight_buff") then return true end
	--	if goal:HasModifier("modifier_nights_ancient_day_aura_buff") then return true end
	--	return false
    --end
end