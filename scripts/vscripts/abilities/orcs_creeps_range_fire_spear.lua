function OnSuccess(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local chance = ability:GetLevelSpecialValueFor( "burn_chance", ( ability:GetLevel() - 1) )
    local mod = caster:FindModifierByName("modifier_orcs_creeps_range_rage_pass_buff")
    if mod then
        chance = chance * 2
    end
	
	local rand = math.random(1,100)
	if rand <= chance then
		if mod and target:FindModifierByName("modifier_orcs_creeps_range_fire_spear_damage") then
			local add_damage = ability:GetLevelSpecialValueFor( "add_damage", ( ability:GetLevel() - 1) )
			ApplyCustomDamage(target, caster, add_damage, 6, ability)
		else
			ability:ApplyDataDrivenModifier(caster, target, "modifier_orcs_creeps_range_fire_spear_damage", {})
		end
	end
end