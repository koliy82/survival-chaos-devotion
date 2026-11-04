function OnSpellStart( keys )
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local target = keys.target
	local particle_name = "particles/units/heroes/hero_elder_titan/elder_titan_earth_splitter.vpcf"
	-- Parameters
	local crack_time = ability:GetLevelSpecialValueFor("crack_time", ability_level)
	local speed = ability:GetLevelSpecialValueFor("projectile_speed", ability_level)
	local crack_width = ability:GetLevelSpecialValueFor("crack_width", ability_level)
    local crack_distance = ability:GetLevelSpecialValueFor("crack_distance", ability_level)
    local damage = ability:GetLevelSpecialValueFor("damage", ability_level)
    local forward_direction = caster:GetForwardVector()
    local rots = {
        [DOTA_TEAM_GOODGUYS] = {180, -90, 0},
        [DOTA_TEAM_BADGUYS] = {90, 0, -90},
        [DOTA_TEAM_CUSTOM_1] = {180, 90, 0},
        [DOTA_TEAM_CUSTOM_2] = {90, 180, -90}
    }
    
    local casterOrigin = caster:GetAbsOrigin()
    
    local end_poses = {}
    for i=1, #rots[caster:GetTeam()] do
        local wave_direction = (RotatePosition(Vector(0, 0, 0), QAngle(0, rots[caster:GetTeam()][i], 0), forward_direction)):Normalized()
        local end_location = casterOrigin + (crack_distance *  wave_direction) * (3.14/crack_time)
        table.insert( end_poses, end_location )

		local particle = ParticleManager:CreateParticle(particle_name, PATTACH_WORLDORIGIN, caster)
		ParticleManager:SetParticleControl(particle, 0, casterOrigin)
		ParticleManager:SetParticleControl(particle, 1, end_location)
		ParticleManager:SetParticleControl(particle, 3, Vector(0,crack_time,0))
		ParticleManager:ReleaseParticleIndex(particle)
    end
    Timers:CreateTimer( crack_time, function()
        -- for _,end_pos in pairs(end_poses) do
        --     local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
        --     local types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
        --     local flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS        
            
        --     local units = FindUnitsInLine(caster:GetTeam(), casterOrigin, end_pos, caster, crack_width, teams, types, flags)

        --     for _,unit in pairs(units) do
        --         ability:ApplyDataDrivenModifier(caster, unit, "modifier_elementals_ancient_ability2_debuff", {})
        --         ApplyCustomDamage(unit, caster, damage, 6, ability)
        --     end
        -- end
	
        local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
        local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
        local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS 
    
        local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, crack_distance, target_teams, target_types, target_flags, 0, false)
        
        for i,unit in pairs(units) do
            ApplyCustomDamage(unit, caster, damage, 6, ability)
        end
        
    end)
end