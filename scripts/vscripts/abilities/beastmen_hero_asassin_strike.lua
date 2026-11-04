function OnSpellStart( event )
	local caster = event.caster
	local ability = event.ability
	
    local casterPos = caster:GetAbsOrigin()
	local distance  = event.distance
	local heal  = event.heal
	local radius  = event.radius
	local damage  = event.damage

	local nfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_strike_cast.vpcf", PATTACH_POINT_FOLLOW, caster)
                ParticleManager:SetParticleControl(nfx1, 0, casterPos)
                ParticleManager:SetParticleControlEnt(nfx1, 1, caster, PATTACH_POINT_FOLLOW, "attach_weapon_bot", casterPos, true)
                ParticleManager:SetParticleControlEnt(nfx1, 2, caster, PATTACH_POINT_FOLLOW, "attach_weapon_top", casterPos, true)
                ParticleManager:ReleaseParticleIndex(nfx1)

	local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
    local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	local targets =  FindUnitsInRadius(caster:GetTeamNumber(), casterPos, nil, distance, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_CLOSEST, false)
    if #targets > 0 then
		local dir = (targets[1]:GetOrigin()-casterPos):Normalized()

		local startPos = casterPos + dir * 75 
		local endPos = startPos + (dir * distance)

    	EmitSoundOnLocationWithCaster(startPos, "Hero_MonkeyKing.Strike.Impact", caster)
    	EmitSoundOnLocationWithCaster(endPos, "Hero_MonkeyKing.Strike.Impact.EndPos", caster)

		local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_strike.vpcf", PATTACH_POINT, caster)
		ParticleManager:SetParticleControlForward(nfx, 0, dir)
		ParticleManager:SetParticleControl(nfx, 1, endPos)
		ParticleManager:ReleaseParticleIndex(nfx)

		local enemies = FindUnitsInLine(caster:GetTeam(), startPos, endPos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS)
    	for _,enemy in pairs(enemies) do
        	caster:Heal(heal, ability)
			ApplyCustomDamage(enemy, caster, damage, 6, ability)
    	end
	end
end