function OnTakeDamage( event )
	local caster = event.caster
    local ability = event.ability
    local level = ability:GetLevel()
    local block_chance = ability:GetLevelSpecialValueFor("block_chance", level - 1 )
    local need_hp = ability:GetLevelSpecialValueFor("need_hp", level - 1 )
    if caster and ability then
        if RollPercentage(block_chance) then
            caster.custom_block[0] = 999999
        else
            caster.custom_block[0] = 0
        end
        if ability:IsCooldownReady() and caster:GetHealthPercent() <= need_hp then
            ability:ApplyDataDrivenModifier(caster, caster, "modifier_frostivus_creeps_arme_block_pass_regen", {})
            ability:StartCooldown(ability:GetEffectiveCooldown(level))
        end
    end
end