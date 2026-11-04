function OnAttacked( keys )
    local ability = keys.ability
    if ability:IsCooldownReady() then
        local level = ability:GetLevel()
        local caster = keys.caster
        local target = keys.attacker
        if target and not target:IsAncient() and (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= 250 then
            ability:StartCooldown( ability:GetEffectiveCooldown(level-1) )
            local lifesteal = ability:GetLevelSpecialValueFor( "lifesteal", ability:GetLevel() - 1 )
			caster:EmitSound("Hero_LegionCommander.Courage")
            caster:StartGesture(ACT_DOTA_CAST_ABILITY_3)
            ParticleManager:CreateParticle( "particles/units/heroes/hero_legion_commander/legion_commander_courage_hit.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
            caster:PerformAttack(target, true, true, true, false, false, false, false)
            caster:Heal( caster:GetAttackDamage()*lifesteal/100, ability )--lifesteal
        end
    end
end