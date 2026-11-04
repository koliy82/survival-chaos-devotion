function OnIntervalThink( keys )
    local caster = keys.caster
    local target = keys.target

    if not (caster and caster:IsAlive()) then
        target:RemoveModifierByName("modifier_diretide_hero_tank_bonds_hero_friends")
        return
    end

    -- local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	-- local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	-- local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
    
    -- local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, 3000, target_teams, target_types, target_flags, 0, false)
	-- local hero
	-- for i,unit in ipairs(units) do
    --     if unit:FindModifierByName("modifier_diretide_hero_tank_bonds_hero_buff") then
	-- 		hero = unit
    --         break
	-- 	end
	-- end

    if caster and target then
        local particle = ParticleManager:CreateParticle("particles/econ/items/undying/fall20_undying_head/fall20_undying_soul_rip_damage.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle, 1, caster:GetAbsOrigin())
    end
end

function OnTakeDamage( keys )
    local caster = keys.caster
    local unit = keys.unit
    if not (caster and caster:IsAlive()) or not unit:IsAlive() then
        unit:RemoveModifierByName("modifier_diretide_hero_tank_bonds_hero_friends")
        return
    end
    local damage = keys.damage
    local attacker = keys.attacker
    local ability = keys.ability
    local damage_red_prc = ability:GetLevelSpecialValueFor("damage_red_prc", ability:GetLevel() - 1 )
    
    local damageTable = {
        victim = caster,
        attacker = attacker,
        damage = damage * (100 - damage_red_prc)/100,
        damage_type = DAMAGE_TYPE_PURE,
    }
    
    ApplyDamage(damageTable)
end