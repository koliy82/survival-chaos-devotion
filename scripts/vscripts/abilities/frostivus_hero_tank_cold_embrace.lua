LinkLuaModifier( "agr_mod", "modifiers/agr_mod.lua", LUA_MODIFIER_MOTION_NONE )

function OnTakeDamage( event )
	-- Variables
	local caster = event.caster
	local ability = event.ability
	local level = ability:GetLevel()
	local threshold = ability:GetLevelSpecialValueFor( "hp_perc" , level - 1  )

	-- Apply the modifier
	if level > 0 and caster:GetHealthPercent() < threshold and ability:GetCooldownTimeRemaining() == 0 and caster:GetMana() >= ability:GetManaCost(level-1) then
        local dur = ability:GetLevelSpecialValueFor( "duration" , level - 1  )
        local shield = ability:GetLevelSpecialValueFor( "shield" , level - 1  )
        local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1  )
        --local dpsp = ability:GetLevelSpecialValueFor( "dpsp" , level - 1  )
        local max_dmg = ability:GetLevelSpecialValueFor( "max_dmg" , level - 1  )
    
	    local cooldown = ability:GetEffectiveCooldown( ability:GetLevel() )
		caster:SpendMana(ability:GetManaCost(level-1), ability)
		ability:StartCooldown( cooldown )
        
        local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
        local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
        local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

        local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
        for _,unit in ipairs(units) do
            unit:AddNewModifier(caster, ability, "agr_mod", {duration = dur})
        end

        local mod = caster:AddBarrier(shield, 0, dur, caster, ability)
        
        function mod:CheckState()
            return {
                [MODIFIER_STATE_FROZEN] = true,
                [MODIFIER_STATE_STUNNED] = true
            }
        end

        function mod:OnDestroy()
            --local damage = (shield - mod.durability) * dpsp
            --if damage > max_dmg then
            --    damage = max_dmg
            --end
            
            local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
            for _,unit in ipairs(units) do
                ApplyCustomDamage(unit, caster, max_dmg, 6, ability)
            end
            local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_winter_wyvern/wyvern_splinter_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
            ParticleManager:SetParticleControlEnt(pfx, 1, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
            ParticleManager:SetParticleControlEnt(pfx, 3, caster, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
            -- ParticleManager:SetParticleControl( pfx, 2, Vector(radius, radius, radius) )
        end
        -- caster:EmitSound("Hero_Abaddon.BorrowedTime")
        
        local part = ParticleManager:CreateParticle("particles/econ/items/winter_wyvern/winter_wyvern_ti7/wyvern_cold_embrace_ti7buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
        mod:AddParticle(part, false, false, 0, false, false)
	end
end
