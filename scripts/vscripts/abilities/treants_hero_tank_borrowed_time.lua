--[[
	Author: Noya
	Date: 9.1.2015.
	Checks if the caster HP dropped below the threshold
]]
function BorrowedTimeActivate( event )
	-- Variables
	local caster = event.caster
	local ability = event.ability
	local level = ability:GetLevel()
	local threshold = ability:GetLevelSpecialValueFor( "hp_perc" , level - 1  )
	local cooldown = ability:GetEffectiveCooldown( ability:GetLevel() )
	local dur = ability:GetLevelSpecialValueFor( "duration" , level - 1  )

	-- Apply the modifier
	if caster:GetHealthPercent() < threshold and ability:GetCooldownTimeRemaining() == 0 and caster:GetMana() >= ability:GetManaCost(level-1) then
		caster.borrowed_heal = 0
		BorrowedTimePurge( event )
		ability:ApplyDataDrivenModifier( caster, caster, "modifier_borrowed_time", { duration = dur })
		caster:SpendMana(ability:GetManaCost(level-1), ability)
		ability:StartCooldown( cooldown )
		caster:Stop()
		caster:EmitSound("Hero_Abaddon.BorrowedTime")
	end
end

--[[
	Author: Noya
	Date: 9.1.2015.
	Heals for twice the damage taken
]]
function BorrowedTimeHeal( event )
	-- Variables
	local damage = event.DamageTaken
	local caster = event.caster
	local ability = event.ability
	local level = ability:GetLevel()
	local max_heal = ability:GetLevelSpecialValueFor( "max_heal" , level - 1  ) - caster.borrowed_heal

	local heal = damage*2
	if heal > max_heal then
		heal = max_heal
		caster:RemoveModifierByName("modifier_borrowed_time")
	end
	caster.borrowed_heal = caster.borrowed_heal + heal
	
	caster:Heal(heal, caster)
end

function BorrowedTimePurge( event )
	local caster = event.caster

	print("stronk dispel")

	-- Strong Dispel
	local RemovePositiveBuffs = false
	local RemoveDebuffs = true
	local BuffsCreatedThisFrameOnly = false
	local RemoveStuns = true
	local RemoveExceptions = false
	caster:Purge( RemovePositiveBuffs, RemoveDebuffs, BuffsCreatedThisFrameOnly, RemoveStuns, RemoveExceptions)
end
