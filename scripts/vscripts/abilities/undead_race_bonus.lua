LinkLuaModifier( "undead_race_bonus_tower_buff", "abilities/undead_race_bonus.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "undead_race_bonus_base_buff", "abilities/undead_race_bonus.lua", LUA_MODIFIER_MOTION_NONE )
function OnCreated(event)
    local caster = event.caster
    local ability = event.ability
    local id = caster:GetPlayerOwnerID()
    -- local mod = caster:FindModifierByName("modifier_repair_building")
    
    for k, v in pairs(_G.playersinfo[id].towers) do
		v:AddNewModifier(caster, ability, "undead_race_bonus_tower_buff", {})
	end
	_G.playersinfo[id].ancient:AddNewModifier(caster, ability, "undead_race_bonus_base_buff", {})
end

--------------------------------------------------------------------------------

undead_race_bonus_tower_buff = class({})

function undead_race_bonus_tower_buff:IsHidden()
	return false
end

function undead_race_bonus_tower_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}

	return funcs
end

function undead_race_bonus_tower_buff:OnAttackLanded( params )
	if IsServer() then
        if params.attacker == self:GetParent() then
			if params.damage > 0 and params.target:IsAlive() and not params.target:IsCustomHero() and not params.target:IsAncient() and RandomInt(1, 100) <= 10 then
				params.target:Kill(self:GetAbility(),self:GetParent())
			end
        end
	end
end

--------------------------------------------------------------------------------

undead_race_bonus_base_buff = class({})
function undead_race_bonus_base_buff:IsHidden()
	return false
end

-- function undead_race_bonus_base_buff:GetTexture()
-- 	return "keeper_of_the_light_chakra_magic"
-- end

function undead_race_bonus_base_buff:DeclareFunctions()
	if self:GetParent().GetMaxMana then
		return {
			MODIFIER_PROPERTY_EXTRA_MANA_BONUS,
		}
	else
		return {}
	end
end

function undead_race_bonus_base_buff:OnCreated(t)
	self.parent = self:GetParent()
	self.curBonus = 0
	if IsServer() then
		Timers:CreateTimer(0, function()
			self.parent:SetMana(self.parent:GetMaxMana())
		end)
	end
end

function undead_race_bonus_base_buff:GetModifierExtraManaBonus( params )
	if self.parent.GetMaxMana then
		self.curBonus = (self.parent:GetMaxMana() - self.curBonus) * .12
	end
	return self.curBonus
end