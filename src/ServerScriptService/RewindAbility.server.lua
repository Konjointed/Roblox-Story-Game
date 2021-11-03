local Players = game:GetService("Players")
local RepStorage = game:GetService("ReplicatedStorage")
local ServStorage = game:GetService("ServerStorage")
local SSS = game:GetService("ServerScriptService")

local Actions = require(SSS.Actions)
local Inventory = require(SSS.Inventory)

local Remotes = RepStorage.Remotes
local CurrentTime = os.time()
local Debounce = true
local RewindDuration = 10
_G.RewindActive = false

--| Gets The Latest Timed Action
local function GetLatestTime(Table)
	local HighestTime = 0
	for i,v in pairs(Table) do
		if v[2] >= HighestTime then
			HighestTime = v[2]
		end
	end
	return HighestTime
end

Remotes.Data.OnServerInvoke = function(Player)
	return({Debounce,Actions.Action["Items"]})
end

Remotes.ActionMade.OnServerEvent:Connect(function(Player,V1,V2) 
	if V1 == "Light" then
		warn("TEST")
		local Functions = require(RepStorage.Functions.Functions)
		if V2 == "mainroom" then
			Functions:SwitchLight(workspace.House.MainRoom.Light.SurfaceLight)
		elseif V2 == "bedroom" then
			Functions:SwitchLight(workspace.House.Bedroom.Light.SurfaceLight)
		elseif V2 == "bathroom" then
			Functions:SwitchLight(workspace.House.Bathroom.Light.SurfaceLight)
		end
	else
		V1.Parent = RepStorage
		if _G.RewindActive ~= true then --| Do not save picking up items when ability is active
			--| Will just be weird
			table.insert(Actions.Action["Items"],{V1,0,V2})
			spawn(function()
				Actions:TimeActionWasMade(Actions.Action["Items"][Actions:Length(Actions.Action["Items"])],Actions.Action["Items"],Actions:Length(Actions.Action["Items"]))
			end)			
		end
	end
end)

Remotes.RewindTime.OnServerEvent:Connect(function(Player,Time,Parent)
	if Debounce then
		Debounce = false
		_G.RewindActive = true
		local CurrentPosition = Player.Character.HumanoidRootPart.Position
		local CurrentHouseState = workspace.House:Clone()
		local InventoryBeforeRewind = {}
		for _,Item in pairs(Inventory.CurrentInventory) do
			table.insert(InventoryBeforeRewind,Item)
		end
		warn(InventoryBeforeRewind)
		CurrentHouseState.Parent = ServStorage.Models
		if Time then
			
			local AmountToGoBack = tonumber(Time)
			warn("Going back "..AmountToGoBack.." seconds")
			for i,v in ipairs(Actions.Action["Movement"]) do
				warn("Time In Table "..v[2].." Entered Time "..AmountToGoBack)
				if tonumber(v[2]) <= AmountToGoBack then
					warn("FOUND THE "..v[2].." ONE")
					Player.Character.HumanoidRootPart.Position = v[1]
					break
				end
			end
			
			for i,v in ipairs(Actions.Action["Inventory"]) do
				if tonumber(v[2]) <= AmountToGoBack then
					warn(v[1])
					Remotes.UpdateInventory:FireClient(Player,v[1])
					break
				end
			end
			
			local Items = 0
			for i,v in ipairs(Actions.Action["Items"]) do
				if tonumber(v[2]) <= AmountToGoBack then
					local Test = v[1]:Clone()
					Test.Parent = workspace.House[v[3]]["Decoration"]
					Items += 1
				end
			end
			warn(Items.." Item(s) were put back")
			
			local NPCs = 0
			for i,v in ipairs(Actions.Action["Kills"]) do
				if tonumber(v[2]) <= AmountToGoBack then
					local Test = v[1]:Clone()
					Test.Parent = workspace.House.NPCs
					NPCs += 1
				end
			end
			warn(NPCs.." NPC(s) were put back")
		end
		
		for i = RewindDuration,0,-1 do
			RepStorage.Game.Cooldown.Value = i
			wait(1)
		end

		warn("Going back to current time")
		_G.RewindActive = false
		warn(InventoryBeforeRewind)
		Remotes.UpdateInventory:FireClient(Player,InventoryBeforeRewind)
		Player.Character.HumanoidRootPart.Position = CurrentPosition
		workspace.House:Destroy()
		CurrentHouseState.Parent = workspace
		
		Debounce = true
	else
		warn("On Cooldown")
	end
end)

Players.PlayerAdded:Connect(function(Player)
	Player.CharacterAdded:Connect(function(Character)
		while Character do			
			--| This is also probably not needed but basically adds the first movement so it doesn't error
			if Actions:Length(Actions.Action["Movement"]) == 0 then
				table.insert(Actions.Action["Movement"],{Character.HumanoidRootPart.Position,0})
				spawn(function()
					Actions:TimeActionWasMade(Actions.Action["Movement"][Actions:Length(Actions.Action["Movement"])],Actions.Action["Movement"],Actions:Length(Actions.Action["Movement"]))
				end)
			end
			
			--| Get the last position aka the most recent added thing
			local LastPosition = Actions.Action["Movement"][Actions:Length(Actions.Action["Movement"])] 
			
			--| Check if it doesn't equal the current position
			if LastPosition[1] ~= Character.HumanoidRootPart.Position then
				--warn("New Position")
				table.insert(Actions.Action["Movement"],{Character.HumanoidRootPart.Position,0})
				spawn(function()
					Actions:TimeActionWasMade(Actions.Action["Movement"][Actions:Length(Actions.Action["Movement"])],Actions.Action["Movement"],Actions:Length(Actions.Action["Movement"]))
				end)
				--warn(Actions.Action)
			end
			
			wait(1)
		end
	end)
end)

