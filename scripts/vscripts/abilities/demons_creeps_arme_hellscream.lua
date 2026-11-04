function OnAttacked(keys)
	local caster = keys.caster
    local ability = keys.ability
    local level = ability:GetLevel()
    if level > 0 and ability:IsCooldownReady() and caster:GetMana() >= ability:GetManaCost(level - 1) then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_demons_creeps_arme_hellscream_buff", {})
		local radius = ability:GetLevelSpecialValueFor( "radius", level - 1 )
		local stun_duration = ability:GetLevelSpecialValueFor( "stun_duration", level - 1 )
		local stun_radius = ability:GetLevelSpecialValueFor( "stun_radius", level - 1 )
        local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false)
		for _,v in pairs(targets) do
			ability:ApplyDataDrivenModifier(caster, v, "modifier_demons_creeps_arme_hellscream_debuff", {})
		end
        targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, stun_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO, FIND_CLOSEST, false)
		for _,v in pairs(targets) do
            if not v:IsCustomHero() then
                v:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
            end
		end
        
        caster:SpendMana(ability:GetManaCost(level - 1), ability)

        local cooldown = ability:GetEffectiveCooldown(ability:GetLevel())
	    ability:StartCooldown(cooldown)
    end
end