function OnCreated( event )
  local caster = event.caster

  if caster:HasModifier("modifier_elementals_void_buff") then
	  event.ability:ApplyDataDrivenModifier(caster, caster, "modifier_elementals_creeps_arme_shield_aura", {})
  end
end