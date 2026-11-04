function OnAttackLanded(keys)
	local caster = keys.caster
    local ability = keys.ability
    local target = keys.target
    local level = ability:GetLevel()
    if level > 0 and ability:IsCooldownReady() and caster:GetMana() >= ability:GetManaCost(level - 1) and not target:IsAncient() then
		local radius = ability:GetLevelSpecialValueFor( "radius", level - 1 )
		local duration = ability:GetLevelSpecialValueFor( "duration", level - 1 )
		local damage = ability:GetLevelSpecialValueFor( "damage", level - 1 )
        local targets = FindUnitsInRadius(caster:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false)
		for _,v in pairs(targets) do
            if not v:IsCustomHero() then
			    ability:ApplyDataDrivenModifier(caster, v, keys.modifier, {Duration = duration})
            end
            ApplyCustomDamage(v, caster, damage, 6, ability)
		end
        local pfx = ParticleManager:CreateParticle("particles/econ/items/terrorblade/terrorblade_back_ti8/terrorblade_sunder_ti8_swirl_rope.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
        ParticleManager:ReleaseParticleIndex(pfx)
        
        caster:SpendMana(ability:GetManaCost(level - 1), ability)

        local cooldown = ability:GetEffectiveCooldown(ability:GetLevel())
	    ability:StartCooldown(cooldown)
    end
end