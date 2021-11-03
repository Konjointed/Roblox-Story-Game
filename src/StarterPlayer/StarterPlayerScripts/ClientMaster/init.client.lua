local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RepStorage = game:GetService("ReplicatedStorage")

game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
--wait()
--game.StarterGui:SetCore("ResetButtonCallback", false)

local Inventory = require(RepStorage.Functions.Inventory)
local Functions = require(RepStorage.Functions.Functions)

local Remotes = RepStorage.Remotes

local Player = Players.LocalPlayer
local Character = Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,false)
local PlayerGui = Player.PlayerGui
local InventoryFrame = PlayerGui:WaitForChild("ScreenGui").Inventory

Lighting.ClockTime = 0

local Blackouts = workspace.MouseIgnore.Blackouts
for _,Part in pairs(Blackouts:GetChildren()) do
	if Part.Name ~= "Part" and Part.Name ~= "MainRoomCover" then
		Part.Transparency = 0
	end
end