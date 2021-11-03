local ClickerModule = require(343254562)
local clickEvent = ClickerModule.RemoteEvent
local interactiveParts = {}
local activationDistance = 12
local flushing = false
local water = script.Parent.Water
local sound = water.FlushSound

for i, v in pairs(script.Parent:GetChildren()) do
	if v.Name == "Interactive" then
		table.insert(interactiveParts, v)
	end
end

local function distanceToCharacter(player, part)
	local character = player.Character
	if character then
		local torso = character:FindFirstChild("Torso")
		if torso then
			return((torso.Position - part.Position).magnitude)
		end
	end
	return math.huge
end

function toiletHandle()
	for i = 1, 5 do
		script.Parent.Interactive.CFrame = script.Parent.Handle.CFrame * CFrame.Angles(math.pi/2, 0, math.rad(12) * i) * CFrame.new(0, -0.1, -0.1)
		wait()
	end
	wait(1)
	for i = 5, 1, -1 do
		script.Parent.Interactive.CFrame = script.Parent.Handle.CFrame * CFrame.Angles(math.pi/2, 0, math.rad(12) * (i - 1)) * CFrame.new(0, -0.1, -0.1)
		wait()
	end
end

clickEvent.OnServerEvent:connect(function(player, part)
	local isPart = false
	for i = 1, #interactiveParts do
		if part == interactiveParts[i] then
			isPart = true
		end
	end
	if isPart and player.Character and distanceToCharacter(player, part) <= activationDistance then
		if flushing == false then
			flushing = true
			spawn(toiletHandle)
			sound:Play()
			for i, v in pairs(script.Parent:GetChildren()) do
				if v.Name == "WaterSwirl" then
					v.ParticleEmitter.Transparency = NumberSequence.new(0.9)
					v.ParticleEmitter.Rate = 40
				end
			end
			
			for i = 1, 4 do
				water.CFrame = water.CFrame * CFrame.new(0, 0.01, 0)
				wait()
			end
			for i = 1, 22 do
				water.Mesh.Scale = water.Mesh.Scale + Vector3.new(-0.02, 0, -0.02)
				water.CFrame = water.CFrame * CFrame.new(0, -0.015, 0)
				wait()
			end
			
			if script.Parent.ToiletUsed.Value == true then
				water.BrickColor = BrickColor.new("Pastel yellow")
			end
			
			wait(1)
			
			for i = 1, 10 do
				print(i)
				for ii, v in pairs(script.Parent:GetChildren()) do
					if v.Name == "WaterSwirl" then
						v.ParticleEmitter.Transparency = NumberSequence.new(0.9 + (0.015 * i))
						if i == 10 then
							v.ParticleEmitter.Rate = 0
						end
					end
				end
				wait(0.2)
			end
			
			script.Parent.ToiletUsed.Value = false
			water.BrickColor = BrickColor.new("Fog")
			
			for i = 1, 66 do
				water.Mesh.Scale = water.Mesh.Scale + Vector3.new(0.0066, 0, 0.0066)
				water.CFrame = water.CFrame * CFrame.new(0, 0.00409, 0)
				wait()
			end
			water.CFrame = script.Parent.WaterResetPos.CFrame
			water.Mesh.Scale = Vector3.new(1,0,1)
			flushing = false
		end
	end
end)