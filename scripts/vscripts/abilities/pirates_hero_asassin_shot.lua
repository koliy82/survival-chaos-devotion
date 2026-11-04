LinkLuaModifier( "agr_mod", "modifiers/agr_mod.lua", LUA_MODIFIER_MOTION_NONE )
function OnProjectileHitUnit(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
    local level = ability:GetLevel()

	if target and target:IsAlive() then
		local min_distance = ability:GetLevelSpecialValueFor( "min_distance" , level - 1 )
		local push_distance = ability:GetLevelSpecialValueFor( "distance" , level - 1 )
		local push_duration = ability:GetLevelSpecialValueFor( "push_duration" , level - 1 )
		local distance = (caster:GetOrigin()-target:GetOrigin()):Length2D()
		if distance <= min_distance then
			local knockbackModifierTable =
			{
				should_stun = 1,
				knockback_duration = push_duration,
				duration = push_duration,
				knockback_distance = push_distance,
				knockback_height = 50,
				center_x = caster:GetAbsOrigin().x,
				center_y = caster:GetAbsOrigin().y,
				center_z = caster:GetAbsOrigin().z
			}
			target:AddNewModifier( caster, nil, "modifier_knockback", knockbackModifierTable )
		end
		if distance < caster:GetBaseAttackRange() then
			local agr_duration = ability:GetLevelSpecialValueFor( "agr_duration" , level - 1 )
			caster:AddNewModifier(target, ability, "agr_mod", {Duration = agr_duration})
		end
	end
end