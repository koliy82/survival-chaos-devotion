nagas_creeps_mage_adaptive_strike = class( {} )

function nagas_creeps_mage_adaptive_strike:OnProjectileHit_ExtraData( target, loc, extraData )
	if target then
		local caster = self:GetCaster()
		caster:EmitSound( "Hero_Morphling.AdaptiveStrike" )
		
		local damage = extraData.damage
		
		if damage then
			local part = ParticleManager:CreateParticle( "particles/units/heroes/hero_morphling/morphling_adaptive_strike.vpcf", PATTACH_ABSORIGIN, target )
			ParticleManager:SetParticleControlEnt( part, 1, target, PATTACH_ABSORIGIN, nil, target:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex( part )
			
			target:EmitSound( "Hero_Morphling.AdaptiveStrikeAgi.Target" )
			
            --SendOverheadEventMessage( nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, target, damage, nil )
            
            ApplyCustomDamage(target, caster, damage, 6, self)
		end
	end
	
	return target or loc
end

function nagas_creeps_mage_adaptive_strike:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local originCaster = caster:GetOrigin()
	
	local projSpeed = self:GetSpecialValueFor( "proj_speed" )
	local extraData = {}
	local projName = "particles/units/heroes/hero_morphling/morphling_adaptive_strike_agi_proj.vpcf"
	local soundName = "Hero_Morphling.AdaptiveStrikeAgi.Cast"
    local damage = self:GetSpecialValueFor( "damage" )
    local cast_range = self:GetSpecialValueFor( "cast_range" )
    local bonus_cast_range = 100
    extraData.damage = damage
	
	local units = { target }
	
    local targets = self:GetSpecialValueFor( "max_targets" )
    local candidates = FindUnitsInRadius(
        caster:GetTeamNumber(),
        originCaster,
        nil,
        cast_range + bonus_cast_range,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
        FIND_CLOSEST,
        false
    )
    
    while #units < targets do
        if #candidates < 1 then
            break
        end
        
        local key = RandomInt( 1, #candidates )
        local candidate = candidates[key]
        
        if candidate ~= target then
            table.insert( units, candidate )
        end
        
        table.remove( candidates, key )
    end
	
	for _, unit in pairs( units ) do
		ProjectileManager:CreateTrackingProjectile( {
			EffectName = projName,
			Ability = self,
			Source = caster,
			vSourceLoc = originCaster,
			Target = unit,
			iMoveSpeed = projSpeed,
			
			ExtraData = extraData,
		} )
	end
	
	caster:EmitSound( soundName )
end