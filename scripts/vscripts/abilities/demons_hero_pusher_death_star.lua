function OnDestroyEgg( event )
	local egg		= event.target
	local hero		= event.caster
	local ability	= event.ability
	local healt_regeneration = ability:GetLevelSpecialValueFor( "healt_regeneration", ability:GetLevel() - 1 )

	hero:SetHealth( hero:GetHealth() + hero:GetMaxHealth() * healt_regeneration / 100 )

		-- Strong despel
	local RemovePositiveBuffs = true
	local RemoveDebuffs = true
	local BuffsCreatedThisFrameOnly = false
	local RemoveStuns = true
	local RemoveExceptions = true
	hero:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions )

	-- Stun nearby enemies
	ability:ApplyDataDrivenModifier( hero, egg, "modifier_demons_hero_pusher_death_star_explode", {} )
	hero:RemoveModifierByName( "modifier_demons_hero_pusher_death_star_explode" )


	-- Play sound effect
	local soundName = "Hero_Phoenix.SuperNova.Explode"
	StartSoundEvent( soundName, hero )

	-- Create particle effect
	local pfxName = "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf"
	local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_ABSORIGIN, egg )
	ParticleManager:SetParticleControlEnt( pfx, 0, egg, PATTACH_POINT_FOLLOW, "follow_origin", egg:GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( pfx, 1, egg, PATTACH_POINT_FOLLOW, "attach_hitloc", egg:GetAbsOrigin(), true )

	-- Remove the egg
	egg:ForceKill( false )
	egg:AddNoDraw()
end

function HideCaster( event )
	event.caster:AddNoDraw()
end

function ShowCaster( event )
	event.caster:RemoveNoDraw()
end