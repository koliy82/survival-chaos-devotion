function OnAttackLanded( keys )
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	
    if ability:GetLevel() > 0 and ability:IsCooldownReady() then
        local modifDuration = ability:GetLevelSpecialValueFor( "duration", ( ability:GetLevel() - 1 ) )
        local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY
        local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
        local targetFlag = DOTA_UNIT_TARGET_FLAG_NONE
        local radius = ability:GetLevelSpecialValueFor( "radius", ( ability:GetLevel() - 1 ) )

        local point = target:GetAbsOrigin()
        local fxIndex = ParticleManager:CreateParticle( "particles/econ/items/monkey_king/arcana/fire/mk_arcana_fire_spring_cast_ringouterpnts.vpcf", PATTACH_CUSTOMORIGIN, caster )
        ParticleManager:SetParticleControl( fxIndex, 0, point )
        local fxIndex2 = ParticleManager:CreateParticle( "particles/units/heroes/hero_clinkz/clinkz_burning_army_start_flames.vpcf", PATTACH_CUSTOMORIGIN, caster )
        ParticleManager:SetParticleControl( fxIndex2, 0, point )
        
        local units = FindUnitsInRadius( caster:GetTeamNumber(), point, nil, radius, targetTeam, targetType, targetFlag, FIND_ANY_ORDER, false )
        for k, v in pairs( units ) do
            ability:ApplyDataDrivenModifier(caster, v, "modifier_demons_hero_mage_burn_debuff", {duration = modifDuration})
        end
        local ability = keys.ability
        ability:StartCooldown(ability:GetEffectiveCooldown(ability:GetLevel()))
    end
end