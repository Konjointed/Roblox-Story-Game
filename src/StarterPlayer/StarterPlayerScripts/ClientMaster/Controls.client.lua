local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RepStorage = game:GetService("ReplicatedStorage")

local Tween = require(RepStorage.Functions.Tween)

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui
local Inventory = PlayerGui:WaitForChild("ScreenGui").Inventory

local Opened = false

local Info = TweenInfo.new(
	0.5, -- Time
	Enum.EasingStyle.Sine, -- EasingStyle
	Enum.EasingDirection.Out, -- EasingDirection
	0, -- RepeatCount (when less than zero the tween will loop indefinitely)
	false, -- Reverses (tween will reverse once reaching it's goal)
	0 -- DelayTime
)

UIS.InputBegan:Connect(function(Input,Processed)
	if Processed then return end
	
	if Input.KeyCode == Enum.KeyCode.Tab then
		if Opened then
			Opened = false
			Tween:MakeTween(Info,Inventory,{Position = UDim2.new(0,0,-1,0)},false,true)
		else
			Opened = true
			Tween:MakeTween(Info,Inventory,{Position = UDim2.new(0,0,0,0)},false,true)
		end
	end
end)