function Projectile( event )
	local caster		= event.caster
	local ability		= event.ability
	local level = ability:GetLevel()

	local radius = ability:GetLevelSpecialValueFor("radius", level - 1)
	local distance = ability:GetLevelSpecialValueFor("distance", level - 1)
	local damage = ability:GetLevelSpecialValueFor("damage", level - 1)
	local duration = ability:GetLevelSpecialValueFor("duration", level - 1)

	local startPos = caster:GetAbsOrigin()
	local endPos = startPos + caster:GetForwardVector() * distance

	local debuff_ability = caster:FindAbilityByName("cultists_hero_mage_patogen")

	local units = FindUnitsInLine( caster:GetTeamNumber(), startPos, endPos, nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS)
	for _,unit in pairs(units) do
		local info = {
			Target = unit,
			Source = caster,
			Ability = ability,	
			EffectName = "particles/units/heroes/hero_dazzle/dazzle_poison_touch.vpcf",
			iMoveSpeed = 1000,
			bDodgeable = false,
			}
		ProjectileManager:CreateTrackingProjectile(info)
		debuff_ability:ApplyDataDrivenModifier(caster, unit, "modifier_cultists_hero_mage_patogen_debuff", { Duration = duration})

		if unit:GetTeamNumber() ~= caster:GetTeamNumber() then
			ApplyCustomDamage(unit, caster, damage, 6, ability)
		end
	end
end