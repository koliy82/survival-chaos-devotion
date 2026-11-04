function OnDestroy(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local caster_team = caster:GetTeamNumber()
	local start_location = target:GetAbsOrigin()
    local duration  = ability:GetSpecialValueFor("bush_duration")

    for i = 0,3 do
		local thinker = CreateModifierThinker( caster, ability, "", {duration = duration}, RotatePosition( start_location, QAngle( 0, 90*i, 0 ), start_location + Vector(0,175,0)), caster_team, false)
		ability:ApplyDataDrivenModifier(caster, thinker, "modifier_treants_hero_mage_spec_forest_curse_bush", {duration = duration})
	end
end

function OnCreated(keys)
    keys.target:FindModifierByName("modifier_treants_hero_mage_spec_forest_curse_bush_trigger"):GetAuraOwner():Destroy()
end