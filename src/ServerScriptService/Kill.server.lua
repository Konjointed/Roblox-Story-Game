local RepStorage = game:GetService("ReplicatedStorage")
local ServStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local SSS = game:GetService("ServerScriptService")

local Actions = require(SSS.Actions)

local Remotes = RepStorage.Remotes
local NPCFolder = workspace.House.NPCs

local function GetNPCToKill()
	return NPCFolder:GetChildren()[math.random(1,#NPCFolder:GetChildren())]
end

while true do
	for i = 720,0,-1 do
		if i == 0 then
			warn("Killing NPC")
			repeat 
				NPCToKill = GetNPCToKill()
				if NPCToKill:FindFirstChild("Murderer") then
					warn("Getting new target")
				end
				wait()
			until not NPCToKill:FindFirstChild("Murderer")
			NPCToKill.Parent = RepStorage.Models
			table.insert(Actions.Action["Kills"],{NPCToKill,0})
			spawn(function()
				Actions:TimeActionWasMade(Actions.Action["Kills"][Actions:Length(Actions.Action["Kills"])],Actions.Action["Kills"],Actions:Length(Actions.Action["Kills"]))
			end)
		end
		wait(1)
	end	
	wait()
end