function OnAttackLanded(keys)
    local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel()
    local chance = ability:GetLevelSpecialValueFor("chance", level - 1)
    local abil1 = caster:FindAbilityByName("nagas_creeps_mage_adaptive_strike")
    if abil1 and abil1:GetLevel() > 0 and ability:IsCooldownReady() and RollPercentage(chance) then
        local target = keys.target
        local part = ParticleManager:CreateParticle( "particles/units/heroes/hero_morphling/morphling_adaptive_strike.vpcf", PATTACH_ABSORIGIN, target )
        ParticleManager:SetParticleControlEnt( part, 1, target, PATTACH_ABSORIGIN, nil, target:GetOrigin(), true )
        ParticleManager:ReleaseParticleIndex( part )
        
        target:EmitSound( "Hero_Morphling.AdaptiveStrikeAgi.Target" )
        local damage = abil1:GetLevelSpecialValueFor("damage", abil1:GetLevel() - 1)
        
        ApplyCustomDamage(target, caster, damage, 6, ability)
        local cooldown = ability:GetEffectiveCooldown(level)
	    ability:StartCooldown(cooldown)
    end
end