function OnTakeDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
    local casterHP = caster:GetHealthPercent()
    local level = ability:GetLevel()
	local need_hp = ability:GetLevelSpecialValueFor( "health", level - 1 )
	
	if level > 0 and casterHP <= need_hp and ability:IsCooldownReady() and caster:GetMana() >= ability:GetManaCost(level - 1) then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_diretide_creeps_arme_rage_buff", {} )
		caster:SpendMana(ability:GetManaCost(level - 1), ability)
		ability:StartCooldown(ability:GetEffectiveCooldown(level))
	end
end