function CreateWard(keys)
	local caster = keys.caster
	local ability = keys.ability
	local position = caster:GetAbsOrigin() + caster:GetForwardVector() * 300
	local owner = caster:GetOwner()
	
	caster.ward = CreateUnitByName("npc_dota_diretide_hero_mage_scarecrow", position, true, owner, owner, caster:GetTeam())

	ability:ApplyDataDrivenModifier( caster, caster.ward, "modifier_diretide_hero_mage_scarecrow_ward", {} )
	ability:ApplyDataDrivenModifier( caster, caster.ward, "modifier_diretide_hero_mage_scarecrow_ward_aura", {} )

	
	for i = 0, 5 do
		Timers:CreateTimer( i, function()
			if caster.ward and not caster.ward:IsNull() and caster.ward:IsAlive() then
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster.ward)
				ParticleManager:SetParticleControl(particle, 0, caster.ward:GetAbsOrigin())
				ParticleManager:SetParticleControl(particle, 3, caster.ward:GetAbsOrigin())
			end
		end)
	end

	EmitSoundOn("Hero_EmberSpirit.FlameGuard.Loop", caster)
end

function OnIntervalThink(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability

	caster.ward:SetForwardVector(RotatePosition(Vector(0,0,0), QAngle(0,20,0), caster.ward:GetForwardVector()))
	
end

function DestroyWard(keys)
	local caster = keys.caster
	
	caster.ward:ForceKill(false)
end