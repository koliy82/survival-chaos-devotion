function OnSuccess(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local chance = ability:GetLevelSpecialValueFor( "crit_chance", ( ability:GetLevel() - 1) )
    local mod = target:FindModifierByName("modifier_undead_creeps_range_death_mark_debuff")
    if mod then
        chance = chance * 2
    end
	
	local rand = math.random(1,100)
	if rand <= chance then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_undead_creeps_range_fire_arrow_critmod", {})
	end
end