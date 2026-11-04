function OnAbilityExecuted(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()

    local mod = caster:FindModifierByName("modifier_beastmen_creeps_arme_concentration_hp_regen")
    local stacks = mod:GetStackCount()
	local max_stacks = ability:GetLevelSpecialValueFor( "max_stacks", level - 1 )
    if stacks < max_stacks then
        mod:SetStackCount(stacks+1)
    end
end