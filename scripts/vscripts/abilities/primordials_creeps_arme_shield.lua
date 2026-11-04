function OnTakeDamage( event )
	local caster = event.caster
    local ability = event.ability
    local block_chance = ability:GetLevelSpecialValueFor("chance", ability:GetLevel() - 1 )
    if caster and ability then
        --if caster:HasModifier("modifier_primordials_creeps_arme_rebuke_buff") then
        --    local spec_ability = caster:FindAbilityByName("primordials_creeps_arme_rebuke")
        --    if spec_ability then
        --        block_chance = block_chance * spec_ability:GetLevelSpecialValueFor("bonus_chance", spec_ability:GetLevel() - 1 )
        --    end
        --end

        if RollPercentage(block_chance) then
            caster.custom_block[0] = 999999
        else
            caster.custom_block[0] = 0
        end
    end
end