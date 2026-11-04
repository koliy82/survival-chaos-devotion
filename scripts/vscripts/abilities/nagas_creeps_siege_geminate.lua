function OnAttack( event )
	local caster = event.caster
	local target = event.target
    local ability = event.ability
    local level = ability:GetLevel()
    local delay = ability:GetLevelSpecialValueFor("delay", level - 1 )
    local tooltip_attack = ability:GetLevelSpecialValueFor("tooltip_attack", level - 1 )
    if caster and target and target:IsAlive() and level > 0 and ability and ability:IsCooldownReady() then
        ability:StartCooldown(ability:GetEffectiveCooldown(level))
        for i = 1, tooltip_attack do
		    Timers:CreateTimer( i * delay, function()
                caster:StartGesture(ACT_DOTA_ATTACK)
                caster:PerformAttack(target, true, true, true, false, true, false, false)
            end)
        end
    end
end