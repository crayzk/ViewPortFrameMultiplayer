local Multiplayer = {}
local MaxPlayers = 4
local PlayerCount = 1

function Multiplayer:AddPlayer(Gui, Controller)
	-- Gui: ScreenGui to contain splitscreen
	-- Controller: Controller to be used
	if PlayerCount < MaxPlayers then
		Gui:ClearAllChildren()
		PlayerCount = PlayerCount + 1
		local SplitScreen = script[tostring(PlayerCount)]:Clone()
		
		SplitScreen.Parent = Gui
	else
		warn("Too many players, request ignored! Max is " .. MaxPlayers)
	end
end

function Multiplayer:RemovePlayer(Gui)
	-- Gui: ScreenGui to contain splitscreen
	if PlayerCount > 1 then
		Gui:ClearAllChildren()
		PlayerCount = PlayerCount - 1
		if PlayerCount >= 2 then
			local SplitScreen = script[tostring(PlayerCount)]:Clone()
			
			SplitScreen.Parent = Gui
		end
	else
		warn("Not enough players to remove, request ignored!")
	end
end

return Multiplayer

-- HELLO JOSHRBX WAS HERE
