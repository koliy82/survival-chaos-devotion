function OnCreated(keys)
	local caster = keys.caster
    
    caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
    caster:SetRangedProjectileName("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf")
end

function OnDestroy(keys)
	local caster = keys.caster
    
    caster:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
end