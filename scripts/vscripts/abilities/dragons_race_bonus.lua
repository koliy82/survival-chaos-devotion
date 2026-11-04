function AffectBurning(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	if not caster then return end
    local id = caster:GetPlayerOwnerID()

	local castle = _G.playersinfo[id].ancient

	if castle and target and target:GetTeamNumber() ~= caster:GetTeamNumber() then
		local castle_ability = castle:FindAbilityByName("dragons_race_bonus")
		if not castle_ability then return end
		local duration =  2
		if keys.duration then 
			duration = keys.duration
		end
		castle_ability:ApplyDataDrivenModifier(caster, target, "modifier_dragons_race_bonus_burning", { Duration = duration})
	end
end