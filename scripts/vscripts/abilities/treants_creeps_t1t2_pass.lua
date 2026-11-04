function OnTakeDamage( event )
	local ability = event.ability
    local level = ability:GetLevel()
    
    if level > 0 and ability:IsCooldownReady() then
        ability:StartCooldown(ability:GetEffectiveCooldown(level))
        local damage = ability:GetLevelSpecialValueFor( "damage", level - 1 )
        local radius = ability:GetLevelSpecialValueFor( "radius", level - 1 )
        
	    local caster = event.caster
	
        local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
        local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
        local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
        
        local burst_point = caster:GetAbsOrigin()

        local units = FindUnitsInRadius(caster:GetTeamNumber(), burst_point, nil, radius, target_teams, target_types, target_flags, 0, false)
        
        if caster:IsAncient() then
            radius = ability:GetLevelSpecialValueFor( "buildings_radius", level - 1 )
            burst_point = event.target:GetAbsOrigin()
            units = FindUnitsInRadius(caster:GetTeamNumber(), burst_point, nil, radius, target_teams, target_types, target_flags, 0, false)
            local part = ParticleManager:CreateParticle( "particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target )
        end
        
        for i,unit in pairs(units) do
            ApplyCustomDamage(unit, caster, damage, 6, ability)
        end
        
        local part = ParticleManager:CreateParticle( "particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
    end
end