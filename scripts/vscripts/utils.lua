function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
  end

function CDOTABaseAbility:ReturnGold()
    local caster = self:GetCaster()
    local id = caster:GetPlayerOwnerID()
    
    local gold = self:GetGoldCost(self:GetLevel()-1)
    PlayerResource:SetGold(id, PlayerResource:GetGold(id) + gold, false)
    _G.playerstats[id].goldspend = _G.playerstats[id].goldspend - gold
	if self.creep_spawn_item then
		_G.playerstats[id].goldspend_to_summon_creeps = _G.playerstats[id].goldspend_to_summon_creeps - gold
	end
	if string.find(self:GetAbilityName(), "spawn_hero_") ~= nil then
		_G.playerstats[id].goldspend_to_summon_heroes = _G.playerstats[id].goldspend_to_summon_heroes - gold
	end
end

function CDOTA_BaseNPC:FixAnims()
	local model_name = self:GetModelName()
	if model_name == "models/heroes/juggernaut/juggernaut.vmdl" then
		self:AddActivityModifier("run")
	elseif model_name == "models/heroes/snapfire/snapfire.vmdl" then
		self:AddActivityModifier("run")
	elseif model_name == "models/heroes/snapfire/snapfire_customgame.vmdl" then
		self:AddActivityModifier("run")
	elseif model_name == "models/heroes/void_spirit/void_spirit.vmdl" then
		self:AddActivityModifier("run")
	elseif model_name == "models/heroes/abyssal_underlord/abyssal_underlord_v2.vmdl" then
		self:AddActivityModifier("run")
	elseif model_name == "models/items/tiny/frozen_stonehenge/frozen_stonehenge_lvl_04.vmdl" then
		self:AddActivityModifier("tree")
		self:AddActivityModifier("ultimate_scepter")
	elseif model_name == "models/heroes/monkey_king/monkey_king.vmdl" then
		self:AddActivityModifier("run")
		self:AddActivityModifier("attack_normal_range")
	elseif model_name == "models/heroes/dawnbreaker/dawnbreaker.vmdl" then
		self:AddActivityModifier("run")
		self:AddActivityModifier("attack_long_range")
	elseif model_name == "models/heroes/mars/mars.vmdl" then
		self:AddActivityModifier("attack_close_range")
	elseif model_name == "models/heroes/siltbreaker/siltbreaker.vmdl" then
		self:AddActivityModifier("attack_close_range")
	elseif model_name == "models/heroes/troll_warlord/troll_warlord.vmdl" then
		self:AddActivityModifier("run")
	elseif model_name == "models/heroes/pangolier/pangolier.vmdl" then
		self:AddActivityModifier("run")
	elseif model_name == "models/items/wraith_king/arcana/wraith_king_arcana.vmdl" then
		self:AddActivityModifier("run")
	elseif model_name == "models/heroes/juggernaut/juggernaut_arcana.vmdl" then
		self:AddActivityModifier("run")
	elseif model_name == "models/heroes/crystal_maiden_persona/crystal_maiden_persona.vmdl" then
		self:AddActivityModifier("run")
	end
end

function CDOTA_BaseNPC:HaveCustomXP()
    return self.hero_xp ~= nil
end