function OnOwnerDied(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius  = ability:GetSpecialValueFor("radius")
	local damage  = ability:GetSpecialValueFor("damage")
    
	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false)
	for _, target in pairs(targets) do
		ApplyCustomDamage(target, caster, caster:GetMaxHealth() * damage / 100, 6, ability)
	end
	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_remote_mines_detonate.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:ReleaseParticleIndex(pfx)
end