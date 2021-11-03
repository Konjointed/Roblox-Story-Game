local Actions = {}

Actions.Action = {
	["Movement"] = {},
	["Items"] = {},
	["Kills"] = {},
	["Inventory"] = {}
}

function Actions:Length(Table)
	local counter = 0 
	for _, v in pairs(Table) do
		counter =counter + 1
	end
	return counter
end

--| A timer for when the action was made which will go up until 300 seconds (5min) and then get removed
function Actions:TimeActionWasMade(Table,Test1,Test2)
	for i = 0,300 do
		Table[2] = i
		wait(1)
	end
	if Test1 then
		Test1[Test2] = nil
	end
end

return Actions
