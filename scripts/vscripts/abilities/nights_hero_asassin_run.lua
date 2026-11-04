function OnAttackLanded(keys)
	local caster = keys.caster
	local ability = keys.ability
    local level = ability:GetLevel()
	if level > 0 and ability:IsCooldownReady() and caster:GetMana() >= ability:GetManaCost(level) then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_nights_hero_asassin_run_caster_buff", {})
		ability:StartCooldown(ability:GetEffectiveCooldown(level))
		caster:SpendMana(ability:GetManaCost(level), ability)
	end
end

function OnIntervalThink(event)
    event.target:Purge(true, false, false, false, false)
end

function AttackHero(event)
	local caster = event.caster
	local ability = event.ability
	local target = event.target

	local hero_damage = ability:GetLevelSpecialValueFor( "hero_damage" , ability:GetLevel() - 1 )
	local stun_duration = ability:GetLevelSpecialValueFor( "stun_duration" , ability:GetLevel() - 1 )

	if target:IsCustomHero() then
		ApplyCustomDamage(target, caster, hero_damage, 6, ability)
		target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
		--if not GameRules:IsDaytime() then
		--	ability:ApplyDataDrivenModifier(caster, target, "modifier_nights_hero_asassin_run_debuff", {})
		--end
	end

	--if not GameRules:IsDaytime() then
	--	caster:FindAbilityByName("nights_hero_asassin_unleash"):EndCooldown()
	--	ability:ApplyDataDrivenModifier(caster, target, "modifier_nights_hero_asassin_run_debuff", {})
	--end
end