function CastFireSpirits( event )
	local caster	= event.caster
	local ability	= event.ability
	local modifierStackName	= event.modifier_stack_name

	local numSpirits = event.spirit_count

	if caster:HasModifier("modifier_elementals_fire_buff") then
		numSpirits = ability:GetLevelSpecialValueFor( "bonus_charges", ability:GetLevel() - 1 )
	end

	-- Create particle FX
	--local particleName = "particles/units/heroes/hero_phoenix/phoenix_fire_spirits_birda.vpcf"
	--pfx = ParticleManager:CreateParticle( particleName, PATTACH_OVERHEAD_FOLLOW, caster )
	--ParticleManager:SetParticleControl( pfx, 1, Vector( 1, 0, 0 ) )
--
	--caster.fire_spirits_numSpirits	= numSpirits--одну оставить
	--caster.fire_spirits_pfx			= pfx

	-- Set the stack count
	caster:SetModifierStackCount( modifierStackName, ability, numSpirits )

end

function LaunchFireSpirit( event )
	local caster		= event.caster
	local ability		= event.ability
	local modifierName	= event.modifier_stack_name

	-- Update spirits count
	local currentStack	= caster:GetModifierStackCount( modifierName, caster )
	currentStack = currentStack - 1
	caster:SetModifierStackCount( modifierName, caster, currentStack )

	-- Remove the stack modifier if all the spirits has been launched.
	if currentStack == 0 then
		caster:RemoveModifierByName( modifierName )
		caster:RemoveModifierByName( "modifier_elementals_creeps_air_fire_spirits_buff" )
	end
end

--function RemoveFireSpirits( event )
--	local caster	= event.caster
--	local ability	= event.ability
--
--	local pfx = caster.fire_spirits_pfx
--	ParticleManager:DestroyParticle( pfx, false )
--end
