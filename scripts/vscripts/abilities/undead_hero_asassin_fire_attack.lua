function OnAttackLanded(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    if level > 0 then
        local need_attack = ability:GetLevelSpecialValueFor( "need_attack" , level - 1  )
        local mod = caster:FindModifierByName("modifier_undead_hero_asassin_fire_attack")
        mod:SetStackCount(mod:GetStackCount()+1)
        if mod:GetStackCount() >= need_attack then
            mod:SetStackCount(0)
            ability:ApplyDataDrivenModifier(caster, target, "modifier_undead_hero_asassin_fire_attack_debuff", {})
        end
    end
end

function OnDeath( event )
	local caster	= event.caster
	
	StartSoundEvent("clinkz_clinkz_immort_02", caster)
end