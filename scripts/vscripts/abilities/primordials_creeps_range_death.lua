function OnTakeDamage( keys )
    -- DeepPrintTable(keys)
	local caster = keys.caster
	local ability = keys.ability
    local casterHP = caster:GetHealth()
    local level = ability:GetLevel()
	
	if level > 0 and casterHP <= 0 and ability:IsCooldownReady() and not caster:IsIllusion() then
		caster:SetHealth(1)
		local reincarnate_time = ability:GetLevelSpecialValueFor( "duration", level - 1 )
		-- local reincarnate_time = 1
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_primordials_creeps_range_death", {} )
		ability:StartCooldown(300)
		
		Timers:CreateTimer(reincarnate_time, function()
			if caster and caster:IsAlive() and caster:HasModifier("modifier_primordials_creeps_range_death") then
				caster:Kill(ability, keys.attacker)
			end
		end)
	end
end

function OnKill( keys )
	local caster = keys.caster
	local ability = keys.ability
    local level = ability:GetLevel()
    local hp = ability:GetLevelSpecialValueFor( "hp", level - 1 )
	
	caster:RemoveModifierByName("modifier_primordials_creeps_range_death")

	caster:SetHealth(caster:GetMaxHealth() * hp / 100)
end