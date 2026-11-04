function EatTarget(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    ability:ApplyDataDrivenModifier(caster, caster, "modifier_waiting", {})
    ability:ApplyDataDrivenModifier(caster, target, "modifier_target_waiting", {})
    target:AddNoDraw()
    FindClearSpaceForUnit(target, caster:GetAbsOrigin(), false)
end

function OnDestroyModifier(event)
    local caster = event.caster
    local target = event.target
    if caster and caster:IsAlive() then
        local ability = event.ability
        local level = ability:GetLevel()
        local spec_ability = caster:FindAbilityByName("treants_creeps_arme_death_pass")
        if spec_ability then
            local gold = spec_ability:GetLevelSpecialValueFor("gold", spec_ability:GetLevel() - 1)
		    local id = caster:GetPlayerOwnerID()
            
		    caster:EmitSound("General.Coins")
		    PlayerResource:ModifyGold(id, target:GetMaximumGoldBounty() * gold / 100, false, DOTA_ModifyGold_CreepKill)
        end
        local hp = ability:GetLevelSpecialValueFor( "hp" , level - 1  )
        FindClearSpaceForUnit(target, caster:GetAbsOrigin(), false)
        target:RemoveNoDraw()
        target:SetTeam(caster:GetTeam())
        target.FirstOwner = target.FirstOwner or target:GetOwner()
        target:SetOwner(caster:GetOwner())
        target:SetHealth(target:GetMaxHealth()*(hp/100))
        target.previous_point = caster.previous_point
        target.to_point = caster.to_point
    else
        target:RemoveNoDraw()
    end
end