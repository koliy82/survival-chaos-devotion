function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    if caster:GetLevel() >= 3 then
        ability:SetLevel(2)
    end
end

function OnSpellStart(event)
    local caster = event.caster
    local target = event.target
    local damage = event.damage
    local ability = event.ability
    if target:IsCustomHero() then
        Timers:CreateTimer( 1.2, function()
            if target and target:IsAlive() then
                if target:GetHealth() <= damage then
                    target:EmitSound("General.Coins")
                    PlayerResource:ModifyGold(caster:GetPlayerOwnerID(), event.gold, false, DOTA_ModifyGold_CreepKill)
                end

                local damageTable = {
                    victim = target,
                    attacker = caster,
                    damage = damage,
                    damage_type = DAMAGE_TYPE_PURE,
                    ability = ability
                }
                ApplyDamage(damageTable)
            end
        end)

        local ScytheParticle = ParticleManager:CreateParticle("particles/econ/items/necrolyte/necronub_scythe/necrolyte_scythe_ka_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)

        ParticleManager:SetParticleControlEnt(ScytheParticle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(ScytheParticle, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
    else
        caster:GiveMana(ability:GetManaCost(ability:GetLevel()))
        ability:EndCooldown()
    end
end