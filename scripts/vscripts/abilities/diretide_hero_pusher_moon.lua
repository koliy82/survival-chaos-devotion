function ChangeModel(keys)
	local caster = keys.caster
	caster.modelscale = caster:GetModelScale()
	
	caster:SetModelScale(1.7)
end

function RevertModel(keys)
	local caster = keys.caster
	
	caster:SetModelScale(caster.modelscale)
end