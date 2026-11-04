function OnSpellStart( keys )
	local ability = keys.ability
	local caster = keys.caster
    if ability:IsCooldownReady() then
        ability:ApplyDataDrivenModifier(caster, caster, "modofier_undead_creeps_siege_wraith", {})
    end
end

function StartCooldown(keys)
	local ability = keys.ability
	ability:StartCooldown(ability:GetEffectiveCooldown(ability:GetLevel()))
end