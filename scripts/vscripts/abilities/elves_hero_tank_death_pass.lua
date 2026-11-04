function OnTakeDamage( keys )
    local caster = keys.caster
    local ability = keys.ability
    if ability:IsCooldownReady() and caster:GetHealth() <= 0 and not caster:IsIllusion() then
        local percent = ability:GetLevelSpecialValueFor( "percent", ability:GetLevel() - 1 ) / 100
        caster:SetHealth( percent * caster:GetMaxHealth() )
        caster:SetMana( percent * caster:GetMaxMana() )
        ability:StartCooldown(ability:GetEffectiveCooldown(ability:GetLevel()-1))
        ability:ApplyDataDrivenModifier( caster, caster, "mod_elves_hero_tank_death_pass_buff", {} )
    end
end