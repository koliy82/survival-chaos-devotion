function OnCreated(event)
    if event.caster and event.ability and event.ability:GetLevel() > 0 and event.caster:FindModifierByName("modifier_undead_hero_mage_spec_zombies") then
        event.caster:FindModifierByName("modifier_undead_hero_mage_spec_zombies"):SetStackCount(event.charges)
    end
end

function OnKill( event )
	local caster = event.caster
	local ability = event.ability
	local ability_level = ability:GetLevel() - 1
	
	if ability_level >= 0 then
        local mod = caster:FindModifierByName("modifier_undead_hero_mage_spec_zombies")
        if mod:GetStackCount() == nil then 
            mod:SetStackCount(event.charges)
        end
        if mod:GetStackCount() <= 0 then return end
        mod:SetStackCount(mod:GetStackCount() - 1)
        local target = event.target
        
        local unitname = event.UnitName
        local unitcount = event.UnitCount or 1
        local spawnradius = event.SpawnRadius or 150
        local addmodifier = event.AddModifier
        local owner = caster:GetOwner()
        local pos = caster:GetAbsOrigin()
        local id = caster:GetPlayerOwnerID()
        if event.unit then
            pos = event.unit:GetAbsOrigin()
        end
        if event.OnTarget == 1 and event.target then
            pos = event.target:GetAbsOrigin()
        end

        if _G.playersinfo[id].unitsinfo[unitname] then
            if event.Health then
                _G.playersinfo[id].unitsinfo[unitname].health = event.Health
            end
            if event.Armor then
                _G.playersinfo[id].unitsinfo[unitname].armor = event.Armor
            end
            if event.Damage then
                _G.playersinfo[id].unitsinfo[unitname].min_damage = event.Damage
                _G.playersinfo[id].unitsinfo[unitname].max_damage = event.Damage
            end
            if event.MinDamage then
                _G.playersinfo[id].unitsinfo[unitname].min_damage = event.MinDamage
            end
            if event.MaxDamage then
                _G.playersinfo[id].unitsinfo[unitname].max_damage = event.MaxDamage
            end
        end
        
        for i=1, unitcount do
            local unit = CreateUnitByName(unitname, pos, true, owner, owner, caster:GetTeam())
            unit.previous_point = caster.previous_point
            unit.to_point = caster.to_point
            FindClearSpaceForUnit( unit, pos+RandomVector( spawnradius ), false )
            if event.duration then
                unit:AddNewModifier(caster, nil, "modifier_kill", {duration = event.duration})
            end
            if addmodifier then
                ability:ApplyDataDrivenModifier( caster, unit, addmodifier, {} )
            end
        end

        
        Timers:CreateTimer(ability:GetEffectiveCooldown(ability_level + 1), function()
            mod:SetStackCount(mod:GetStackCount() + 1)
        end)
		-- ability:StartCooldown(ability:GetEffectiveCooldown(ability_level + 1))
	end
end