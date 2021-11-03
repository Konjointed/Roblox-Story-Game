local Tween = {}

local TS = game:GetService("TweenService")

function Tween:MakeTween(Info,Object,Goals)
	local Tween = TS:Create(Object,Info,Goals)	
	Tween:Play()
end

return Tween
