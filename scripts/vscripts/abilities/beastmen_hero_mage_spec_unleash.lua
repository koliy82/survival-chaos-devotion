function OnAttackStart(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
    local level = ability:GetLevel()

	if level > 0 and ability:IsCooldownReady() and caster:GetMana() >= ability:GetManaCost(level - 1) then
		ability:StartCooldown(ability:GetEffectiveCooldown(level))
		caster:SpendMana(ability:GetManaCost(level - 1), ability)

        local mod = ability:ApplyDataDrivenModifier(caster, caster, "modifier_beastmen_hero_mage_spec_unleash_buff",{})
    	local stack = ability:GetLevelSpecialValueFor( "stack" , level - 1 )

        mod:SetStackCount(stack)
    
        local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
        ParticleManager:ReleaseParticleIndex( effect_cast )

        EmitSoundOn( "Hero_Marci.Unleash.Cast", caster )
    end
end

function OnAttackLanded(event)
    local caster = event.caster
    local target = event.target
    local ability = event.ability
    local mod = caster:FindModifierByName("modifier_beastmen_hero_mage_spec_unleash_buff")
    if not mod then return end

    if target and target:IsAlive() and not target:IsAncient() then
        ability:ApplyDataDrivenModifier(caster, target, "modifier_beastmen_hero_mage_spec_unleash_debuff", {})
    end

	local pfx = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(pfx,1,target,PATTACH_POINT_FOLLOW,"attach_hitloc",Vector(0,0,0), true )
	ParticleManager:ReleaseParticleIndex( pfx )

    local newstack = mod:GetStackCount() - 1
    if newstack <= 0 then
        caster:RemoveModifierByName("modifier_beastmen_hero_mage_spec_unleash_buff")

        local target_teams = DOTA_UNIT_TARGET_TEAM_ENEMY
        local target_types = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
        local target_flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS

        local level = ability:GetLevel()
    	local damage = ability:GetLevelSpecialValueFor( "damage" , level - 1 )
    	local radius = ability:GetLevelSpecialValueFor( "radius" , level - 1 )
    	local stun_duration = ability:GetLevelSpecialValueFor( "duration" , level - 1 )

        local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, target_teams, target_types, target_flags, 0, false)
        
        for _, enemy in pairs( units ) do
            ability:ApplyDataDrivenModifier(caster, enemy, "modifier_beastmen_hero_mage_spec_unleash_debuff", {})
            enemy:AddNewModifier(caster, ability, "modifier_stunned", {duration = stun_duration})
            ApplyCustomDamage(enemy, caster, damage, 6, ability)
        end

		local pfx1 = ParticleManager:CreateParticle( "particles/units/heroes/hero_marci/marci_unleash_pulse.vpcf", PATTACH_WORLDORIGIN, nil )
		ParticleManager:SetParticleControl( pfx1, 0, target:GetAbsOrigin() )
		ParticleManager:SetParticleControl( pfx1, 1, Vector(radius,radius,radius) )
		ParticleManager:ReleaseParticleIndex( pfx1 )
		EmitSoundOnLocationWithCaster( target:GetAbsOrigin(), "Hero_Marci.Unleash.Pulse", caster )
    else
        mod:SetStackCount(newstack)
    end
end