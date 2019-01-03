--// this module acts as simply a container for the other modules.

return [[
	Documentation:
	
		~S1: PlayerAPI
		~S2: Rendering
		~S3: InputAPI
	--------------------
	
	
	
	
	[~S1] PlayerAPI
		Methods:
			:AddPlayer(Host,GuestId)
				-creates a new player, and returns that player's table data
				
			:RemovePlayer(Player)
				-removes all player data, and player's character
				
			:GetPlayers() -- NOT DONE
				-returns a list of tables, that mimics a normal players
			:GetLocalPlayers() -- NOT DONE
				-returns a list of players on the Local Machine, (as well as their local properties like mouse,etc)
			:GetPlayerFromCharacter(char) --NOT DONE
]]
