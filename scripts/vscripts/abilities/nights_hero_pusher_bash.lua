function OnSuccess( keys )
    local caster = keys.caster
    local target = keys.target

	local particle_cast = "particles/econ/items/spirit_breaker/spirit_breaker_weapon_ti8/spirit_breaker_bash_ti8.vpcf"
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_POINT_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(effect_cast, 0, target, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0,0,0), true)
	ParticleManager:ReleaseParticleIndex(effect_cast)

	target:EmitSound("Hero_Spirit_Breaker.GreaterBash")
end

function OnIntervalThink( keys )
    local caster = keys.caster
    local ability = keys.ability

	if not GameRules:IsDaytime() then
        ability:ApplyDataDrivenModifier(caster, caster, "modifier_nights_hero_pusher_bash_buff", {})
    else
        caster:RemoveModifierByName("modifier_nights_hero_pusher_bash_buff")
    end
end