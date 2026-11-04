function OnCreatedShield( event )
    local target = event.target
    local ability = event.ability
    ability.damage_absorb = ability:GetLevelSpecialValueFor("damage_absorb", ability:GetLevel() - 1 )
    if ability.damage_absorb then
        target.custom_block[0] = target.custom_block[0] + ability.damage_absorb
    end
end

-- Destroys the particle when the modifier is destroyed. Also plays the sound
function EndShield( event )
	local target = event.target
    local ability = event.ability
	if target then
		target.custom_block[0] = target.custom_block[0] - ability.damage_absorb
	end
end