attack_enemy_baracks_gift = class({})

function attack_enemy_baracks_gift:OnProjectileHit(target)
    ApplyCustomDamage(target, self:GetCaster(), 1250, 6, nil)
end