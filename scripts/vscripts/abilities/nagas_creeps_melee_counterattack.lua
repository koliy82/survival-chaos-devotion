function OnAttackLanded( keys )
    local ability = keys.ability
    local level = ability:GetLevel()
    if ability:IsCooldownReady() and level > 0 then
        ability:StartCooldown( ability:GetEffectiveCooldown(level-1) )
        local caster = keys.caster
        local target = keys.target
        if target then
		    Timers:CreateTimer( 0.5, function()
		    	caster:EmitSound("Hero_LegionCommander.Courage")
                caster:StartGesture(ACT_DOTA_ATTACK)
                ParticleManager:CreateParticle( "particles/units/heroes/hero_legion_commander/legion_commander_courage_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
                caster:PerformAttack(target, true, true, true, false, false, false, false)
            end)
        end
    end
end