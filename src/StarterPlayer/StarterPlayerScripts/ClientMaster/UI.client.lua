local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RepStorage = game:GetService("ReplicatedStorage")

local Remotes = RepStorage.Remotes
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui
local ScreenGui = PlayerGui:WaitForChild("ScreenGui")
local Frame = ScreenGui:WaitForChild("Frame")
local Button = ScreenGui:WaitForChild("ImageButton")
local Opened = false

RepStorage.Game.Cooldown:GetPropertyChangedSignal("Value"):Connect(function()
	if RepStorage.Game.Cooldown.Value == 0 then
		ScreenGui.CooldownTime.Visible = false
	else
		ScreenGui.CooldownTime.Visible = true
	end
	ScreenGui.CooldownTime.Text = RepStorage.Game.Cooldown.Value.." seconds until brought back to normal time"
end)

UIS.InputBegan:Connect(function(Input,IsTyping)
	if Input.KeyCode == Enum.KeyCode.Return then
		Remotes.RewindTime:FireServer(Frame.TextBox.Text)
	end
end)

Button.MouseButton1Click:Connect(function()
	spawn(function()
		while wait() do
			Data = Remotes.Data:InvokeServer()

			if Data[1] == false then
				Frame.Cooldown.Visible = true
			else
				Frame.Cooldown.Visible = false
			end

			for i,v in ipairs(Data[2]) do
				if not Frame.ScrollingFrame:FindFirstChild(v[1].Name) then
					local TextLabel = Instance.new("TextLabel")
					TextLabel.Name = v[1].Name
					TextLabel.TextXAlignment = Enum.TextXAlignment.Left
					TextLabel.BackgroundTransparency = 1
					TextLabel.TextSize = 30
					TextLabel.Text = "Picked up "..v[1].Name.." "..v[2].." seconds ago"
					TextLabel.Font = Enum.Font.SciFi
					TextLabel.Parent = Frame.ScrollingFrame
				else
					Frame.ScrollingFrame:FindFirstChild(v[1].Name).Text = "Picked up "..v[1].Name.." "..v[2].." seconds ago"
				end
			end
		end
	end)
	
	Frame.Visible = not Frame.Visible
	game.Lighting.Blur.Enabled = not game.Lighting.Blur.Enabled
	Opened = not Opened
	
	if Opened == false then
		for i,v in pairs(Frame.ScrollingFrame:GetChildren()) do
			if v:IsA("TextLabel") then
				v:Destroy()
			end
		end
	end
end)