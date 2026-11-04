function OnSpellStart( keys )
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	LaunchLightning(caster, target, ability, ability:GetSpecialValueFor("damage"), ability:GetSpecialValueFor("jump_range"), ability:GetSpecialValueFor("jump_deley"), ability:GetSpecialValueFor("jumps"))
end

function LaunchLightning(caster, target, ability, damage, bounce_radius, jump_deley, jumps)
	local targets_hit = { target }
	local search_sources = target
	-- caster:EmitSound("Item.Maelstrom.Chain_Lightning")
	-- target:EmitSound("Item.Maelstrom.Chain_Lightning.Jump")
	ZapThem(caster, ability, caster, target, damage)
    
    local now_jumps = 1
    Timers:CreateTimer(jump_deley,
    function()
		local nearby_enemies = FindUnitsInRadius(caster:GetTeamNumber(), search_sources:GetAbsOrigin(), nil, bounce_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, FIND_CLOSEST, false)
		local already_hit = false
        local my_pt = nil
		for _, potential_target in pairs(nearby_enemies) do
			for _, hit_target in pairs(targets_hit) do
				if potential_target == hit_target then
					already_hit = true
					break
				end
			end
            if already_hit == false and potential_target ~= nil then
                my_pt = potential_target
                break
            else
                already_hit = false
            end
		end
        if my_pt == nil then
            already_hit = true
        end
		if not already_hit then
			ZapThem(caster, ability, search_sources, my_pt, damage)
			table.insert(targets_hit, my_pt)
			search_sources = my_pt
            if now_jumps < jumps then
                now_jumps = now_jumps + 1
                return jump_deley
            end
		end
	end)
end

function ZapThem(caster, ability, source, target, damage)
	local particle = "particles/units/heroes/hero_rubick/rubick_fade_bolt.vpcf"
	local bounce_pfx = ParticleManager:CreateParticle(particle, PATTACH_ABSORIGIN_FOLLOW, source)
	ParticleManager:SetParticleControlEnt(bounce_pfx, 0, source, PATTACH_POINT_FOLLOW, "attach_hitloc", source:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(bounce_pfx, 1, target, PATTACH_POINT_FOLLOW, "attach_hitloc", target:GetAbsOrigin(), true)
	ParticleManager:SetParticleControl(bounce_pfx, 2, Vector(1, 1, 1))
	ParticleManager:ReleaseParticleIndex(bounce_pfx)

	ability:ApplyDataDrivenModifier(caster, target, "modifier_treants_hero_mage_nature_arc_debuff", {})
	ApplyCustomDamage(target, caster, damage, 6)
	-- ApplyDamage({attacker = caster, victim = target, ability = ability, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL})
end
