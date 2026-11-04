function OnCreated( event )
	local caster = event.caster
    local ability = event.ability
    if caster and ability then
        caster.custom_block[0] = ability:GetLevelSpecialValueFor("damage_absorb", ability:GetLevel() - 1 )
    end
end

function OnDestroy( event )
	local caster = event.caster
    local ability = event.ability
    if caster and ability then
        caster.custom_block[0] = 0
    end
end