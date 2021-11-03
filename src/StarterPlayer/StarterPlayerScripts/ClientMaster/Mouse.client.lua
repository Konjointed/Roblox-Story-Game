

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local CS = game:GetService("CollectionService")
local PF = game:GetService("PathfindingService")
local RepStorage = game:GetService("ReplicatedStorage")

local Functions = require(game:GetService("ReplicatedStorage"):WaitForChild("Functions").Functions)
local Inventory = require(RepStorage.Functions.Inventory)

local Player = Players.LocalPlayer
local Character = Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Mouse = Player:GetMouse()
Mouse.TargetFilter = workspace.MouseIgnore
local Camera = workspace.CurrentCamera
local PlayerGui = Player.PlayerGui
local InventoryFrame = PlayerGui:WaitForChild("ScreenGui").Inventory
local Remotes = RepStorage.Remotes
local label = Player.PlayerGui:WaitForChild("NameGui")
local InteractingWith

--| Click to move / clicking on an interactable object (uses collection service)
--was gonna use pathfinding to make the click to move smarter but it gets all weird when trying to
--click somewhere else
Mouse.Button1Down:Connect(function()
	--local Position = Mouse.Hit.p
	--local Path = PF:CreatePath()
	--Path:ComputeAsync(Character.HumanoidRootPart.Position,Position)
	--local Waypoints = Path:GetWaypoints()
	
	--coroutine.wrap(function()
	--	for _,Waypoint in pairs(Waypoints) do
	--		Humanoid:MoveTo(Waypoint.Position)
	--		Humanoid.MoveToFinished:Wait()		
	--	end	
	--	local Finished = true
	--end)()
	
	local Position = Mouse.Hit.p
	Humanoid:MoveTo(Position)

	--> Cancel the thing we trying to interact with if any
	if InteractingWith ~= nil then
		warn("Cancelled Interaction")
		InteractingWith = nil
	end	
	
	if CS:HasTag(Mouse.Target,"Interactable") or CS:HasTag(Mouse.Target.Parent,"Interactable") then
		warn("Going to interact with an object")
		if Mouse.Target.Parent and Mouse.Target.Parent ~= workspace and Mouse.Target.Parent.Name ~= "Decoration" then
			InteractingWith = Mouse.Target.Parent.Name
		else
			InteractingWith = Mouse.Target.Name				
		end
	end
	
	--[[
	I decided to use magnitude to detect when the player gets near the item
	to do this I just find loop through all the items in the CurrentRoom (_G.CurrentRoom)
	and then move to the part
	]]
	if InteractingWith then
		local Part
		for _,v in pairs(workspace.House[_G.CurrentRoom]:GetDescendants()) do
			if v.Name == InteractingWith then
				Part = v
				break
			end
		end

		local PartToMoveTo
		if Part:IsA("Model") then
			PartToMoveTo = Part:FindFirstChildWhichIsA("Part") or Part:FindFirstChildWhichIsA("UnionOperation")
		else
			PartToMoveTo = Part
		end

		while wait() and InteractingWith do
			local Magnitude = (Character.HumanoidRootPart.Position - PartToMoveTo.Position).Magnitude
			if math.floor(Magnitude) <= 7 then
				Humanoid:MoveTo(Character.HumanoidRootPart.Position)
				if InteractingWith ~= nil then
					if CS:HasTag(Part,"Item") then
						Remotes.ActionMade:FireServer(Part,_G.CurrentRoom)
						--Part:Destroy()
						Inventory:AddItem(InventoryFrame,Part)
					elseif CS:HasTag(Part,"NPC") then
						
					else
						local FunctionName = string.gsub(InteractingWith," ","")
						Functions[FunctionName]()					
					end
					InteractingWith = nil
				end
				break
			end
		end	
	end
end)

--| Hovering over a interactable target
UIS.InputChanged:Connect(function(Input)
	if Mouse.Target then
		if CS:HasTag(Mouse.Target,"Interactable") or CS:HasTag(Mouse.Target.Parent,"Interactable") then
			label.Enabled = true
			label.Adornee = Mouse.Target
			if Mouse.Target.Parent and Mouse.Target.Parent ~= workspace and Mouse.Target.Parent.Name ~= "Decoration" then
				label.TextLabel.Text = Mouse.Target.Parent.Name		
			else
				label.TextLabel.Text = Mouse.Target.Name		
			end
		else
			label.Enabled = false
			label.Adornee = nil
			label.TextLabel.Text = ""
		end
	end
end)
