function Proj(t)
	
	if t.caster:HasModifier("modifier_spiders_hero_mage_burrow_buff") then
		t.FixedDistance = t.FixedDistance+400
		Timers:CreateTimer(0.05,function()
			t.ability:EndCooldown()
			t.ability:StartCooldown(t.ability:GetEffectiveCooldown(t.ability:GetLevel()))
		end)
	end

	local linearProjectile = 
	{
		Ability = t.ability,
        EffectName = "particles/units/heroes/hero_nyx_assassin/nyx_assassin_impale.vpcf",
        vSpawnOrigin = t.caster:GetOrigin(),
        fDistance = t.FixedDistance,
        fStartRadius = t.StartRadius,
        fEndRadius = t.EndRadius,
        Source = t.caster,
        bHasFrontalCone = false,
        bReplaceExisting = false,
        iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
        iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
        iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		bDeleteOnHit = false,
		vVelocity = t.caster:GetForwardVector() * t.MoveSpeed
	}
	ProjectileManager:CreateLinearProjectile(linearProjectile)

end