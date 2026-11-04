function Start( keys )
    local caster = keys.caster
    -- local target = keys.target
    local ability = keys.ability
	local point = ability:GetCursorPosition()
    
    local anim_unit = CreateUnitByName("npc_dummy_unit", point, false, nil, nil, DOTA_TEAM_NEUTRALS)
    ability:ApplyDataDrivenModifier(caster, anim_unit, "modifier_diretide_ancient_ability1", {})
    anim_unit:SetModel("models/heroes/queenofpain/queenofpain.vmdl")
    anim_unit:SetModelScale(1)

    local caster_pos = caster:GetAbsOrigin()
    local angle = math.atan2(point.y - caster_pos.y, point.x - caster_pos.x );
    angle = angle * (180/math.pi);
    anim_unit:SetAngles(0, angle, 0)
    
    Wearable:WearDefaults(anim_unit)
    Wearable:Wear(anim_unit, 26)
    Wearable:Wear(anim_unit, 82)
    Wearable:Wear(anim_unit, 83)
    Wearable:Wear(anim_unit, 84)
    anim_unit:StartGesture(ACT_DOTA_CAST_ABILITY_2_END)
    StartSoundEvent( "Hero_QueenOfPain.Blink_out", anim_unit )
    ParticleManager:CreateParticle( "particles/units/heroes/hero_queenofpain/queen_blink_end.vpcf", PATTACH_ABSORIGIN, anim_unit )

    Timers:CreateTimer(0.5, function()
        anim_unit:StartGesture(ACT_DOTA_CAST_ABILITY_3)
        StartSoundEvent( "Hero_QueenOfPain.ScreamOfPain", anim_unit )
        ParticleManager:CreateParticle( "particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf", PATTACH_ABSORIGIN, anim_unit )
    end)
    Timers:CreateTimer(1.275, function()
        anim_unit:StartGesture(ACT_DOTA_CAST_ABILITY_2)
    end)
    Timers:CreateTimer(1.575, function()
        StartSoundEvent( "Hero_QueenOfPain.Blink_in", anim_unit )
        local part = ParticleManager:CreateParticle( "particles/units/heroes/hero_queenofpain/queen_blink_start.vpcf", PATTACH_ABSORIGIN, caster )
        ParticleManager:SetParticleControl(part, 0, point )
        anim_unit:RemoveSelf()
    end)
end