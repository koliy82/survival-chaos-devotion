modifier_elves_spec_dexterity = class({})

function modifier_elves_spec_dexterity:IsHidden()
    return self:GetStackCount() ~= 0
end

function modifier_elves_spec_dexterity:GetTexture()
	return "custom/icons_elves/elves_spec/dexterity"
end

function modifier_elves_spec_dexterity:OnCreated( kv )
	if IsServer() then
        local parent = self:GetParent()
        local team = parent:GetTeamNumber()
        local position = parent:GetAbsOrigin()
        local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
        local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
        self:SetStackCount(-#targets)
		self:StartIntervalThink(1)
	end
end

function modifier_elves_spec_dexterity:OnIntervalThink()
	if IsServer() then
        local parent = self:GetParent()
        local team = parent:GetTeamNumber()
        local position = parent:GetAbsOrigin()
        local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
        local targets = FindUnitsInRadius(team, position, nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, target_type, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
        self:SetStackCount(-#targets)
	end
end

function modifier_elves_spec_dexterity:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = (self:GetStackCount() == 0 or self:GetParent():HasModifier("modifier_repair_building_invis"))
	}
end