function OnCreated(keys)
	local target = keys.target
    
    target:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
    --target:SetRangedProjectileName("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf")
end

function OnDestroy(keys)
	local target = keys.target
    
    target:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
end