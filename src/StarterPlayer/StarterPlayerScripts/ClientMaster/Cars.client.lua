--Description: Tweens the cars outside of the house

local RepStorage = game:GetService("ReplicatedStorage")

local Tween = require(RepStorage.Functions.Tween)

local PoliceCar = workspace.OutsideDecoration.Cars["Police Car"]
local Info = TweenInfo.new(
	5,
	Enum.EasingStyle.Sine,
	Enum.EasingDirection.Out, 
	0, 
	false, 
	0
)

--> Weld the lame police car cuz it's poop
for _,Part in pairs(PoliceCar.Body:GetDescendants()) do
	if Part:IsA("MeshPart") or Part:IsA("Part") or Part:IsA("UnionOperation") then
		local Weld = Instance.new("WeldConstraint")
		Weld.Part0 = Part
		Weld.Part1 = PoliceCar.Main
		Weld.Parent = Part
		Part.Anchored = false
	end
end

while wait(10) do
	local Car = workspace.OutsideDecoration.Cars:GetChildren()[math.random(1,2)]
	if Car.Name == "Police Car" then
		Car.PrimaryPart.CFrame = CFrame.new(109, 4, -263)
		local Tween = Tween:MakeTween(Info,Car.PrimaryPart,{CFrame = CFrame.new(Car.PrimaryPart.CFrame.X,Car.PrimaryPart.CFrame.Y,185)})
	else --> LESSSS GOOOo BABANDAABABAB LESSSS GOOo
		Car.CFrame = CFrame.new(109, 4, -263)		
		local Tween = Tween:MakeTween(Info,Car,{CFrame = CFrame.new(Car.CFrame.X,Car.CFrame.Y,185)})
	end
end
