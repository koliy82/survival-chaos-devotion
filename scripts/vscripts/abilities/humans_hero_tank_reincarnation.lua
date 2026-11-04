function OnSpellStart( keys )
	local caster = keys.caster
    local ability = keys.ability
    if ability.units_table then
        local resp_col = ability:GetLevelSpecialValueFor( "resp_col", ability:GetLevel() - 1 )
        local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
        for x=1, resp_col do
            if #ability.units_table > 0 then
                local owner = caster:GetOwner()
                local point = caster:GetAbsOrigin() + RandomVector( RandomFloat( 0, 300 ) )
                local respunit = CreateUnitByName(ability.units_table[#ability.units_table], point, true, owner, owner, caster:GetTeam())
                FindClearSpaceForUnit(respunit, point, false)
                respunit:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
                respunit.previous_point = caster.previous_point
                respunit.to_point = caster.to_point
                table.remove(ability.units_table)
            else
                ability:SetActivated(false)
                break
            end
        end
        if #ability.units_table <= 0 then
            ability:SetActivated(false)
        end
    else
        ability:SetActivated(false)
    end
end

function OnDeath( keys )
    -- local caster = keys.caster
    if keys.unit:IsCustomHero() or keys.unit:GetOwner() ~= keys.caster:GetOwner() then return end
    local ability = keys.ability
    if not ability.units_table then
        ability.units_table = {}
    end
    table.insert(ability.units_table, keys.unit:GetUnitName())
    local resp_col = ability:GetLevelSpecialValueFor( "resp_col", ability:GetLevel() - 1 )
    if #ability.units_table >= resp_col then
        ability:SetActivated(true)
    else
        ability:SetActivated(false)
    end
end

function OnCreated( keys )
    local ability = keys.ability
    ability:SetActivated(false)
end