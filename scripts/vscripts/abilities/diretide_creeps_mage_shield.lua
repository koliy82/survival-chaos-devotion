function CastShield( event )
	local caster = event.caster
    local ability = event.ability
    local target = event.target
    
    local duration = ability:GetLevelSpecialValueFor("duration", ability:GetLevel() - 1 )

    if target:IsCustomHero() then
        duration = ability:GetLevelSpecialValueFor("duration_on_hero", ability:GetLevel() - 1 )
    end

    target.custom_block[0] = ability:GetLevelSpecialValueFor("damage_absorb", ability:GetLevel() - 1 )
    ability:ApplyDataDrivenModifier(caster, target, "modifier_diretide_creeps_mage_shield", {Duration = duration})
end

function OnDestroy( event )
    local target = event.target
    
    if target then
        target.custom_block[0] = 0
    end
end