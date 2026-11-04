function RaceBuff( event )
	local caster	= event.caster
	local ability	= event.ability

	if caster:HasModifier("modifier_elementals_fire_buff") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_elementals_creeps_air_ats_race_bonus", {})
	end
end