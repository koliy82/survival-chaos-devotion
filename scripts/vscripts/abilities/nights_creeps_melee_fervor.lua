function Fervor( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local modifier = keys.modifier
	local modifier1 = keys.modifier1
	local max_stacks = ability:GetLevelSpecialValueFor("max_stacks", ability_level)

	-- Check if we have an old target
	if caster.fervor_target then
		-- Check if that old target is the same as the attacked target
		if caster.fervor_target == target then
			-- Check if the caster has the attack speed modifier
			if caster:HasModifier(modifier) then
				-- Get the current stacks
				local stack_count = caster:GetModifierStackCount(modifier, ability)

				-- Check if the current stacks are lower than the maximum allowed
				if stack_count < max_stacks then
					-- Increase the count if they are
					caster:SetModifierStackCount(modifier, ability, stack_count + 1)
				end
				if caster:HasModifier("modifier_nights_creeps_melee_crit_buff") then
					if stack_count + 1 < max_stacks then
						-- Increase the count if they are
						caster:SetModifierStackCount(modifier, ability, stack_count + 2)
					end 
				end
			else
				-- Apply the attack speed modifier and set the starting stack number
				ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
				caster:SetModifierStackCount(modifier, ability, 1)
				if caster:HasModifier("modifier_nights_creeps_melee_crit_buff") then
					caster:SetModifierStackCount(modifier, ability, 2)
				end
			end
			--local check_cast = false
			--if not GameRules:IsDaytime() then check_cast = true end
			--if not caster:IsCustomHero() and caster:HasModifier("modifier_nights_hero_tank_midnight_buff") then check_cast = true end
			--if caster:HasModifier("modifier_nights_ancient_day_aura_buff") and RollPercentage(40) then check_cast = true end
			--if check_cast == true then
			--	ability:ApplyDataDrivenModifier(caster, caster, modifier1, {})
				--if caster:HasModifier(modifier1) then
				--	-- Get the current stacks
				--	local stack_count = caster:GetModifierStackCount(modifier1, ability)
				--
				--	-- Check if the current stacks are lower than the maximum allowed
				--	if stack_count < max_stacks then
				--		-- Increase the count if they are
				--		caster:SetModifierStackCount(modifier1, ability, stack_count + 1)
				--	end
				--	if caster:HasModifier("modifier_nights_creeps_melee_crit_buff") then
				--		if stack_count + 1 < max_stacks then
				--			-- Increase the count if they are
				--			caster:SetModifierStackCount(modifier1, ability, stack_count + 2)
				--		end 
				--	end
				--else
				--	-- Apply the attack speed modifier and set the starting stack number
				--	ability:ApplyDataDrivenModifier(caster, caster, modifier1, {})
				--	caster:SetModifierStackCount(modifier1, ability, 1)
				--	if caster:HasModifier("modifier_nights_creeps_melee_crit_buff") then
				--		caster:SetModifierStackCount(modifier1, ability, 2)
				--	end
				--end
			--end
		else
			-- If its not the same target then set it as the new target and remove the modifier
			caster:RemoveModifierByName(modifier)
			caster:RemoveModifierByName(modifier1)
			caster.fervor_target = target
		end
	else
		ability:ApplyDataDrivenModifier(caster, caster, modifier, {})
		caster:SetModifierStackCount(modifier, ability, 1)
		if caster:HasModifier("modifier_nights_creeps_melee_crit_buff") then
			caster:SetModifierStackCount(modifier, ability, 2)
		end
		local check_cast = false
		if not GameRules:IsDaytime() then check_cast = true end
		if not caster:IsCustomHero() and caster:HasModifier("modifier_nights_hero_tank_midnight_buff") then check_cast = true end
		if caster:HasModifier("modifier_nights_ancient_day_aura_buff") then check_cast = true end
		if check_cast == true then
			ability:ApplyDataDrivenModifier(caster, caster, modifier1, {})
		end
		caster.fervor_target = target
	end
end