function OnTakeDamage( event )
	local caster = event.caster
    local ability = event.ability
    local block_chance = ability:GetLevelSpecialValueFor("chance", ability:GetLevel() - 1 )
    if caster and ability then
        if RollPercentage(block_chance) then
            caster.custom_block[0] = 999999
        else
            caster.custom_block[0] = 0
        end
    end
end