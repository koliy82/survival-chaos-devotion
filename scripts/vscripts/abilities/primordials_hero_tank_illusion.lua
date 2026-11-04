LinkLuaModifier( "agr_mod", "modifiers/agr_mod.lua", LUA_MODIFIER_MOTION_NONE )
function MakeHeroIllusions(keys)
	local caster = keys.caster
	local ability = keys.ability

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

		illusion:SetHealth(caster:GetMaxHealth())

	    illusion.previous_point = caster.previous_point
	    illusion.to_point = caster.to_point

		local radius = ability:GetLevelSpecialValueFor("radius", ability:GetLevel() -1)
		local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
		local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
		local targetFlag = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

		local units = FindUnitsInRadius(caster:GetTeamNumber(), illusion:GetAbsOrigin(), nil, radius, targetTeam, targetType, targetFlag, FIND_ANY_ORDER, false)
		for k,v in pairs(units) do
			v:AddNewModifier(illusion, ability, "agr_mod", {duration = 1})
		end

		ability:ApplyDataDrivenModifier(caster, illusion, "modifier_primordials_hero_tank_illusion_death_pass", {})
	end
end