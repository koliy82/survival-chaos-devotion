function AddBonusHealth( keys )
    -- print("health_fix")
    local caster = keys.caster
    local health = keys.Health
    -- print("health key")
    -- print(health)
    local new_health = caster:GetBaseMaxHealth() + health
    -- print("new_health")
    -- print(new_health)
    local newhealth = caster:GetHealth() + health
    -- print("caster:GetHealth()")
    -- print(caster:GetHealth())
    if caster:GetHealth() == 100000 then
        newhealth = new_health
    end
    -- print("newhealth")
    -- print(newhealth)
    caster:SetBaseMaxHealth(new_health)
    caster:CalculateGenericBonuses()
    caster:SetHealth(newhealth)
end

function RemoveBonusHealth( keys )
    local caster = keys.caster
    local health = keys.Health
    local new_health = caster:GetBaseMaxHealth() - health
    caster:SetBaseMaxHealth(new_health)
    caster:SetMaxHealth(new_health)
end