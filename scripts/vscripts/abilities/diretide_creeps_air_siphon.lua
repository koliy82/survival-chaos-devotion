function OnIntervalThink(event)
	local caster = event.caster
	local target = event.target
    local ability = event.ability
    
    if caster == nil or caster:IsNull() or not caster:IsAlive() then
        target:RemoveModifierByNameAndCaster("modifier_diretide_creeps_air_siphon", caster)
        return
    end

	local mana_drain = ability:GetLevelSpecialValueFor("mana_per_sec", (ability:GetLevel() - 1))
	local target_mana = target:GetMana()

	if target_mana and target_mana >= mana_drain then
		target:SpendMana(mana_drain, ability)
	else
		target:SpendMana(mana_drain, ability)
	end
end

function OnAttackLanded(event)
	local caster = event.caster
	local target = event.target
    local ability = event.ability
    
   if target:HasModifier("modifier_diretide_creeps_air_siphon") then
		ability:ApplyDataDrivenModifier(caster, caster, "modifier_diretide_creeps_air_siphon_ats", {})
   end
end