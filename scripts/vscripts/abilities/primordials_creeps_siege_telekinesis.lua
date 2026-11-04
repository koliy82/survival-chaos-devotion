function Lift(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
    local level = ability:GetLevel()
	
	if level > 0 and ability:IsCooldownReady() and caster:GetMana() >= ability:GetManaCost(level - 1) and not caster:IsSilenced() and not caster:IsIllusion() and not target:IsAncient() then
		
		local team = caster:GetTeamNumber()
		local position = target:GetAbsOrigin()
		local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
		local flags = DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
		local targets = FindUnitsInRadius(team, position, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)
		if #targets > 0 then
			if (targets[1]:HasModifier("modifier_primordials_creeps_siege_telekinesis") or targets[1]:HasModifier("modifier_primordials_creeps_siege_telekinesis_fall")) then return end
			ability.target = targets[1]
			ability.target_origin = targets[1]:GetAbsOrigin()

			ability:StartCooldown(ability:GetEffectiveCooldown(level))
			caster:SpendMana(ability:GetManaCost(level - 1), ability)
			
			-- Applies the stunned and flying modifier to the target
			ability:ApplyDataDrivenModifier(caster, targets[1], "modifier_primordials_creeps_siege_telekinesis", {})
		end
	end
end

function Fall(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	local vector_distance
	
	ability.point = ability.target_origin
	vector_distance = ability.target_origin - target:GetAbsOrigin()
	
	-- Sets the distance the target must fall for every interval
	if ability.fall_distance == nil then
		local distance = (vector_distance):Length2D()
			
		local fall_duration = ability:GetLevelSpecialValueFor("fall_duration", (ability:GetLevel() -1))
		local intervals = fall_duration/0.05
	
		ability.fall_distance = distance/(intervals - 1)
	end
	
	-- Direction and position variables
	local direction = (vector_distance):Normalized()
	local new_position = target:GetAbsOrigin() + (direction * ability.fall_distance)
	
	-- Moves the target
	target:SetAbsOrigin(new_position)
	-- Creates awkward animation, but necessary for no clipping
	FindClearSpaceForUnit(target, new_position, true)
end

function Impact(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = ability:GetLevelSpecialValueFor("radius", level)
	local damage = ability:GetLevelSpecialValueFor("damage", level)
	local damage_on_buildings = ability:GetLevelSpecialValueFor( "damage_on_buildings", level )

	if not (caster and ability.point) then return end
	
	-- Destroys previous particles
	--ParticleManager:DestroyParticle(ability.lift_particle, true)

	local target_pos = target:GetAbsOrigin()

	-- Renders the impact particle on the target
	local particle = ParticleManager:CreateParticleForTeam(keys.particle, PATTACH_WORLDORIGIN, caster, caster:GetTeam())
	ParticleManager:SetParticleControl(particle, 0, target_pos)
	ParticleManager:SetParticleControl(particle, 1, target_pos)
	ParticleManager:SetParticleControl(particle, 2, target_pos)

	-- Units to be damaged
	local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local flags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
	local units = FindUnitsInRadius(caster:GetTeamNumber(), ability.point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, flags, FIND_ANY_ORDER, false)

	local spec_ability = caster:FindAbilityByName("primordials_creeps_siege_spec")
	-- Deal damage to all units in the AOE
	for _, unit in ipairs(units) do
		if spec_ability then spec_ability:ApplyDataDrivenModifier(caster, unit, "modifier_primordials_creeps_siege_spec_debuff", {}) end
		if unit:IsAncient() then
			if spec_ability then
				if string.find(unit:GetUnitName(), "barrack") ~= nil then
					spec_ability:ApplyDataDrivenModifier(caster, unit, "modifier_primordials_creeps_siege_spec_debuff_barrack", {})
				end
			end
            ApplyCustomDamage(unit, caster, damage * damage_on_buildings / 100, 6, ability)
        else
			ApplyCustomDamage(unit, caster, damage, 6, ability)
        end
	end
	
	EmitSoundOn(keys.sound, target)

	ability.fall_distance = nil
	ability.point = nil
end