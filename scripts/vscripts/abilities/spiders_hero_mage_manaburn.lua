if not spiders_hero_mage_manaburn then
	spiders_hero_mage_manaburn = class({
		OnSpellStart = function(self)
		local mana_to_burn = self.GetSpecialValueFor(self,"manaburn")
		local target = self.GetCursorTarget(self)
		
			local target_mana = target:GetMana()
			if target_mana <= mana_to_burn then
				target:SetMana(0)
			else
				target:SpendMana(mana_to_burn, self)
			end

			local numberIndex = ParticleManager:CreateParticle(  "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn_msg.vpcf", PATTACH_OVERHEAD_FOLLOW, target )
			ParticleManager:SetParticleControl( numberIndex, 1, Vector( 1, mana_to_burn, 0 ) )
			local digits = string.len( math.floor( mana_to_burn ) ) + 1
		    ParticleManager:SetParticleControl( numberIndex, 2, Vector( 2, digits, 0 ) )
			local burnIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", PATTACH_ABSORIGIN, target )

	Timers:CreateTimer( 2, function()
			ParticleManager:DestroyParticle( numberIndex, false )
			ParticleManager:DestroyParticle( burnIndex, false)
		end)
			if self.GetCaster(self):HasModifier("modifier_spiders_hero_mage_burrow_buff") then
				Timers:CreateTimer(.05,function()
					self.EndCooldown(self)
					self.StartCooldown(self,self.GetEffectiveCooldown(self,self.GetLevel(self)))
				end)
			end
		end
	})
end