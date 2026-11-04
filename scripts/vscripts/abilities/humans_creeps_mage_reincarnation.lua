function OnSpellStart( keys )
	local caster = keys.caster
    local ability = keys.ability
    if ability.units_table then
        local resp_col = ability:GetLevelSpecialValueFor( "resp_col", ability:GetLevel() - 1 )
        local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
        for x=1, resp_col do
            if #ability.units_table > 0 then
                local nowOwner = caster:GetOwner()
                local owner = ability.units_table[#ability.units_table].owner
                local point = caster:GetAbsOrigin() + RandomVector( RandomFloat( 0, 300 ) )
                local respunit = CreateUnitByName(ability.units_table[#ability.units_table].unit_name, point, true, owner, owner, caster:GetTeam())
                FindClearSpaceForUnit(respunit, point, false)
                respunit.previous_point = caster.previous_point
                respunit.to_point = caster.to_point
                respunit.FirstOwner = owner
                respunit:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})
                if owner ~= nowOwner then respunit:SetOwner(nowOwner) end
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
    local ability = keys.ability
    local unit = keys.unit
    if not ability or unit.humans_creeps_mage_reincarnation or unit:IsCustomHero() or unit:GetOwner() ~= keys.caster:GetOwner() then return end
    unit.humans_creeps_mage_reincarnation = true
    if not ability.units_table then
        ability.units_table = {}
    end
    local owner = unit.FirstOwner or unit:GetOwner()
    table.insert(ability.units_table, {unit_name = unit:GetUnitName(), owner = owner})
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