function OnAttackLanded( event )
	local ability = event.ability
	local caster = event.caster

	if ability:IsCooldownReady() and not caster:IsIllusion() and not caster:HasModifier("modifier_primordials_creeps_range_death") then

		local unit_name = caster:GetUnitName()
		local origin = caster:GetAbsOrigin()
		
		local nowOwner = caster:GetOwner()
		local owner = nowOwner
		if event.FirstOwner == 1 and caster.FirstOwner then
			owner = caster.FirstOwner
		end

		for i=1,event.illusions do
			local illusion = CreateUnitByName(unit_name, origin, true, owner, owner, caster:GetTeamNumber())
			if owner ~= nowOwner then unit:SetOwner(nowOwner) end
			illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = event.duration, outgoing_damage = event.illusion_damage_outgoing, incoming_damage = event.illusion_damage_incoming })
			illusion:MakeIllusion()
			illusion:SetHealth(caster:GetHealth())
		    illusion.previous_point = caster.previous_point
		    illusion.to_point = caster.to_point
			ability:ApplyDataDrivenModifier(caster, illusion, event.apply_buff, {})
		end
    	
		local cooldown = ability:GetEffectiveCooldown(ability:GetLevel())
		ability:StartCooldown(cooldown)
	end
end