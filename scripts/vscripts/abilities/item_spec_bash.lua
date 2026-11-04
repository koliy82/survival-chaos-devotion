function OnAttackLanded(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    if target and target:IsAlive() and ability:IsCooldownReady() and not target:IsAncient() and not caster:IsIllusion() then
		--local random_int = RandomInt(1, 100)
        --local chance = event.chance
        --if random_int <= chance then

            local damage = event.stun_damage
            local stun_duration = event.stun_duration

            target:EmitSound("DOTA_Item.SkullBasher")
            target:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
            ApplyCustomDamage(target, caster, damage, caster.custom_damage_type, ability)

            ability:StartCooldown(ability:GetEffectiveCooldown(ability:GetLevel()))
        --end
    end
end