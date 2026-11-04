function OnTakeDamage( keys )
	local caster = keys.caster
	local ability = keys.ability
    local casterHP = caster:GetHealth()
    local level = ability:GetLevel()
	
	if level > 0 and casterHP <= 0 and ability:IsCooldownReady() then
		caster:SetHealth(1)
		caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_invaders_creeps_air_stone", {} )
		ability:StartCooldown(ability:GetEffectiveCooldown(level))
	end
end

function OnDestroy(keys)
	local caster = keys.caster
    if caster and caster:IsAlive() then caster:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY) end
end