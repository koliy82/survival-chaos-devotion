function CounterHelix( keys )
	local caster = keys.caster
	local ability = keys.ability
	local helix_modifier = keys.helix_modifier
    local chance = keys.chance

    if caster:FindModifierByName("modifier_orcs_creeps_arme_spec_battle_buff") then
        local spec_ability = caster:FindAbilityByName("orcs_creeps_arme_spec_battle")
        local add_chance = spec_ability:GetLevelSpecialValueFor( "add_chance" , spec_ability:GetLevel() - 1 )
		chance = chance + add_chance
    end

	if caster and caster:IsAlive() and not caster:HasModifier(helix_modifier) and RollPercentage(chance) then
		ability:ApplyDataDrivenModifier(caster, caster, helix_modifier, {})
		ability:StartCooldown(ability:GetEffectiveCooldown(ability:GetLevel()))
	end
end