function OnAttackLanded( event )
	local caster = event.caster
    local ability = event.ability
    local target = event.target

    if target:IsAncient() or target:IsCustomHero() then return end

    if target then
        EmitSoundOn("Hero_FacelessVoid.TimeLockImpact", target)
        local nFX = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(nFX, 0, target:GetAbsOrigin() )
		ParticleManager:SetParticleControl(nFX, 1, target:GetAbsOrigin() )
        ParticleManager:SetParticleControlEnt(nFX, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(nFX, 4, target:GetAbsOrigin() )
		ParticleManager:SetParticleControl(nFX, 5, Vector(1,1,1) )
		ParticleManager:ReleaseParticleIndex(nFX)
        
        ApplyCustomDamage(target, caster, event.damage, 6, ability)
        target:AddNewModifier(caster, ability, "modifier_stunned", {Duration = event.duration})

		local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	    local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	    local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO

        local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, event.radius, target_teams, target_types, target_flags, FIND_CLOSEST, false)
	    if #units > 0 then
            if units[2] then
                EmitSoundOn("Hero_FacelessVoid.TimeLockImpact", units[2])
                local nFX = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_time_lock_bash.vpcf", PATTACH_ABSORIGIN, caster)
		        ParticleManager:SetParticleControl(nFX, 0, units[2]:GetAbsOrigin() )
		        ParticleManager:SetParticleControl(nFX, 1, units[2]:GetAbsOrigin() )
                ParticleManager:SetParticleControlEnt(nFX, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		        ParticleManager:SetParticleControl(nFX, 4, units[2]:GetAbsOrigin() )
		        ParticleManager:SetParticleControl(nFX, 5, Vector(1,1,1) )
		        ParticleManager:ReleaseParticleIndex(nFX)
                
                ApplyCustomDamage(units[2], caster, event.damage, 6, ability)
                units[2]:AddNewModifier(caster, ability, "modifier_stunned", {Duration = event.duration})
            end
        end
    end
end