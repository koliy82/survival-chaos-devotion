function OnAttackStart(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    if level > 0 then
        local need_attack = ability:GetLevelSpecialValueFor( "need_attack" , level - 1  )
        local mod = caster:FindModifierByName("modifier_nagas_creeps_range_split_shot_counter")
        mod:SetStackCount(mod:GetStackCount() + 1 )
        if mod:GetStackCount() >= need_attack then
            mod:SetStackCount(0)
            local max_targets = ability:GetLevelSpecialValueFor( "max_targets" , level - 1 )
            local find_range = ability:GetLevelSpecialValueFor( "bonus_range" , level - 1 ) + caster:Script_GetAttackRange()
            local casterPos = caster:GetAbsOrigin()

            local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
			local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
			local enemies =  FindUnitsInRadius(caster:GetTeamNumber(), casterPos, nil, find_range, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)

			if #enemies > 0 then
                for k,unit in ipairs(enemies) do
                    if k > max_targets then break end

                    ProjectileManager:CreateTrackingProjectile( {
                        Target = unit,
                        Source = caster,
                        Ability = ability,
                        EffectName = "particles/units/heroes/hero_medusa/medusa_mystic_snake_projectile.vpcf",
                        iMoveSpeed = 1000,
                        bDodgeable = false,
                        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION
                    } )
                end
            end
        end
    end
end

function OnProjectileHitUnit(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability

    local poison_ability = caster:FindAbilityByName("nagas_creeps_range_poison_sting")
    if poison_ability then
        if poison_ability:GetLevel() > 0 then
            local duration = ability:GetLevelSpecialValueFor( "duration" , ability:GetLevel() - 1  )
            if target:HasModifier("modifier_nagas_creep_range_poison_sting_damage_and_debuff") then
	            target:FindModifierByName("modifier_nagas_creep_range_poison_sting_damage_and_debuff"):SetStackCount(2)
            else
	            poison_ability:ApplyDataDrivenModifier(caster, target, "modifier_nagas_creep_range_poison_sting_damage_and_debuff", {Duration = duration})
            end
        end
    end
    local damage = ability:GetLevelSpecialValueFor( "damage" , ability:GetLevel() - 1  ) / 100
    ApplyCustomDamage(target, caster, damage*caster:GetAttackDamage(), caster.custom_damage_type, ability)
end