function OnAttacked(event)
    local caster = event.caster
    local ability = event.ability
    local damage = event.damage

    local level = ability:GetLevel()
    local damage_need = ability:GetLevelSpecialValueFor( "damage_need" , level - 1  )
    local mod_damage = caster:FindModifierByName("modifier_cultists_creeps_melee_armor")
    if mod_damage then
        local stacks = mod_damage:GetStackCount()
        if stacks < damage_need then
            mod_damage:SetStackCount(stacks + damage)
        else
            mod_damage:SetStackCount(stacks - damage_need + damage)
            if not caster:FindModifierByName("modifier_cultists_creeps_melee_armor_buff") then
                ability:ApplyDataDrivenModifier(caster, caster, "modifier_cultists_creeps_melee_armor_buff", {})
            end
            local mod_armor = caster:FindModifierByName("modifier_cultists_creeps_melee_armor_buff")
            if mod_armor then
                local stacks = mod_armor:GetStackCount()
                local maxstacks = ability:GetLevelSpecialValueFor( "max_stacks" , level - 1  )
                if stacks < maxstacks then
                    mod_armor:SetStackCount(stacks + 1)
                end
            end
        end
    end
end

function OnTakeDamage(event)
	local caster = event.caster
	local ability = event.ability
    local level = ability:GetLevel()
	local hp_cost = event.hp
	if level > 0 and ability:IsCooldownReady() and caster:GetHealth() > hp_cost and caster:GetHealthPercent() <= event.min_hp then
		ability:StartCooldown(ability:GetEffectiveCooldown(level))
		local damageTable = {
			victim = caster,
			attacker = caster,
			damage = hp_cost,
			damage_type = DAMAGE_TYPE_PURE
		}
		ApplyDamage(damageTable)

        local heal_start = ability:GetLevelSpecialValueFor( "heal_start" , level - 1  )
        local mod_armor = caster:FindModifierByName("modifier_cultists_creeps_melee_armor_buff")
        if mod_armor then
            local stacks = mod_armor:GetStackCount()
            local heal_per_stack = ability:GetLevelSpecialValueFor( "heal_per_stack" , level - 1  )
            caster:Heal(heal_per_stack * stacks, ability)
            mod_armor:SetStackCount(0)
        end
        caster:Heal(heal_start, ability)
    end
end