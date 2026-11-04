function OnAttack( event )
	local caster = event.caster
	local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    local delay = ability:GetLevelSpecialValueFor("delay", level - 1 )
    local tooltip_attack = ability:GetLevelSpecialValueFor("tooltip_attack", level - 1 )
    local bonus_damage = ability:GetLevelSpecialValueFor("bonus_damage", level - 1 )
    if caster and target and target:IsAlive() and level > 0 and ability and ability:IsCooldownReady() then
        for i = 1, tooltip_attack do
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_dragons_creeps_air_geminate_debuff", {})
		    Timers:CreateTimer( i * delay, function()
                --caster:StartGesture(ACT_DOTA_ATTACK)
                local id = caster:GetPlayerOwnerID()
	            local castle = _G.playersinfo[id].ancient

	            if castle and target then
	            	local castle_ability = castle:FindAbilityByName("dragons_race_bonus")
                    if castle_ability then
                        local burn_duration = ability:GetLevelSpecialValueFor("burn_duration", level - 1 )
	            	    castle_ability:ApplyDataDrivenModifier(caster, target, "modifier_dragons_race_bonus_burning", { Duration = burn_duration})
                    end
                end
                caster:PerformAttack(target, true, true, true, false, true, false, false)
            end)
        end
        ability:StartCooldown(ability:GetEffectiveCooldown(level))
    end
end