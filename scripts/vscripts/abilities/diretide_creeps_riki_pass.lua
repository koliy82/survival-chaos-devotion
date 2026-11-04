function OnAttackLanded(event)
	local caster = event.caster
	local target = event.target
	if target:IsAncient() or target:IsCustomHero() then return end
	
	--local hp_remain = 1
	Timers:CreateTimer(0, function()
		local hp_remain = target:GetHealth() - event.DamageTaken
		if hp_remain > 0 then return end
	
		if caster and caster:IsAlive() then
			local ability = event.ability
			local owner = caster:GetOwner()
	
			local hp = target:GetMaxHealth()
			local damage_max = target:GetBaseDamageMax()
			local damage_min = target:GetBaseDamageMin()
			local armor = target:GetPhysicalArmorBaseValue()
	
			local werewolf = CreateUnitByName("npc_dota_diretide_wolf", target:GetAbsOrigin(), true, owner, owner, caster:GetTeam())
			FindClearSpaceForUnit( werewolf, target:GetAbsOrigin(), false )
			werewolf.previous_point = caster.previous_point
			werewolf.to_point = caster.to_point
			werewolf:SetMaxHealth(hp)
			werewolf:SetBaseMaxHealth(hp)
			werewolf:SetHealth(hp)
			werewolf:SetPhysicalArmorBaseValue(armor)
			werewolf:SetBaseDamageMin(damage_min)
			werewolf:SetBaseDamageMax(damage_max)
			werewolf:SetPhysicalArmorBaseValue(armor)
		end
	end)
end