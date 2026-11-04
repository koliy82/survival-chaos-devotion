function OnIntervalThink( keys )
	local ability = keys.ability
    local ability_level = ability:GetLevel()
    if ability_level > 0 then
	    ability:StartCooldown(ability:GetCooldown(ability_level))
        local chance = ability:GetLevelSpecialValueFor("chance", ability_level-1)
        if RandomInt(1,100) <= chance then
            local caster = keys.caster
            local mana = ability:GetLevelSpecialValueFor("mana", ability_level-1)
            caster:GiveMana(mana)
			for i=0, caster:GetAbilityCount()-1 do
				local abil = caster:GetAbilityByIndex(i)
				if abil and abil ~= ability and not abil:IsCooldownReady() then
                    abil:EndCooldown()
                end
            end
        end
    end
end