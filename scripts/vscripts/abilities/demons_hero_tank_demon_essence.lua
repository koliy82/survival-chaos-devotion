function OnTakeDamage( keys )
    -- DeepPrintTable(keys)
	local caster = keys.caster
	local ability = keys.ability
    local casterHP = caster:GetHealth()
    local level = ability:GetLevel()
	
	if level > 0 and casterHP <= 0 and ability:IsCooldownReady() then
		caster:SetHealth(1)
		local reincarnate_time = ability:GetLevelSpecialValueFor( "duration", level - 1 )
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_demons_hero_tank_demon_essence", { duration = reincarnate_time } )
		ability:StartCooldown(300)
		local id = nil
		if keys.attacker then
			id = keys.attacker:GetPlayerOwnerID()
		end
		
		Timers:CreateTimer(reincarnate_time + 0.1, function() 
			caster:Kill(ability, _G.playersinfo[id].spec)
		end)
	end
end