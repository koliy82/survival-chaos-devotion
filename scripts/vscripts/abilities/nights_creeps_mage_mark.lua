function OnDeath( event )
	local caster = event.caster
	local target = event.unit
	local ability = event.ability
	local radius  = event.radius

	if not caster then return end
	local check_cast = false
	if not GameRules:IsDaytime() then check_cast = true end
	if not caster:IsCustomHero() and caster:HasModifier("modifier_nights_hero_tank_midnight_buff") then check_cast = true end
	if caster:HasModifier("modifier_nights_ancient_day_aura_buff") then check_cast = true end
	if check_cast == true then
		local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
		local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	
		local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
		
		for _, unit in pairs( units ) do
			ability:ApplyDataDrivenModifier(caster, unit, "modifier_nights_creeps_mage_mark_armor", {})
		end
	end
end