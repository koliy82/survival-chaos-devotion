function OnTakeDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
    local casterHP = caster:GetHealth()
    local level = ability:GetLevel()
	local limit = ability:GetLevelSpecialValueFor( "limit", level - 1 ) / 100
	local duration = ability:GetLevelSpecialValueFor( "duration", level - 1 )
	local heal = ability:GetLevelSpecialValueFor( "hp_regen", level - 1 ) / duration
	
	if level > 0 and casterHP <= caster:GetMaxHealth() * limit and ability:IsCooldownReady() and caster:GetMana() >= ability:GetManaCost(level - 1) then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_elementals_hero_tank_set_in_stone", { duration = duration } )
		caster:SpendMana(ability:GetManaCost(level - 1), ability)
		for i = 1, duration do
			Timers:CreateTimer( i, function()
				caster:Heal( heal, ability )
			end)
		end
		ability:StartCooldown(ability:GetEffectiveCooldown(level))
	end
end