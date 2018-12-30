--[[
	
	The main module for the entire system!
	
	A couple of functions that happen here..
		The frame patterns are distributed to the requesting clients
		>Multiplayer:AddPlayer()
		>Multiplayer:RemovePlayer()
		
		The world and it's players are copied and replicated through this module
		>Multiplayer:InitiateWorld(ignorelist) -- ignore list is not replicated at all
		
	
--]]


local Multiplayer = {}
local MaxPlayers = 4
local PlayerCount = 1

local SkyboxDist = (2^14)-1 -- distance the skybox is away from the camera

--

--
-- CRAYZK REPORTING IN!
--

function GetInstances(dir,parts,characters)-- do ( bad crazyk >:( )
	-- we create a custom get descendants so we can have characters in a seperate list
	
	local dir = dir or game.Workspace
	local parts = parts or {}
	local characters = characters or {}
	
	for key,item in pairs(dir:GetChildren()) do
		
		local human = item:FindFirstChildOfClass('Humanoid')
		if human then
			table.insert(characters,item)
		else
			local human = item.Parent:FindFirstChildOfClass('Humanoid') or item.Parent.Parent:FindFirstChildOfClass('Humanoid')
			if item:IsA('BasePart') and not human then
				table.insert(parts,item)
			end
		end
		
		GetInstances(item,parts,characters)
	end
	
	return parts,characters
end

function Multiplayer:InitiateWorld(ignorelist)
	
	-- Create the initial WorldModel and mimic it's world counterparts
	-- ignorelist should at least contain the local player we are creating for...
	
	local ignorelist = ignorelist or nil -- this actually doesn't behave as a list at the moment
	local world = Instance.new('Model')
	
	--generate world copy
	for key,item in pairs (GetInstances()) do
		if not (ignorelist and item:IsDescendantOf(ignorelist)) and item:IsA('BasePart') and item:IsA('Terrain') == false then
			--copy the item to model 'world'
			
			local copycat = item:Clone()
			copycat.Parent = world
			
			if item.Anchored == false then -- mimic it's real counterpart
				copycat.Anchored=true
				item.Changed:connect(function()
					copycat.CFrame = item.CFrame
				end)
			end
		elseif item:IsA('Model') then
			-- copy the character
			
			item.Archivable = true
			local char = item:Clone()
			item.Archivable = false
			
			char.Parent = world
			
			item.PrimaryPart.Changed:connect(function() -- mimic it's real counterpart
				char:SetPrimaryPartCFrame(item:GetPrimaryPartCFrame())
			end)
			
			item.Humanoid.Changed:connect(function()
				-- stuff we'll do for animations and things
			end)
			
		end
	end
	
	--generate pseudo_skybox
	--set up skybox using decals
	local pseudo_skybox = script.Skybox:Clone()
	local sky = game.Lighting:FindFirstChildOfClass('Sky')
	
	for key,part in pairs (pseudo_skybox:GetChildren()) do
		print(part)
		if part.Name ~= 'Center' then
			print(key)
			local decal = part:FindFirstChildOfClass('Decal')
			local texture = sky['Skybox' .. part.Name]
			if texture then
				decal.Texture = texture
			end
			
			local mesh = part:FindFirstChildOfClass('BlockMesh')
			mesh.Scale = mesh.Scale * (SkyboxDist * 2)
			mesh.Offset = (part.CFrame.p -  pseudo_skybox:GetPrimaryPartCFrame().p).unit * (SkyboxDist-1)
		end
	end
	
	return world,pseudo_skybox
end




--
--
--
--

--//let's initiate the gui here, so we don't have to burden creators with any extra information on how to set up the scripts
local PlayerGui = game.Players.LocalPlayer:WaitForChild('PlayerGui')
local SplitGui = Instance.new('ScreenGui')
SplitGui.Parent = PlayerGui
SplitGui.Name = 'Split-Screen Gui'

SplitGui.ResetOnSpawn = false
--


function Multiplayer:AddPlayer(Gui, Controller)
	-- Gui: ScreenGui to contain splitscreen
	-- Controller: Controller to be used
	
	local Gui = Gui or SplitGui
	
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
	
	local Gui = Gui or SplitGui
	
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

-- HELLO JOSHRBX WAS HERE


return Multiplayer
