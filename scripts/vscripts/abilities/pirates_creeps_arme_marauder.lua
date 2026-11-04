function OnKill(keys)
	local caster = keys.caster
    local ability = keys.ability
    if not ability and not caster then return end

    local target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
	local flags = DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, keys.radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, target_type, flags, FIND_ANY_ORDER, false)
    local level
    for _,ally in pairs(targets) do
        ability = ally:FindAbilityByName("pirates_creeps_arme_marauder")
        if ability then
            level = ability:GetLevel()
            if level > 0 and ability:IsCooldownReady() and ally:GetMana() >= ability:GetManaCost(level - 1) then
                caster = ally

                caster:SpendMana(ability:GetManaCost(level - 1), ability)
                local cooldown = ability:GetEffectiveCooldown(level)
                ability:StartCooldown(cooldown)
                
                local spec_ability = caster:FindAbilityByName("pirates_creeps_arme_marauder_spec")
                local multicast = 1
                if spec_ability then
                    local chance = spec_ability:GetLevelSpecialValueFor( "chance" , spec_ability:GetLevel() - 1 )
                    if RollPercentage(chance) then
                        multicast = 2
                    end
                end
                for i = 1, multicast do
                    local random = RandomInt( 1, 100 )
                    if random <= 20 then
                        ability:ApplyDataDrivenModifier(caster, caster, "modifier_pirates_creeps_arme_marauder_damage", {})
                    elseif random > 25 and random <= 50 then
                        ability:ApplyDataDrivenModifier(caster, caster, "modifier_pirates_creeps_arme_marauder_ats", {})
                    elseif random > 50 and random <= 75 then
                        ability:ApplyDataDrivenModifier(caster, caster, "modifier_pirates_creeps_arme_marauder_armor", {})
                    elseif random > 75 and random <= 100 then
                        ability:ApplyDataDrivenModifier(caster, caster, "modifier_pirates_creeps_arme_marauder_hp_regen", {})
                    end
                    local id = caster:GetPlayerOwnerID()
                    local gold = ability:GetLevelSpecialValueFor( "gold" , level - 1 )
                        
                    caster:EmitSound("General.Coins")
                    PlayerResource:ModifyGold(id, gold, false, DOTA_ModifyGold_CreepKill)
                end
                break
            end
        end
    end
end