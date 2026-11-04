LinkLuaModifier( "modifier_frostivus_creep_damage_gift_1_buff", "modifiers/frostivus_modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_frostivus_creep_damage_gift_2_buff", "modifiers/frostivus_modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_frostivus_creep_damage_gift_3_buff", "modifiers/frostivus_modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_frostivus_creep_damage_gift_4_buff", "modifiers/frostivus_modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_frostivus_creep_damage_gift_5_buff", "modifiers/frostivus_modifiers", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_frostivus_double_spawn_creep_armor_gift_buff", "modifiers/frostivus_modifiers", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

modifier_frostivus_creep_damage_gift_1 = class( {} )

function modifier_frostivus_creep_damage_gift_1:IsHidden()
    return false
end

function modifier_frostivus_creep_damage_gift_1:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_frostivus_creep_damage_gift_1:IsAura()
    return true
end

function modifier_frostivus_creep_damage_gift_1:GetAuraRadius()
    return 99999
end

function modifier_frostivus_creep_damage_gift_1:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
end

function modifier_frostivus_creep_damage_gift_1:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_frostivus_creep_damage_gift_1:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_frostivus_creep_damage_gift_1:GetModifierAura()
    return "modifier_frostivus_creep_damage_gift_1_buff"
end

--------------------------------------------------------------------------------

modifier_frostivus_creep_damage_gift_2 = class( {} )

function modifier_frostivus_creep_damage_gift_2:IsHidden()
    return false
end

function modifier_frostivus_creep_damage_gift_2:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_frostivus_creep_damage_gift_2:IsAura()
    return true
end

function modifier_frostivus_creep_damage_gift_2:GetAuraRadius()
    return 99999
end

function modifier_frostivus_creep_damage_gift_2:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
end

function modifier_frostivus_creep_damage_gift_2:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_frostivus_creep_damage_gift_2:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_frostivus_creep_damage_gift_2:GetModifierAura()
    return "modifier_frostivus_creep_damage_gift_2_buff"
end

--------------------------------------------------------------------------------

modifier_frostivus_creep_damage_gift_3 = class( {} )

function modifier_frostivus_creep_damage_gift_3:IsHidden()
    return false
end

function modifier_frostivus_creep_damage_gift_3:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_frostivus_creep_damage_gift_3:IsAura()
    return true
end

function modifier_frostivus_creep_damage_gift_3:GetAuraRadius()
    return 99999
end

function modifier_frostivus_creep_damage_gift_3:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
end

function modifier_frostivus_creep_damage_gift_3:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_frostivus_creep_damage_gift_3:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_frostivus_creep_damage_gift_3:GetModifierAura()
    return "modifier_frostivus_creep_damage_gift_3_buff"
end

--------------------------------------------------------------------------------

modifier_frostivus_creep_damage_gift_4 = class( {} )

function modifier_frostivus_creep_damage_gift_4:IsHidden()
    return false
end

function modifier_frostivus_creep_damage_gift_4:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_frostivus_creep_damage_gift_4:IsAura()
    return true
end

function modifier_frostivus_creep_damage_gift_4:GetAuraRadius()
    return 99999
end

function modifier_frostivus_creep_damage_gift_4:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
end

function modifier_frostivus_creep_damage_gift_4:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_frostivus_creep_damage_gift_4:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_frostivus_creep_damage_gift_4:GetModifierAura()
    return "modifier_frostivus_creep_damage_gift_4_buff"
end

--------------------------------------------------------------------------------

modifier_frostivus_creep_damage_gift_5 = class( {} )

function modifier_frostivus_creep_damage_gift_5:IsHidden()
    return false
end

function modifier_frostivus_creep_damage_gift_5:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_frostivus_creep_damage_gift_5:IsAura()
    return true
end

function modifier_frostivus_creep_damage_gift_5:GetAuraRadius()
    return 99999
end

function modifier_frostivus_creep_damage_gift_5:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
end

function modifier_frostivus_creep_damage_gift_5:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_frostivus_creep_damage_gift_5:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_frostivus_creep_damage_gift_5:GetModifierAura()
    return "modifier_frostivus_creep_damage_gift_5_buff"
end

--------------------------------------------------------------------------------

modifier_frostivus_double_spawn_creep_armor_gift = class( {} )

function modifier_frostivus_double_spawn_creep_armor_gift:IsHidden()
    return false
end

function modifier_frostivus_double_spawn_creep_armor_gift:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_frostivus_double_spawn_creep_armor_gift:IsAura()
    return true
end

function modifier_frostivus_double_spawn_creep_armor_gift:GetAuraRadius()
    return 99999
end

function modifier_frostivus_double_spawn_creep_armor_gift:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO
end

function modifier_frostivus_double_spawn_creep_armor_gift:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_frostivus_double_spawn_creep_armor_gift:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_frostivus_double_spawn_creep_armor_gift:GetModifierAura()
    return "modifier_frostivus_double_spawn_creep_armor_gift_buff"
end

--------------------------------------------------------------------------------

modifier_frostivus_creep_damage_gift_1_buff = class({})

function modifier_frostivus_creep_damage_gift_1_buff:IsHidden()
    return false
end

function modifier_frostivus_creep_damage_gift_1_buff:IsBuff()
    return true
end

function modifier_frostivus_creep_damage_gift_1_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_frostivus_creep_damage_gift_1_buff:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }

    return funcs
end

function modifier_frostivus_creep_damage_gift_1_buff:GetModifierDamageOutgoing_Percentage( params )
    return 10
end

--------------------------------------------------------------------------------

modifier_frostivus_creep_damage_gift_2_buff = class({})

function modifier_frostivus_creep_damage_gift_2_buff:IsHidden()
    return false
end

function modifier_frostivus_creep_damage_gift_2_buff:IsBuff()
    return true
end

function modifier_frostivus_creep_damage_gift_2_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_frostivus_creep_damage_gift_2_buff:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }

    return funcs
end

function modifier_frostivus_creep_damage_gift_2_buff:GetModifierDamageOutgoing_Percentage( params )
    return 14
end

--------------------------------------------------------------------------------

modifier_frostivus_creep_damage_gift_3_buff = class({})

function modifier_frostivus_creep_damage_gift_3_buff:IsHidden()
    return false
end

function modifier_frostivus_creep_damage_gift_3_buff:IsBuff()
    return true
end

function modifier_frostivus_creep_damage_gift_3_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_frostivus_creep_damage_gift_3_buff:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }

    return funcs
end

function modifier_frostivus_creep_damage_gift_3_buff:GetModifierDamageOutgoing_Percentage( params )
    return 18
end

--------------------------------------------------------------------------------

modifier_frostivus_creep_damage_gift_4_buff = class({})

function modifier_frostivus_creep_damage_gift_4_buff:IsHidden()
    return false
end

function modifier_frostivus_creep_damage_gift_4_buff:IsBuff()
    return true
end

function modifier_frostivus_creep_damage_gift_4_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_frostivus_creep_damage_gift_4_buff:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }

    return funcs
end

function modifier_frostivus_creep_damage_gift_4_buff:GetModifierDamageOutgoing_Percentage( params )
    return 22
end

--------------------------------------------------------------------------------

modifier_frostivus_creep_damage_gift_5_buff = class({})

function modifier_frostivus_creep_damage_gift_5_buff:IsHidden()
    return false
end

function modifier_frostivus_creep_damage_gift_5_buff:IsBuff()
    return true
end

function modifier_frostivus_creep_damage_gift_5_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_frostivus_creep_damage_gift_5_buff:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
    }

    return funcs
end

function modifier_frostivus_creep_damage_gift_5_buff:GetModifierDamageOutgoing_Percentage( params )
    return 26
end

--------------------------------------------------------------------------------

modifier_frostivus_double_spawn_creep_armor_gift_buff = class({})

function modifier_frostivus_double_spawn_creep_armor_gift_buff:IsHidden()
    return false
end

function modifier_frostivus_double_spawn_creep_armor_gift_buff:IsBuff()
    return true
end

function modifier_frostivus_double_spawn_creep_armor_gift_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_frostivus_double_spawn_creep_armor_gift_buff:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }

    return funcs
end

function modifier_frostivus_double_spawn_creep_armor_gift_buff:GetModifierPhysicalArmorBonus( params )
    return 2
end

--------------------------------------------------------------------------------

modifier_frostivus_buildings_regen_1_buff = class({})

function modifier_frostivus_buildings_regen_1_buff:IsHidden()
    return false
end

function modifier_frostivus_buildings_regen_1_buff:IsBuff()
    return true
end

function modifier_frostivus_buildings_regen_1_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_frostivus_buildings_regen_1_buff:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }

    return funcs
end

function modifier_frostivus_buildings_regen_1_buff:GetModifierConstantHealthRegen( params )
    return 0.5
end

--------------------------------------------------------------------------------

modifier_frostivus_buildings_regen_2_buff = class({})

function modifier_frostivus_buildings_regen_2_buff:IsHidden()
    return false
end

function modifier_frostivus_buildings_regen_2_buff:IsBuff()
    return true
end

function modifier_frostivus_buildings_regen_2_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_frostivus_buildings_regen_2_buff:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }

    return funcs
end

function modifier_frostivus_buildings_regen_2_buff:GetModifierConstantHealthRegen( params )
    return 0.9
end

--------------------------------------------------------------------------------

modifier_frostivus_buildings_regen_3_buff = class({})

function modifier_frostivus_buildings_regen_3_buff:IsHidden()
    return false
end

function modifier_frostivus_buildings_regen_3_buff:IsBuff()
    return true
end

function modifier_frostivus_buildings_regen_3_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_frostivus_buildings_regen_3_buff:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }

    return funcs
end

function modifier_frostivus_buildings_regen_3_buff:GetModifierConstantHealthRegen( params )
    return 1.3
end

--------------------------------------------------------------------------------

modifier_frostivus_buildings_regen_4_buff = class({})

function modifier_frostivus_buildings_regen_4_buff:IsHidden()
    return false
end

function modifier_frostivus_buildings_regen_4_buff:IsBuff()
    return true
end

function modifier_frostivus_buildings_regen_4_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_frostivus_buildings_regen_4_buff:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }

    return funcs
end

function modifier_frostivus_buildings_regen_4_buff:GetModifierConstantHealthRegen( params )
    return 1.7
end

--------------------------------------------------------------------------------

modifier_frostivus_buildings_regen_5_buff = class({})

function modifier_frostivus_buildings_regen_5_buff:IsHidden()
    return false
end

function modifier_frostivus_buildings_regen_5_buff:IsBuff()
    return true
end

function modifier_frostivus_buildings_regen_5_buff:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_frostivus_buildings_regen_5_buff:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
    }

    return funcs
end

function modifier_frostivus_buildings_regen_5_buff:GetModifierConstantHealthRegen( params )
    return 2.1
end

--------------------------------------------------------------------------------
