function OnTakeDamage( event )
	local ability = event.ability
    local level = ability:GetLevel()

    if level > 0 and ability:IsCooldownReady() then
        ability:StartCooldown(ability:GetEffectiveCooldown(level))
        local damage = ability:GetLevelSpecialValueFor( "damage", level - 1 )
        local radius = ability:GetLevelSpecialValueFor( "radius", level - 1 )
	
        local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
        local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
        local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS 
        
	    local caster = event.caster
    
        local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
        
        for i,unit in pairs(units) do
            ApplyCustomDamage(unit, caster, damage, 6, ability)
        end
        
        local part = ParticleManager:CreateParticle( "particles/units/heroes/hero_bristleback/bristleback_quill_spray.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
    end
end