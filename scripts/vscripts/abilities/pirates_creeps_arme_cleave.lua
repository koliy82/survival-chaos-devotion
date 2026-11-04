function CustomCleaveAttack(event)
    local caster = event.caster
	local target = event.target
	local ability = event.ability
	if ability:IsCooldownReady() then
		ability:StartCooldown(ability:GetEffectiveCooldown(ability:GetLevel()))
		local cleave_radius = event.cleave_radius
		local cleave_percent = event.cleave_percent / 100
		local pos

		if target then
			if target:IsAncient() then return end
			pos = target:GetAbsOrigin() + caster:GetForwardVector() * cleave_radius
		else
			pos = caster:GetAbsOrigin() + caster:GetForwardVector() * cleave_radius
		end

		local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
		local cleave_targets = FindUnitsInRadius(caster:GetTeam(), pos, nil, cleave_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)

		local part = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf", PATTACH_ABSORIGIN, caster)
		for key,v in pairs(cleave_targets) do
			ParticleManager:SetParticleControl(part, key+1, v:GetAbsOrigin())
			local spec_ability = caster:FindAbilityByName("pirates_creeps_arme_mark")
			if spec_ability then
    	    	local level = spec_ability:GetLevel()
    	    	local duration = spec_ability:GetLevelSpecialValueFor( "duration" , level - 1  )
    	    	local need_attack = spec_ability:GetLevelSpecialValueFor( "need_attack" , level - 1  )
    	    	if v:IsCustomHero() then
    	    	    local mod = v:FindModifierByName("modifier_pirates_creeps_arme_mark_debuff_hero")

    	    	    if mod then
    	    	        local stacks = mod:GetStackCount()
    	    	        if stacks < need_attack then
    	    	            mod:SetStackCount(stacks+1)
    	    	            mod:SetDuration(duration, true)
    	    	        else
    	    	            spec_ability:ApplyDataDrivenModifier(caster, v, "modifier_pirates_creeps_arme_mark_buff_emitter", {})
    	    	        end
    	    	    else
    	    	        spec_ability:ApplyDataDrivenModifier(caster, v, "modifier_pirates_creeps_arme_mark_debuff_hero", {}):SetStackCount(1)
    	    	    end
    	    	else
    	    	    local mod = v:FindModifierByName("modifier_pirates_creeps_arme_mark_debuff")

    	    	    if mod then
    	    	        local stacks = mod:GetStackCount()
    	    	        if stacks < need_attack then
    	    	            mod:SetStackCount(stacks+1)
    	    	            mod:SetDuration(duration, true)
    	    	        else
    	    	            spec_ability:ApplyDataDrivenModifier(caster, v, "modifier_pirates_creeps_arme_mark_buff_emitter", {})
    	    	        end
    	    	    else
    	    	        spec_ability:ApplyDataDrivenModifier(caster, v, "modifier_pirates_creeps_arme_mark_debuff", {}):SetStackCount(1)
    	    	    end
    	    	end
			end
			ApplyCustomDamage(v, caster, cleave_percent * caster:GetAttackDamage(), 6, ability)
		end
	end
end