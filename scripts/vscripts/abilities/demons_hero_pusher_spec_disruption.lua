function AstralEnd( keys )
	local target = keys.target

	if target then
		if target.effect_cast1 then
			ParticleManager:DestroyParticle(target.effect_cast1 , false)
		end
		--if target.effect_cast2 then
		--	ParticleManager:DestroyParticle(target.effect_cast2 , false)
		--end

		target:RemoveNoDraw()
	end
end

function AstralStart( keys )
	local target = keys.target
	local caster = keys.caster
	target.effect_cast1 = ParticleManager:CreateParticle(
		"particles/units/heroes/hero_shadow_demon/shadow_demon_disruption.vpcf",
		PATTACH_WORLDORIGIN,
		nil
	)
	ParticleManager:SetParticleControl( target.effect_cast1, 0, target:GetOrigin() )

	--target.effect_cast2 = ParticleManager:CreateParticleForTeam(
	--	"particles/units/heroes/hero_obsidian_destroyer/obsidian_destroyer_prison_ring.vpcf",
	--	PATTACH_WORLDORIGIN,
	--	nil,
	--	caster:GetTeamNumber()
	--)
	--ParticleManager:SetParticleControl( target.effect_cast2, 0, target:GetOrigin() )

	target:AddNoDraw()
end