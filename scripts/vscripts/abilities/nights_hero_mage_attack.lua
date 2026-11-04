function OnAttacked( keys )
    local ability = keys.ability
    local level = ability:GetLevel()
    local caster = keys.caster
    local target = keys.attacker

    if not GameRules:IsDaytime() and target:GetTeam() == caster:GetTeam() then
        local lifesteal = ability:GetLevelSpecialValueFor( "lifesteal", ability:GetLevel() - 1 )
        target:Heal( target:GetAttackDamage() * lifesteal / 100, ability )

        local lifesteal_particle = "particles/items3_fx/octarine_core_lifesteal.vpcf" --particles/generic_gameplay/generic_lifesteal.vpcf
        local lifesteal_pfx = ParticleManager:CreateParticle(lifesteal_particle, PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
    end
end