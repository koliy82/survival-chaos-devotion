function Multicast( keys )
	local ability = keys.ability
    local ability_level = ability:GetLevel()
    if ability_level > 0 then
        local chance = ability:GetLevelSpecialValueFor("chance", ability_level-1)
        if RandomInt(1,100) <= chance then
            local caster = keys.caster
            local ability_cast
            Timers:CreateTimer(0.01, function()
		    	for i=0, caster:GetAbilityCount()-1 do
                    local abil = caster:GetAbilityByIndex(i)
                    if abil ~= nil then
                        local cd = abil:GetCooldownTimeRemaining()
		    		    local full_cd = abil:GetCooldown(abil:GetLevel()-1)

		    		    if cd > 0 and full_cd - cd < 0.3 then
		    		    	ability_cast = abil
		    		    end
                    end
                end
			    if ability_cast then
                    if ability_cast:GetAbilityName() == "dwarfs_creeps_mage_seeking_missile" then
                        ability_cast:ApplyDataDrivenModifier( caster, caster, "modifier_heat_seeking_missile_multicast", {Duration = 1} )
                    elseif ability_cast:GetAbilityName() == "dwarfs_creeps_mage_laser" then
                        ability_cast:ApplyDataDrivenModifier( caster, caster, "modifier_dwarfs_creeps_mage_laser_multicast", {Duration = 1} )
                    elseif ability_cast:GetAbilityName() == "dwarfs_creeps_mage_spec_gear" then
                        ability_cast:ApplyDataDrivenModifier( caster, caster, "dwarfs_creeps_mage_spec_gear_multicast", {Duration = 1} )
                    end
                end
            end)
        end
    end
end