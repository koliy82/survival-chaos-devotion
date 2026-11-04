function OnSuccess( event )
	local ability = event.ability
	local caster = event.caster
    local level = ability:GetLevel()

    if level > 0 and caster:HasModifier("modifier_elementals_earth_buff") then
		  ability:ApplyDataDrivenModifier(caster, caster, "modifier_elementals_creeps_melee_disarm_buff", {})
    end
end