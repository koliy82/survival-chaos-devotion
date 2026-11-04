function OnTakeDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
    local casterHP = caster:GetHealthPercent()
    local level = ability:GetLevel()
	local need_hp = ability:GetLevelSpecialValueFor( "health", level - 1 )
	
	if level > 0 and casterHP <= need_hp and ability:IsCooldownReady() and caster:GetMana() >= ability:GetManaCost(level - 1) then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_nights_creeps_arme_charge_stun", {} )
		
		local abil = caster:FindAbilityByName("nights_creeps_arme_shield")
		if abil and abil:GetLevel() > 0 then
			local shield = ability:GetLevelSpecialValueFor( "shield", level - 1 ) / 100
			abil.barrier_mod.durability = abil.barrier_mod.durability + abil.barrier_mod.max_durability * shield
		end

		ability:StartCooldown(ability:GetEffectiveCooldown(level))
		caster:SpendMana(ability:GetManaCost(level - 1), ability)
	end
end