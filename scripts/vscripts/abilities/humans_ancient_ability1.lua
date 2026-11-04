function FireEffect(event)
    local caster = event.caster
    local ability = event.ability
    local point = ability:GetCursorPosition()
    
    local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_legion_commander/legion_commander_odds_hero_arrow_group.vpcf", PATTACH_CUSTOMORIGIN, nil )
    ParticleManager:SetParticleControl(particle, 0, point)	
    ParticleManager:SetParticleControlEnt( particle, 1, caster, PATTACH_POINT_FOLLOW, "attach_part" , caster:GetOrigin(), true )
end