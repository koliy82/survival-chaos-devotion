function OnTakeDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
    local casterHP = caster:GetHealth()
    local level = ability:GetLevel()
	
	if level > 0 and casterHP <= 0 and ability:IsCooldownReady() then
		caster:SetHealth(1)
		local reincarnate_time = ability:GetLevelSpecialValueFor( "duration", level - 1 )
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_cultists_creeps_mage_death", {} )
		ability:StartCooldown(300)
		
		Timers:CreateTimer(reincarnate_time + 0.1, function()
			caster:Kill(ability, keys.attacker)
		end)
	end
end