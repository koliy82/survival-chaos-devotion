function OnCreated(event)
    event.caster:FindModifierByName("modifier_primordials_spec_towers_thundergod"):SetStackCount(event.charges)
end

function OnSpellStart(event)
    local caster = event.caster
    local target = event.target
    local damage = event.damage
    local ability = event.ability
    local mod = caster:FindModifierByName("modifier_primordials_spec_towers_thundergod")
    if mod:GetStackCount() == nil then 
        mod:SetStackCount(event.charges)
    end
    if _G.playersinfo[caster:GetPlayerOwnerID()].ancient and not target:IsAncient() and not target:IsCustomHero() and mod:GetStackCount() > 0 then
        mod:SetStackCount(mod:GetStackCount() - 1)

		Timers:CreateTimer(event.cooldown, function()
            mod:SetStackCount(mod:GetStackCount() + 1)
        end)

	    EmitSoundOn("Hero_Zuus.GodsWrath", caster)
        local damageTable = {
            victim = target,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_PURE,
            ability = ability
        }
        ApplyDamage(damageTable)

        local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_WORLDORIGIN, target)
        ParticleManager:SetParticleControl(particle, 0, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
        ParticleManager:SetParticleControl(particle, 1, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,2000 ))
        ParticleManager:SetParticleControl(particle, 2, Vector(target:GetAbsOrigin().x,target:GetAbsOrigin().y,target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))
        
	    EmitSoundOn("Hero_Zuus.GodsWrath.Target", target)
    end
end