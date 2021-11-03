local seat = script.Parent.Seat

seat.ChildAdded:connect(function(obj)
	if obj.Name == "SeatWeld" then
		local player = game.Players:GetPlayerFromCharacter(obj.Part1.Parent)
		if player then
			script.Parent.Water.BrickColor = BrickColor.new("Cool yellow")
			script.Parent.ToiletUsed.Value = true
		end
	end
end)