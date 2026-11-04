function GiveMana(event)
    local caster = event.caster
    local mana = event.mana
    caster:GiveMana(mana)
end

function WitchBladeOnAttackLanded(event)
    local caster = event.caster
    local target = event.target
    local damage = event.damage
    local item = event.ability
    if target:IsCustomHero() then
        item:ApplyDataDrivenModifier(caster, target, "modifier_item_spec_witch_blade_debuff", {})
        ApplyCustomDamage(target, caster, damage, 6)
        caster:RemoveItem(item)
    end
end

function OrchidOnAttackLanded(event)
    local caster = event.caster
    local target = event.target
    local silence_duration = event.silence_duration
    local item = event.ability
    if target:IsCustomHero() then
        item:ApplyDataDrivenModifier(caster, target, "modifier_silence", {duration = silence_duration})
        item:ApplyDataDrivenModifier(caster, target, "modifier_item_spec_orchid_debuff", {})
        caster:RemoveItem(item)
    end
end

function OnDeath(event)
    local caster = event.caster
    local unit = event.unit
    local item = event.ability
    if unit:IsCustomHero() and item then
        local id = caster:GetPlayerOwnerID()
        local gold = event.gold
        PlayerResource:ModifyGold(id, gold, false, 0)
        item:ApplyDataDrivenModifier(caster, caster, "modifier_item_spec_fusion_rune_buff", {})
        caster:RemoveItem(item)
    end
end