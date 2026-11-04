function OnKill( keys )
    --if keys.Target:IsAncient() then return end
    local caster = keys.caster
    local ability = keys.ability
    if not (ability and not ability:IsNull()) then return end
    local id = caster:GetPlayerOwnerID()
    local mod = _G.playersinfo[id].spec:FindModifierByName("modifier_diretide_spec_soul_exchanger_pass_souls_counter")
    local souls = ability:GetLevelSpecialValueFor( "soul_per_creep" , 0 )--ability:GetLevel() - 1
    --if keys.Target:IsCustomHero() then
    --    souls = ability:GetLevelSpecialValueFor( "soul_per_hero" , ability:GetLevel() - 1 )
    --else
    --    souls = ability:GetLevelSpecialValueFor( "soul_per_creep" , ability:GetLevel() - 1 )
    --end
    mod:SetStackCount(mod:GetStackCount()+souls)
end

function Get_Gold( keys )
    local caster = keys.caster
    local ability = keys.ability
    local id = caster:GetPlayerOwnerID()

    local mod = _G.playersinfo[id].spec:FindModifierByName("modifier_diretide_spec_soul_exchanger_pass_souls_counter")
    local souls = mod:GetStackCount()
    local need_souls = ability:GetLevelSpecialValueFor( "need_souls" , ability:GetLevel() - 1 )
    local gold = ability:GetLevelSpecialValueFor( "gold" , ability:GetLevel() - 1 )

    if souls >= need_souls then
        mod:SetStackCount(souls - need_souls)
        PlayerResource:ModifyGold(id, gold, false, 0)
        ability:StartCooldown(ability:GetLevelSpecialValueFor( "cooldown" , ability:GetLevel() - 1 ))
    end
end

function Get_Mana( keys )
    local caster = keys.caster
    local ability = keys.ability
    local id = caster:GetPlayerOwnerID()

    local mod = _G.playersinfo[id].spec:FindModifierByName("modifier_diretide_spec_soul_exchanger_pass_souls_counter")
    local souls = mod:GetStackCount()
    local need_souls = ability:GetLevelSpecialValueFor( "need_souls" , ability:GetLevel() - 1 )
    local mana = ability:GetLevelSpecialValueFor( "mana" , ability:GetLevel() - 1 )

    if souls >= need_souls and _G.playersinfo[id].ancient then
        mod:SetStackCount(souls - need_souls)
        _G.playersinfo[id].ancient:GiveMana(mana)
        ability:StartCooldown(ability:GetLevelSpecialValueFor( "cooldown" , ability:GetLevel() - 1 ))
    end
end

function Get_Candy( keys )
    local caster = keys.caster
    local ability = keys.ability
    local id = caster:GetPlayerOwnerID()
    --local id = keys.PlayerID
    if not id or not _G.playersinfo[id].alive then return end

    local mod = _G.playersinfo[id].spec:FindModifierByName("modifier_diretide_spec_soul_exchanger_pass_souls_counter")
    local souls = mod:GetStackCount()
    local candy = ability:GetLevelSpecialValueFor( "candy" , ability:GetLevel() - 1 )
    local candys = CustomNetTables:GetTableValue("Diretide","candys")
    local str_id = tostring(id)

    local need_souls = 25 + (4 * candys[str_id])

    if souls >= need_souls then
        mod:SetStackCount(souls - need_souls)
        local price = CustomNetTables:GetTableValue("Diretide","price")
        candys[str_id] = candys[str_id] + candy
        ChangePrice(price, candy)
        CustomNetTables:SetTableValue("Diretide","candys",candys)
        ability:StartCooldown(ability:GetLevelSpecialValueFor( "cooldown" , ability:GetLevel() - 1 ))
    end
end

function ChangePrice(price, change)
    --if change == 0 then return end
    --if not price then
    --    price = CustomNetTables:GetTableValue("Diretide","price")
    --end
    --price.buy = price.buy + 10 * change
    --price.sell = price.sell + 8 * change
	--CustomNetTables:SetTableValue("Diretide","price",price)
end