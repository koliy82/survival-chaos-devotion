function OnAttackLanded( keys )
    local caster = keys.caster
    local target = keys.target
    local mod = keys.modifier

    if target:FindModifierByName(mod) then
        target:RemoveModifierByName(mod)
    end
end

function OnDeath( keys )
    local caster = keys.caster
    local target = keys.target
    local ability = keys.ability
    local mod = keys.modifier

	local radius = ability:GetLevelSpecialValueFor("explosion_radius", ability:GetLevel() - 1)
	local damage = ability:GetLevelSpecialValueFor("explosion_damage", ability:GetLevel() - 1)

    local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local target_flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
    
    local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
	
	for i,unit in ipairs(units) do
        if not unit:FindModifierByNameAndCaster("modifier_diretide_hero_tank_slugs_master", caster) then
			ability:ApplyDataDrivenModifier( caster, unit, mod, {})
		end
        ApplyCustomDamage(unit, caster, damage, 6, ability)
	end
end