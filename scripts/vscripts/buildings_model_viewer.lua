function Spawn(keys)
    DeepPrintTable(keys)
    -- print(keys:GetValue("model"))
    -- print(keys:GetValue("particleonly"))
    -- hModel:SetOwner(thisEntity)
    -- hModel:SetParent(thisEntity, "")
    -- hModel:FollowEntity(thisEntity, true)
    
    print(_G.model)
    local ent = SpawnEntityFromTableSynchronous("prop_dynamic", {
        origin = _G.model_origin,
        angles = _G.model_angles,
        model = _G.model,
        parentname = thisEntity:GetName(),
        ModelScale = _G.model_scale * 0.65,
        DefaultAnim = "ACT_DOTA_IDLE"
    })

    print(_G.particle)
    if _G.particle and _G.particle ~= "undefined" then
        ParticleManager:CreateParticle( _G.particle, PATTACH_POINT_FOLLOW, ent )
    end

    -- local think = function()
    --     print("think")
    --     print(thisEntity.model)
    --     if thisEntity.model then
    --         print(thisEntity.hModel:GetName())
    --         -- local hModel2 = SpawnEntityFromTableSynchronous("prop_dynamic", {model = thisEntity.model, parentname = thisEntity.hModel:GetName(), ModelScale = 0.5})
    --     else
    --         return 0.1
    --     end
    -- end

    -- thisEntity:SetContextThink( "ModelThink", think, 0.1 )
end