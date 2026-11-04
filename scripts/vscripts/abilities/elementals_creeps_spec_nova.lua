function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    ability:SetActivated(false)
end

function OnSpellStart(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()
    local need_stacks = ability:GetLevelSpecialValueFor( "need_stacks" , level - 1  )
    local mod = caster:FindModifierByName("modifier_elementals_creeps_spec_nova")
    mod:SetStackCount(mod:GetStackCount()-need_stacks)
    if mod:GetStackCount() >= need_stacks then
        ability:SetActivated(true)
    else
        ability:SetActivated(false)
    end
end

function OnFriendDeath(event)
    local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()
    if level > 0 then
        local mod = caster:FindModifierByName("modifier_elementals_creeps_spec_nova")
        mod:SetStackCount(mod:GetStackCount()+1)
        local need_stacks = ability:GetLevelSpecialValueFor( "need_stacks" , level - 1  )
        if mod:GetStackCount() >= need_stacks then
            ability:SetActivated(true)
        else
            ability:SetActivated(false)
        end
    end
end

function OnDestroyEgg( event )
	local egg		= event.target

	-- Play sound effect
	--local soundName = "Hero_Phoenix.SuperNova.Explode"
	--StartSoundEvent( soundName, egg )

	-- Create particle effect
	local pfxName = "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf"
	local pfx = ParticleManager:CreateParticle( pfxName, PATTACH_ABSORIGIN, egg )
	ParticleManager:SetParticleControlEnt( pfx, 0, egg, PATTACH_POINT_FOLLOW, "follow_origin", egg:GetAbsOrigin(), true )
	ParticleManager:SetParticleControlEnt( pfx, 1, egg, PATTACH_POINT_FOLLOW, "attach_hitloc", egg:GetAbsOrigin(), true )

	-- Remove the egg
	egg:ForceKill( false )
	egg:AddNoDraw()
end