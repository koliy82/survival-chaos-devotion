-- LinkLuaModifier( "hero_core_mod", "hero_core.lua", LUA_MODIFIER_MOTION_NONE )
hero_core = class({})

function hero_core:OnOwnerDied()
    if IsServer() then
        local caster = self:GetCaster()
        local unit_name = caster:GetUnitName()
        local id = caster:GetPlayerOwnerID()
        local hero_ability = caster.ability
        local hero_ability_name = hero_ability:GetAbilityName()
        local levelsxp = 0
        local lvl = caster:GetLevel()
        for i=1,lvl-1 do
            levelsxp = levelsxp + 100*i
        end
        _G.playersinfo[id].unitsinfo[unit_name].hero_xp = caster.hero_xp + levelsxp
        if _G.playersinfo[id].spec.items_spec and _G.playersinfo[id].spec.items_spec[unit_name] then
            _G.playersinfo[id].unitsinfo[unit_name].inventory = {}
            for i=0,5 do
                local item = caster:GetItemInSlot(i)
                if item ~= nil then
                    table.insert( _G.playersinfo[id].unitsinfo[unit_name].inventory, item:GetAbilityName() )
                end
            end
            local item = caster:GetItemInSlot(16)--neutral
            if item ~= nil then
                PlayerResource:ModifyGold(id, 100, false, DOTA_ModifyGold_SellItem)
            end
        end
        -- hero_ability:StartCooldown(hero_ability:GetCooldown(1))
		for k, v in pairs(_G.playersinfo[id].baracks) do
            local loc_hero_ability = v:FindAbilityByName(hero_ability_name)
            loc_hero_ability:SetActivated(true)
            CustomNetTables:SetTableValue( 'Hero_Levels', tostring( loc_hero_ability:entindex() ), {
                lvl = lvl,
                xp = caster.hero_xp / (lvl * 100)
            })
        end
    end
end

function hero_core:CheckState()
	return {
		[MODIFIER_PROPERTY_DISABLE_TURNING] = true,
		[MODIFIER_PROPERTY_IGNORE_CAST_ANGLE] = true
	}
end