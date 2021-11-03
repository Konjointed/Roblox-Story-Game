local Inventory = {}

local RepStorage = game:GetService("ReplicatedStorage")
local SSS = game:GetService("ServerScriptService")

local Actions = require(SSS.Actions)

local Remotes = RepStorage.Remotes

Inventory.CurrentInventory = {}
--Inventory.InventoryBeforeRewind = {}

Remotes.ActionMade.OnServerEvent:Connect(function(Player,V1,V2)
	if V1 ~= "Light" then
		if _G.RewindActive ~= true then --DONT SAVE THE ITEM TO THEIR CURRENT INVENTORY IF THE ABILITY IS ACTIVE
			--CurrentInventory is the inventory in the current time which they will go back to when the ability ends
			table.insert(Inventory.CurrentInventory,V1.Name)
			local NewInventory = {}
			for i,v in pairs(Inventory.CurrentInventory) do
				table.insert(NewInventory,v)
			end
			table.insert(Actions.Action["Inventory"],{NewInventory,0})
			spawn(function()
				Actions:TimeActionWasMade(Actions.Action["Inventory"][Actions:Length(Actions.Action["Inventory"])],Actions.Action["Inventory"],Actions:Length(Actions.Action["Inventory"]))
			end)			
		end
	end
end)

return Inventory
