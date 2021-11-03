local Inventory = {}

local RepStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui
local Remotes = RepStorage.Remotes

Inventory.CurrentInventory = {}

Remotes.UpdateInventory.OnClientEvent:Connect(function(NewInventory)
	local InventoryFrame = PlayerGui:WaitForChild("ScreenGui").Inventory
	for _,Item in pairs(InventoryFrame:GetChildren()) do
		if Item:IsA("TextButton") then
			Item:Destroy()
		end
	end
	for _,Item in pairs(NewInventory) do
		local TextButton = Instance.new("TextButton")
		TextButton.Text = Item
		TextButton.Parent = InventoryFrame
	end
end)

function Inventory:ClearAll(InventoryFrame)
	for _,Item in pairs(InventoryFrame:GetChildren()) do
		if not Item:IsA("UIGridLayout") then
			Item:Destroy()
			Inventory.CurrentInventory = {}
		end
	end
end

function Inventory:AddItem(InventoryFrame,Item)
	local TextButton = Instance.new("TextButton")
	TextButton.Text = Item.Name
	TextButton.Parent = InventoryFrame
	table.insert(Inventory.CurrentInventory,Item)
end

function Inventory:RemoveItem(InventoryFrame,Item)
	for _,Item in pairs(InventoryFrame:GetChildren()) do
		if Item == Item then
			Item:Destroy()
		end
	end
end

return Inventory
