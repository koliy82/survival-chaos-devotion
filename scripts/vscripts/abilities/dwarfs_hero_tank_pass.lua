function OnAttacked( keys )
	local caster = keys.caster
    local ability = keys.ability
    if not ability.attacks then
        ability.attacks = 0
    end
    ability.attacks = ability.attacks + 1
    if ability.attacks >= 3 then
        ability.attacks = 0
        local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false)
        local mod = caster:FindModifierByName("modifier_dwarfs_hero_tank_pass")
        if #targets > 0 and mod:GetStackCount() > 0 then
            local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )
            local max_stacks = ability:GetLevelSpecialValueFor( "max_stacks", ability:GetLevel() - 1 )
            mod:SetStackCount(mod:GetStackCount()-1)
            if mod:GetStackCount() == max_stacks-1 then
                OnCreated(keys)
            end
            ApplyCustomDamage(targets[1], caster, damage, 6, ability)
        end
    end
end

function OnCreated( keys )
	local caster = keys.caster
    local ability = keys.ability
    local mod = caster:FindModifierByName("modifier_dwarfs_hero_tank_pass")
    local max_stacks = ability:GetLevelSpecialValueFor( "max_stacks", ability:GetLevel() - 1 )
    Timers:CreateTimer(8, function()
        if caster and caster:IsAlive() then
            if mod:GetStackCount() < max_stacks then
                mod:SetStackCount(mod:GetStackCount()+1)
                return 8
            end
        end
    end)
end