LinkLuaModifier( "modifier_treants_range_death_pass", "modifiers/modifier_treants_range_death_pass", LUA_MODIFIER_MOTION_NONE )

function OnOwnerDied( event )
	-- Variables
	local caster = event.caster
	local ability = event.ability
	local level = ability:GetLevel()
	if level > 0 then
		local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1  )
		local duration = ability:GetLevelSpecialValueFor( "duration" , level - 1  )
		local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1  )
		local min_armor = ability:GetLevelSpecialValueFor( "min_armor" , level - 1  )

		local thinker = CreateModifierThinker( caster, ability, "modifier_treants_range_death_pass", {duration = duration, radius = radius, damage = damage, min_armor = min_armor }, caster:GetAbsOrigin(), caster:GetTeamNumber(), false )
	end
end