function OnSpellStart( event )
	local caster = event.caster
	local ability = event.ability
	local target = event.target
	local level = ability:GetLevel()
	local duration = ability:GetLevelSpecialValueFor( "duration", level - 1 )

	local point = target:GetAbsOrigin() + Vector(0, 0, 500)
	local owner = caster:GetOwner()

	local cloud = CreateUnitByName("npc_dota_primordials_mage_nimbus", point, true, owner, owner, caster:GetTeam())
	FindClearSpaceForUnit( cloud, point, false )
	cloud:AddNewModifier(caster, ability, "modifier_kill", {duration = duration})
	ability:ApplyDataDrivenModifier(caster, cloud, "modifier_primordials_hero_mage_nimbus", {Duration = duration})
	
	local radius = ability:GetLevelSpecialValueFor( "radius", level - 1 )
	local interval = ability:GetLevelSpecialValueFor( "interval", level - 1 )
	local damage = ability:GetLevelSpecialValueFor( "damage", level - 1 )

	local Cloud_Pos = cloud:GetAbsOrigin()

	local nfx = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_POINT, caster)
		ParticleManager:SetParticleControl(nfx, 0, Cloud_Pos)
		ParticleManager:SetParticleControl(nfx, 1, Vector(radius,radius,radius))
		ParticleManager:SetParticleControlEnt(nfx, 2, cloud, PATTACH_POINT_FOLLOW, "attach_hitloc", Cloud_Pos, true)
		ParticleManager:SetParticleControl(nfx, 5, Cloud_Pos)

	Timers:CreateTimer( duration, function()
		ParticleManager:DestroyParticle(nfx, false)
	end)

	for i = 1, duration do
		Timers:CreateTimer( (i-1)*interval, function()
			local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
			local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
			local enemies =  FindUnitsInRadius(caster:GetTeamNumber(), Cloud_Pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)

			EmitSoundOn("Hero_Zuus.LightningBolt.Cloud", cloud)
			if #enemies > 0 then
				local nfx1 = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud_strike.vpcf", PATTACH_POINT, caster)
							ParticleManager:SetParticleControlEnt(nfx1, 0, cloud, PATTACH_POINT, "attach_hitloc", Cloud_Pos, true)
							ParticleManager:SetParticleControlEnt(nfx1, 1, enemies[1], PATTACH_POINT, "attach_hitloc", enemies[1]:GetAbsOrigin(), true)
							ParticleManager:SetParticleControl(nfx1, 6, Vector(math.random(1,5),math.random(1,5),math.random(1,5)))
							ParticleManager:ReleaseParticleIndex(nfx1)
			
				ApplyCustomDamage(enemies[1], caster, damage, 6, ability)
			end
		end)
	end
end