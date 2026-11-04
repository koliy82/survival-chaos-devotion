function OnSpellStart( keys )
	local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel()
    local spirits = ability:GetLevelSpecialValueFor( "spirits", ability:GetLevel() - 1 )
    local mod = caster:FindModifierByName("modifier_jungle_hero_tank_spirits")
    if mod then
        spirits = spirits + mod:GetStackCount()
        mod:SetStackCount(0)
    end
    local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1 ) 
    local radius = ability:GetLevelSpecialValueFor( "radius_damage" , level - 1 ) 
    local range = ability:GetCastRange(caster:GetOrigin(), nil) 
    local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
    local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, range, target_teams, target_types, target_flags, 0, false)   
    for x=1, spirits do 
        local target = units[RandomInt(1, #units)]
        local info = 
        {
        	Target = target,
        	Source = caster,
        	Ability = ability,	
        	EffectName = "particles/base_attacks/fountain_attack.vpcf",
        	iMoveSpeed = 900,
        	vSourceLoc= target:GetAbsOrigin(),                -- Optional (HOW)
        	bDodgeable = false,                                -- Optional
        	bProvidesVision = false,                          -- Optional
        }
        ProjectileManager:CreateTrackingProjectile(info) 
        local units_for_damage = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)   
           
        for _,unit in ipairs(units_for_damage) do
            ApplyCustomDamage(unit, caster, damage, 6, ability)
        end
    end
    if #ability.units_table <= 0 then
        ability:SetActivated(false)
    end
end

function OnDeath( keys )
    local caster = keys.caster
    if keys.unit:IsCustomHero() or keys.unit:GetOwner() ~= caster:GetOwner() then return end
    local ability = keys.ability
    if not ability.units_table then
        ability.units_table = {}
    end
    local mod = caster:FindModifierByName("modifier_jungle_hero_tank_spirits")
    if mod then
        mod:SetStackCount(mod:GetStackCount() + 1)
    end
end