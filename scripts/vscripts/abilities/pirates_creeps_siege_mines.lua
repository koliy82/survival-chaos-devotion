function OnSpellStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	
	local gear_level = ability:GetLevel()
	if gear_level > 0 then
        local owner = caster:GetOwner()
		
		local life_time = ability:GetLevelSpecialValueFor( "life_time", gear_level - 1 )
		local hp = ability:GetLevelSpecialValueFor( "hp", gear_level - 1 )
		local armor = ability:GetLevelSpecialValueFor( "armor", gear_level - 1 )

		local spawn_location = caster:GetAbsOrigin() + caster:GetForwardVector() * 600

		local gear_type = nil
		local gear_ability = "pirates_creeps_siege_mines_new"
		local rand_gear = 1
		-- local rand_gear = RandomInt( 1,3 )
		if rand_gear == 1 then 
			gear_type = "npc_dota_pirates_mine_type_1"
			--gear_ability = "pirates_creeps_siege_mines_1"
		elseif rand_gear == 2 then 
			gear_type = "npc_dota_pirates_mine_type_2"
			--gear_ability = "pirates_creeps_siege_mines_2"
		elseif rand_gear == 3 then 
			gear_type = "npc_dota_pirates_mine_type_3"
			--gear_ability = "pirates_creeps_siege_mines_3"
		end
		local gear_unit = CreateUnitByName(gear_type, spawn_location, true, owner, owner, caster:GetTeam())
		FindClearSpaceForUnit( gear_unit, spawn_location, false )
        gear_unit:SetMaxHealth(hp)
        gear_unit:SetBaseMaxHealth(hp)
		gear_unit:SetHealth(hp)
		gear_unit:SetPhysicalArmorBaseValue(armor)

		gear_unit.FirstOwner = caster.FirstOwner

		gear_unit:AddAbility(gear_ability):SetLevel(gear_level)
		-- if caster:HasAbility("pirates_creeps_siege_spec") then
		-- 	gear_unit:AddAbility("pirates_creeps_siege_spec"):SetLevel(gear_level)
		-- end
		
		gear_unit:AddNewModifier(caster, ability, "modifier_kill", {duration = life_time})

		ability:ApplyDataDrivenModifier(caster, gear_unit, "modifier_pirates_creeps_siege_mines", {})
	end
end

function MineEffect(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	-- local spec_ability = caster:FindAbilityByName("pirates_creeps_siege_spec")

	-- if spec_ability then
	-- 	ability:ApplyDataDrivenModifier(caster, target, "modifier_pirates_creeps_siege_spec", {})
	-- 	--if caster:GetUnitName() == "npc_dota_pirates_mine_type_1" then
	-- 	--	spec_ability:ApplyDataDrivenModifier(caster, caster, "modifier_pirates_creeps_siege_spec_red_mine", {})
	-- 	--elseif caster:GetUnitName() == "npc_dota_pirates_mine_type_2" then
	-- 	--	spec_ability:ApplyDataDrivenModifier(caster, target, "modifier_pirates_creeps_siege_spec_green_mine", {Duration = keys.duration})
	-- 	--elseif caster:GetUnitName() == "npc_dota_pirates_mine_type_3" then
	-- 	--	spec_ability:ApplyDataDrivenModifier(caster, target, "modifier_pirates_creeps_siege_spec_blue_mine", {})
	-- 	--end
	-- end
end

function OnAttackLanded(keys)
	local caster = keys.caster
	local ability = keys.ability
	caster:Kill(ability, caster)
end