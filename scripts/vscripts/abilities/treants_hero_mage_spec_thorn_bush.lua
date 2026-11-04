function OnSpellStart(keys)
	local caster = keys.caster
	local ability = keys.ability
	local direction = caster:GetForwardVector()
    local duration  = ability:GetSpecialValueFor("duration")
	local caster_team = caster:GetTeamNumber()
	local casterPos = caster:GetAbsOrigin()

    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	local targets =  FindUnitsInRadius(caster_team, casterPos, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
    if #targets > 0 then
		local direction = (targets[1]:GetOrigin()-casterPos):Normalized()

        for i = 0,2 do
            local pos = casterPos + direction*(150 + (600*i))
            local thinker = CreateModifierThinker( caster, ability, "", {duration = duration}, RotatePosition( pos, QAngle( 0, -90, 0 ), pos + direction * 150), caster_team, false)
            ability:ApplyDataDrivenModifier(caster, thinker, "modifier_treants_hero_mage_spec_thorn_bush", {duration = duration})
            thinker = CreateModifierThinker( caster, ability, "", {duration = duration}, RotatePosition( pos, QAngle( 0, 90, 0 ), pos + direction * 150), caster_team, false)
            ability:ApplyDataDrivenModifier(caster, thinker, "modifier_treants_hero_mage_spec_thorn_bush", {duration = duration})
	    end
        for i = 0,1 do
            local thinker = CreateModifierThinker( caster, ability, "", {duration = duration}, casterPos + direction * (450 + (600*i)), caster_team, false)
            ability:ApplyDataDrivenModifier(caster, thinker, "modifier_treants_hero_mage_spec_thorn_bush", {duration = duration})
	    end
    end
end

function OnCreated(keys)
    keys.target:FindModifierByName("modifier_treants_hero_mage_spec_thorn_bush_trigger"):GetAuraOwner():Destroy()
end