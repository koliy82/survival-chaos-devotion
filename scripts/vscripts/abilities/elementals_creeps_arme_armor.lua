function OnAttacked( event )
	local caster = event.caster
	local target = event.attacker
    local ability = event.ability
    local level = ability:GetLevel()
    local block_chance = ability:GetLevelSpecialValueFor("block_chance", level - 1 )
    if caster and target and target:IsAlive() and level > 0 and ability and ability:IsCooldownReady() and (caster:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= 250 then
        if RollPercentage(block_chance) then
            caster.custom_block[0] = 999999
		    Timers:CreateTimer( 0.5, function()
                EmitSoundOn("Hero_Spectre.Desolate", caster)

                local particle_name = "particles/units/heroes/hero_spectre/spectre_desolate.vpcf"
                local particle = ParticleManager:CreateParticle(particle_name, PATTACH_POINT, target)
                local pelel = caster:GetForwardVector()
                ParticleManager:SetParticleControl(particle, 0, Vector( target:GetAbsOrigin().x,
                                                                        target:GetAbsOrigin().y, 
                                                                        GetGroundPosition(target:GetAbsOrigin(), target).z + 140))
                                                                            
                ParticleManager:SetParticleControlForward(particle, 0, caster:GetForwardVector())
                caster:StartGesture(ACT_DOTA_ATTACK)
                caster:PerformAttack(target, true, true, true, false, false, false, false)
                local heal = ability:GetLevelSpecialValueFor("heal", level - 1 )
                caster:Heal( heal, ability )
                ability:StartCooldown(ability:GetEffectiveCooldown(level))
            end)
        else
            caster.custom_block[0] = 0
        end
    end
end