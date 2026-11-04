LinkLuaModifier( "agr_mod", "modifiers/agr_mod.lua", LUA_MODIFIER_MOTION_NONE )
function OnAttackLanded(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
    local level = ability:GetLevel()
	local hp_cost = keys.hp
	if level > 0 and ability:IsCooldownReady() and not caster:IsIllusion() then
		local team = caster:GetTeamNumber()
		local position = caster:GetAbsOrigin()
		local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
        local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

		local agr_radius = ability:GetLevelSpecialValueFor( "agr_radius" , level - 1 )

        local targets = FindUnitsInRadius(team, position, nil, agr_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
		
		local enemy_hero

		for _,unit in ipairs(targets) do
			if unit:IsCustomHero() then
				enemy_hero = unit
				break
			end
		end

		if enemy_hero then
			if caster:GetHealth() > hp_cost then hp_cost = hp_cost - 1 end
			ability:StartCooldown(ability:GetEffectiveCooldown(level))
			local damageTable = {
				victim = caster,
				attacker = caster,
				damage = hp_cost, --caster:GetMaxHealth() * hp_cost / 100,
				damage_type = DAMAGE_TYPE_PURE
			}
			ApplyDamage(damageTable)
			
			local duration = ability:GetLevelSpecialValueFor( "duration" , level - 1 )
			-- targets = FindUnitsInRadius(target:GetTeamNumber(), target:GetAbsOrigin(), nil, agr_radius, DOTA_UNIT_TARGET_TEAM_BOTH, target_type, flags, 0, false)
			targets = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, agr_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, 0, false)
	
			for _, unit in pairs( targets ) do
				if unit:GetTeamNumber() ~= enemy_hero:GetTeamNumber() then
					unit:AddNewModifier(enemy_hero, ability, "agr_mod", {duration = duration})
				end
			end
			caster:AddNewModifier(enemy_hero, ability, "agr_mod", {Duration = duration})
			ability:ApplyDataDrivenModifier(caster, caster, "modifier_modifier_cultists_hero_asassin_run_caster_buff", {Duration = duration})
		end
	end
end