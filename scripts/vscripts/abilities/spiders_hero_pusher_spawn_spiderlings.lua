function OnModCreated(t)
	if not t.target:HasAbility("hero_core") then
					ApplyCustomDamage(t.target, t.caster, 9999999, 6)
	end
end