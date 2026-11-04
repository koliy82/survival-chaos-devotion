function Init(event)
    if not _G.spec_items then
        _G.spec_items = require( 'spec_items' )
    end
    local caster = event.caster
    local id = caster:GetPlayerOwnerID()
    local invs = CustomNetTables:GetTableValue("Hero_Items",tostring(id))
    if invs == nil then
        invs = {}
    end
    local race_name = _G.racetable.races_names[tostring(_G.playersinfo[id].race)]
    invs["enable"] = 1
    if event.Hero then
        invs["heroes"] = {
            {event.Hero, event.HeroAbility}
        }
        _G.playersinfo[id].spec.items_spec = {
            [event.Hero] = true
        }
    else
        invs["heroes"] = {
            {"npc_dota_"..race_name.."_hero_tank", "spawn_hero_"..race_name.."_tank"},
            {"npc_dota_"..race_name.."_hero_mage", "spawn_hero_"..race_name.."_mage"},
            {"npc_dota_"..race_name.."_hero_asassin", "spawn_hero_"..race_name.."_asassin"},
            {"npc_dota_"..race_name.."_hero_pusher", "spawn_hero_"..race_name.."_pusher"}
        }
        _G.playersinfo[id].spec.items_spec = {
            ["npc_dota_"..race_name.."_hero_tank"] = true,
            ["npc_dota_"..race_name.."_hero_mage"] = true,
            ["npc_dota_"..race_name.."_hero_asassin"] = true,
            ["npc_dota_"..race_name.."_hero_pusher"] = true
        }
    end
    CustomNetTables:SetTableValue("Hero_Items", tostring(id), invs)
end