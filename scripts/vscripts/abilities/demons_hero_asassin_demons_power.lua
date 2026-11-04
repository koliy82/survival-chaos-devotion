function OnSpellStart( keys )
	local ability = keys.ability
	local caster = keys.caster
    if ability:GetLevel() > 0 and ability:IsCooldownReady() then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_demons_hero_asassin_demons_power_crit", {})
        local fxIndex = ParticleManager:CreateParticle( "particles/econ/items/chaos_knight/chaos_knight_ti9_weapon/chaos_knight_ti9_weapon_blur_crit_arc.vpcf", PATTACH_POINT, caster )
        ParticleManager:SetParticleControl( fxIndex, 0, caster:GetAbsOrigin() )
    end
end

function StartCooldown(keys)
	local ability = keys.ability
	ability:StartCooldown(ability:GetEffectiveCooldown(ability:GetLevel()))
end