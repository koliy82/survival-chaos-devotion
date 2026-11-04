function OnAttackStart(keys)
	local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel()
    if level > 0 and ability:IsCooldownReady() then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_jungle_hero_tank_link_caster", {})
    end
end

function OnAttackLanded(keys)
	local caster = keys.caster
	local ability = keys.ability
	local cooldown = ability:GetEffectiveCooldown(ability:GetLevel())
	ability:StartCooldown(cooldown)
    caster:SpendMana(ability:GetManaCost(ability:GetLevel() - 1), ability)
end

function OnTakeDamage_enemy(keys)
	local ability = keys.ability
    local level = ability:GetLevel()
	local caster = keys.caster
    if caster then
        local mod = caster:FindModifierByName("modifier_jungle_hero_tank_link_debuff_self")
        if mod then
            stacks = mod:GetStackCount()
            new_stacks = stacks + keys.DamageTaken
            local damage_to_activate = ability:GetLevelSpecialValueFor( "damage_to_activate" , level - 1 )
            if new_stacks >= damage_to_activate then
                mod:SetStackCount(0)
                local heal = ability:GetLevelSpecialValueFor( "heal" , level - 1 ) 
                local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1 )    
                local target_teams = DOTA_UNIT_TARGET_TEAM_FRIENDLY
                local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
                local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
                local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)           
                for _,unit in ipairs(units) do
                    unit:Heal(heal, ability)
                end
            else
                mod:SetStackCount(stacks + keys.DamageTaken)
            end
        end
    end
end

function OnTakeDamage_friend(keys)
	local ability = keys.ability
    if ability then
        local level = ability:GetLevel()
        local caster = keys.caster
        if caster and caster:IsAlive() then
            local mod = caster:FindModifierByName("modifier_jungle_hero_tank_link_buff")
            if mod then
                stacks = mod:GetStackCount()
                new_stacks = stacks + keys.DamageTaken
                local damage_to_activate = ability:GetLevelSpecialValueFor( "damage_to_activate" , level - 1 )
                if new_stacks >= damage_to_activate then
                    mod:SetStackCount(0)
                    local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1 ) 
                    local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1 )    
                    local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
                    local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
                    local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
                    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)           
                    for _,unit in ipairs(units) do
                        ApplyCustomDamage(unit, caster, damage, 6, ability)
                    end
                else
                    mod:SetStackCount(stacks + keys.DamageTaken)
                end
            end
        end
    end
    
end