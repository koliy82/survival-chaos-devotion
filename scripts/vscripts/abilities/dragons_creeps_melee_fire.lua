function ActOnTargets(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target

	--if target:HasModifier("modifier_dragons_race_bonus_burning") then
	--	ability:ApplyDataDrivenModifier(caster, target, "modifier_dragons_creeps_melee_fire_armor", {})
	--end
	if target:HasModifier("modifier_dragons_race_bonus_burning") and not target:IsCustomHero() then
		ability:ApplyDataDrivenModifier(caster, target, "modifier_dragons_creeps_melee_fire_debuff", {})
	end
end

--LinkLuaModifier( "modifier_dragons_creeps_melee_fire_armor", "abilities/dragons_creeps_melee_fire.lua", LUA_MODIFIER_MOTION_NONE )
--function ActOnTargets(keys)
--	local caster = keys.caster
--	local ability = keys.ability
--	local target = keys.target
--	
--	local mod = caster:FindModifierByName("modifier_dragons_creeps_melee_fire_armor")
--
--	if target:HasModifier("modifier_dragons_race_bonus_burning") then
--		if mod then
--			local stacks = mod:GetStackCount()
--			--if stacks < maxstacks then
--				mod:SetStackCount(stacks+1)
--			--end
--			mod:SetDuration(1, true)
--		else
--			caster:AddNewModifier(caster, ability, "modifier_dragons_creeps_melee_fire_armor", {Duration = 1}):SetStackCount(1)
--		end
--	end
--	ability:ApplyDataDrivenModifier(caster, target, "modifier_dragons_creeps_melee_fire_debuff", {})
--end
--
--modifier_dragons_creeps_melee_fire_armor = class( {} )
--
--function modifier_dragons_creeps_melee_fire_armor:OnCreated( kv )
--    self.armor = self:GetAbility():GetSpecialValueFor( "armor" )
--end
--
--function modifier_dragons_creeps_melee_fire_armor:IsBuff()
--	return true
--end
--
----------------------------------------------------------------------------------
--
--function modifier_dragons_creeps_melee_fire_armor:DeclareFunctions()
--	local funcs = 
--	{
--		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
--	}
--
--	return funcs
--end
--
----------------------------------------------------------------------------------
--
--function modifier_dragons_creeps_melee_fire_armor:GetModifierPhysicalArmorBonus( params )
--    return self.armor * self:GetStackCount()
--end
--