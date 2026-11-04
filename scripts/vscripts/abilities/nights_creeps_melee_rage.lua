function OnTakeDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
    local casterHP = caster:GetHealthPercent()
    local level = ability:GetLevel()
	local need_hp = ability:GetLevelSpecialValueFor( "health", level - 1 )
	
	if level > 0 and casterHP <= need_hp and ability:IsCooldownReady() then
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_nights_creeps_melee_rage_buff", {} )
		local abil = caster:FindAbilityByName("nights_creeps_melee_fervor")
		if abil and abil:GetLevel() > 0 then
			abil:EndCooldown()
			-- local duration = ability:GetLevelSpecialValueFor( "duration", level - 1 )
			-- abil:ApplyDataDrivenModifier( caster, caster, "modifier_nights_creeps_melee_rage_regen", {Duration = duration} )
		end
		ability:StartCooldown(ability:GetEffectiveCooldown(level))
	end
end