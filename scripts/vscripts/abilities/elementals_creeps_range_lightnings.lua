function StartLightning(keys)
    local caster = keys.caster
    if keys.EnabledOnIllusion == 0 and caster:IsIllusion() then return end
	local ability = keys.ability
    local level = ability:GetLevel() - 1
    if level + 1 > 0 and caster:GetMana() >= ability:GetManaCost(level) then
	    local radius = keys.radius
	    local jump_delay = keys.jump_delay
        local jump_damage = keys.jump_damage
        local particle = keys.particle
	    local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
	    local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	    local targetFlag = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

        local source = caster
	    local target = keys.target
        if keys.TargetIsSource == 1 then
            source = keys.target
        end
	    local team = source:GetTeamNumber()
        if keys.AttackerIsTarget == 1 then
            target = keys.attacker
        end
        if target:IsAncient() then return end

        local lightning = {}
        lightning.jump_count = keys.jump_count
        lightning.instance = 0
        lightning.old_targets = {}
        lightning.old_targets[target] = true

        local source_origin = source:GetAbsOrigin()
        local bounding_maxs = source:GetBoundingMaxs()

        local lightningBolt = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, nil)
        ParticleManager:SetParticleControl(lightningBolt,0,Vector(source_origin.x, source_origin.y, source_origin.z + bounding_maxs.z ))
        source_origin = target:GetAbsOrigin()
        bounding_maxs = target:GetBoundingMaxs()
        ParticleManager:SetParticleControl(lightningBolt,1,Vector(source_origin.x, source_origin.y, source_origin.z + bounding_maxs.z ))

        ApplyCustomDamage(target, source, jump_damage, 6, ability)
        
		caster:SpendMana(ability:GetManaCost(level), ability)

        Timers:CreateTimer(jump_delay, function()
	    	-- Checks if there are jumps left
	    	if lightning.jump_count > lightning.instance then
	    		-- Finds units in the radius to jump to
	    		local units = FindUnitsInRadius(team, source_origin, nil, radius, targetTeam, targetType, targetFlag, FIND_CLOSEST, false)
	    		local new_target
	    		for i,unit in ipairs(units) do
	    			if lightning.old_targets[unit] == nil then
                        new_target = unit
                        break
	    			end
	    		end
	    		-- Checks if there is a new target
	    		if new_target ~= nil then
	    			-- Creates the particle between the new target and the last target
	    			local lightningBolt = ParticleManager:CreateParticle(particle, PATTACH_WORLDORIGIN, nil)
	    			ParticleManager:SetParticleControl(lightningBolt,0,Vector(source_origin.x, source_origin.y, source_origin.z + bounding_maxs.z ))
                    source_origin = new_target:GetAbsOrigin()
                    bounding_maxs = new_target:GetBoundingMaxs()
	    			ParticleManager:SetParticleControl(lightningBolt,1,Vector(source_origin.x, source_origin.y, source_origin.z + bounding_maxs.z ))

                    lightning.old_targets[new_target] = true

                    if caster:HasModifier("modifier_elementals_storm_buff") and keys.stun_duration then
                        if not new_target:IsCustomHero() then
                            new_target:AddNewModifier(caster, ability, "modifier_stunned", {duration = keys.stun_duration})
                        end
                    end

                    ApplyCustomDamage(new_target, source, jump_damage, 6, ability)

                    lightning.instance = lightning.instance + 1

                    return jump_delay
	    		end
	    	end
	    end)
    end
end