function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    local add_gpt = ability:GetSpecialValueFor( "gpt" )
    caster.gpt = caster.gpt + add_gpt
end