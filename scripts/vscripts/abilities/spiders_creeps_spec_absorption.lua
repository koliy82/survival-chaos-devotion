function OnSuccess( keys )
	local ability = keys.ability
    local ability_level = ability:GetLevel() - 1
    
    if ability_level < 0 then return end

    local chance = ability:GetLevelSpecialValueFor("chance", ability_level )
    if not GameRules:IsDaytime() then 
        chance = chance + ability:GetLevelSpecialValueFor("night_bonus_chance", ability_level )
    end

    if RollPercentage(chance) then
	    local caster = keys.caster
        local target = keys.target
        if target:IsAncient() or target:IsCustomHero() then return end
        local hp = ability:GetLevelSpecialValueFor("hp", ability_level)/100
        if target:GetHealth()/target:GetMaxHealth() < hp then
            target:Kill(ability, caster)
        end
    end
end