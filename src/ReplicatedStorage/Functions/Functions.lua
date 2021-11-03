local Functions = {}

local RepStorage = game:GetService("ReplicatedStorage")
local Remotes = RepStorage.Remotes
local Sounds = RepStorage.Sounds

function Functions:SwitchLight(SurfaceLight)
	Sounds.LightSwitch:Play()
	if SurfaceLight.Brightness == 3 then
		SurfaceLight.Brightness = 0
	else
		SurfaceLight.Brightness = 3
	end
end

function Functions:HasProperty(object, propertyName)
	local success, _ = pcall(function() 
		object[propertyName] = object[propertyName]
	end)
	return success
end

function Functions:FirstPerson(Character)
	for _,Part in pairs(Character:GetDescendants()) do
		if Functions:HasProperty(Part,"Transparency") then
			Part.Transparency = 1
		end
	end
	_G.CurrentCam = Character.Head
end

function Functions:ExitFirstPerson(Character)
	for _,Part in pairs(Character:GetDescendants()) do
		if Functions:HasProperty(Part,"Transparency") then
			Part.Transparency = 0
		end
	end
	_G.CurrentCam = nil
end

function Functions:LightSwitch()
	Remotes.ActionMade:FireServer("Light",string.lower(_G.CurrentRoom))
end

function Functions:Radio()
	Sounds.tro.Playing = not Sounds.tro.Playing
end

return Functions
