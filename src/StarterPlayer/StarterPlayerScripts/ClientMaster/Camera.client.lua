--Description: Moves camera between rooms based on which part the humanoidrootpart is touching

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RepStorage = game:GetService("ReplicatedStorage")

local Reset = require(RepStorage.Functions.Reset)
local Functions = require(RepStorage.Functions.Functions)

local Remotes = RepStorage.Remotes
local Camera = workspace.CurrentCamera
local Player = Players.LocalPlayer
local Character = Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

local MouseIgnore = workspace.MouseIgnore

_G.CurrentCam = nil

local Lerp = 1
_G.CurrentRegion = nil

local function GetTouchingParts(Part)
	local Connection = Part.Touched:Connect(function() end)
	local Results = Part:GetTouchingParts()
	Connection:Disconnect()
	return Results
end

local function GetClosest(Regions)
	if #Regions == 0 then return end

	local Closest
	local Distance = math.huge

	for _,Region in pairs(Regions) do
		local Magnitude = (Region.Position - HRP.Position).Magnitude

		if Magnitude < Distance then
			Closest = Region
			Distance = Magnitude
		end
	end

	return Closest
end

local function CameraRegion()
	local Regions = {}
	local InBounds = false

	local Results = GetTouchingParts(HRP)
	for _,Part in pairs(Results) do
		if string.find(Part.Name,"Region") then
			table.insert(Regions,Part)
		end
		if Part.Name == "Bounds" then
			InBounds = true
		end
	end
	
	if not InBounds then
		Player:Kick("Out of bounds")
	end

	local ClosestRegion = GetClosest(Regions)
	if ClosestRegion then
		if _G.CurrentRoom ~= nil then
			if MouseIgnore.Blackouts:FindFirstChild(_G.CurrentRoom.."Cover") then
				MouseIgnore.Blackouts[_G.CurrentRoom.."Cover"].Transparency = 0				
			end			
		end
		
		_G.CurrentRoom = string.gsub(ClosestRegion.Name,"Region","")
		--if _G.CurrentRoom == "Outside" then
		--	Remotes.Reset:FireServer() --> going outside is basically like resetting
		--else
			Camera.CameraType = Enum.CameraType.Scriptable

			if _G.CurrentCam ~= Character.Head then
				_G.CurrentCam = ClosestRegion.RoomCam
			end

			Camera.CFrame = Camera.CFrame:Lerp(_G.CurrentCam.CFrame,Lerp)
			
			--| Each room has a blackout roof so you cant see it when you're in another room
			--| when you're in the room though change the transparency so you can actually look into it
			if MouseIgnore.Blackouts:FindFirstChild(_G.CurrentRoom.."Cover") then
				MouseIgnore.Blackouts[_G.CurrentRoom.."Cover"].Transparency = 1				
			end
		--end
	else
		Camera.CameraType = Enum.CameraType.Custom
	end
end

RunService:BindToRenderStep("Camera Regions", Enum.RenderPriority.Camera.Value - 9, CameraRegion)


