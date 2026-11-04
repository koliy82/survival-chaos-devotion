function OnAttackLanded( event )
	local caster = event.caster
    local ability = event.ability
    local target = event.target

    if target:IsAncient() then return end

    if target then
		local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	    local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	    local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

        local units = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, event.radius, target_teams, target_types, target_flags, FIND_ANY_ORDER, false)
	    if #units > 0 then
            if units[1] then
                EmitSoundOn("Hero_FacelessVoid.TimeLockImpact", units[1])
                local nFX = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_arcana/faceless_void_arcana_time_lock_tentacle_bash.vpcf", PATTACH_ABSORIGIN, caster)
		        ParticleManager:SetParticleControl(nFX, 0, units[1]:GetAbsOrigin() )
		        ParticleManager:SetParticleControl(nFX, 1, units[1]:GetAbsOrigin() )
                ParticleManager:SetParticleControlEnt(nFX, 2, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		        ParticleManager:SetParticleControl(nFX, 4, units[1]:GetAbsOrigin() )
		        ParticleManager:SetParticleControl(nFX, 5, Vector(1,1,1) )
		        ParticleManager:ReleaseParticleIndex(nFX)
                
                ApplyCustomDamage(units[1], caster, caster:GetAttackDamage() * event.damage / 100, 6, ability)
                --units[1]:AddNewModifier(caster, ability, "modifier_stunned", {Duration = event.duration})
            end
        end
    end
end