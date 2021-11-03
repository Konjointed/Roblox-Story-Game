local RepStorage = game:GetService("ReplicatedStorage")
local Pathfinding = game:GetService("PathfindingService")

local NPC = RepStorage.Models.NPC
local FloorPos = workspace.House.MainRoom.Floor.Position
local MurdererChosen = false
local Names = {
	"James",
	"Lizzie",
	"Emily",
	"Dominic",
	"Jack",
	"Brian",
	"Luke",
	"Chase",
	"Emilia",
	"Danny",
	"Tom",
	"Ted",
	"Christopher",
	"Emma",
	"Valeria",
	"Zack",
	"Hailey",
	"Haley",
	"Ted",
	"Bob",
	"Billy",
	"Montana",
	"Livy",
	"Liz",
	"Sophia",
	"Isabella",
	"Mia",
	"Olivia",
	"Amelia",
}

local Path = Pathfinding:CreatePath()
local Taken = {}
local function Move(Character)
	spawn(function()
		while wait() do
			if Character then
				wait(math.random(1,10))
				local PointOfInterest = workspace.PointOfInterest
				local PointToMoveTo = PointOfInterest:GetChildren()[math.random(1,#PointOfInterest:GetChildren())].Position
				if not Taken[PointToMoveTo] then
					Taken[PointToMoveTo] = Character.Name
					Path:ComputeAsync(Character.Torso.Position,PointToMoveTo)
					local Waypoints = Path:GetWaypoints()

					for i,waypoint in pairs(Waypoints) do
						if Character:FindFirstChild("InInteraction") then
							break
						end
						Character.Humanoid:MoveTo(waypoint.Position)
						Character.Humanoid.MoveToFinished:Wait()
					end
					Taken[PointToMoveTo] = nil
				end
			end
		end
	end)
end


local function RandomPos()
	local Rand = Random.new() --// No seed, you can give one if you'd like
	local XMin, XMax = FloorPos.X-10,FloorPos.X+10
	local YMin, YMax = FloorPos.Y+3, FloorPos.Y+3
	local ZMin, ZMax = FloorPos.Z-10,FloorPos.Z+10

	local RandomX = Rand:NextNumber(XMin, XMax)
	local RandomY = Rand:NextNumber(YMin, YMax)
	local RandomZ = Rand:NextNumber(ZMin, ZMax)

	local RandomPosition = CFrame.new(RandomX, RandomY, RandomZ)

	return RandomPosition
end

for i = 1,10 do
	local Part = Instance.new("Part")
	Part.Anchored = true
	Part.Transparency = 0.5
	Part.Parent = workspace
	Part.CFrame = RandomPos() 
	Part.Size = Vector3.new(4, 2, 2)

	if #Part:GetTouchingParts() ~= 0 then
		repeat 
			Part.CFrame = RandomPos() 
			warn("Part Touching Something") 
			wait()
		until #Part:GetTouchingParts() == 0 
		warn("Part No Longer Touching Something")
	end
	
	local Dummy = NPC:Clone()
	local rand = math.random(1,#Names)
	Dummy.Name = Names[rand]
	table.remove(Names,rand)
	Dummy.HumanoidRootPart.CFrame = Part.CFrame
	Dummy.Parent = workspace.House.NPCs
	
	if MurdererChosen == false then
		local chance = math.random(0,100)
		if chance >= 50 then
			local IsMurderer = Instance.new("BoolValue")
			IsMurderer.Name = "Murderer"
			Dummy.Name = Dummy.Name.." (Murderer)"
			IsMurderer.Parent = Dummy
			MurdererChosen = true
		end		
	end
	
	Move(Dummy)

	Part:Destroy()
end