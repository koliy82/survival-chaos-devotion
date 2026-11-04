function OnAttackLanded(keys)
	local caster = keys.caster
    local target = keys.target
    if target and target:IsAlive() and not target:IsCustomHero() and not target:IsAncient() and not target:IsMagicImmune() then
        target:SetTeam(caster:GetTeam())
        target.FirstOwner = target.FirstOwner or target:GetOwner()
        target:SetOwner(caster:GetOwner())
        target.previous_point = caster.previous_point
        target.to_point = caster.to_point
        target:SetHealth(target:GetMaxHealth())
    end
end