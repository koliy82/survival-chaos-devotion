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
		    Timers:CreateTimer( i * delay, function()
                --caster:StartGesture(ACT_DOTA_ATTACK)
                if target:IsAlive() then
                    caster:PerformAttack(target, true, true, true, false, true, false, false)
                end
                if target:IsAlive() then
                    ApplyCustomDamage(target, caster, bonus_damage, caster.custom_damage_type, ability)
                end
            end)
        end
        ability:StartCooldown(ability:GetEffectiveCooldown(level))
    end
end