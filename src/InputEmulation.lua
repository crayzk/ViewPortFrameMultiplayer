--[[ CHILD of MAIN.lua ]]--

--[[
  The main purpose of this module is to emulate multiple cursor movements, using the joysticks, the mouse, among other binds
    -written by vivivio
    -briefing by crayzk (pls update vivivio)
--]]

local InputEmulator = {}
-- [[ SERVICES ]] --
local UserInputSvc = game:GetService("UserInputService")
-- [[ CONSTANTS ]] --
local EMULATOR_MODE = {
	["Keyboard"] = 1,
	["Gamepad"] = 2,
	["Tablet"] = 3
}

-- [[ VARIABLES ]] --
local CurEmulatorMode = EMULATOR_MODE.Keyboard -- Default emulator mode is keyboard
local BindedInputs = {} -- Inputs binded to functions

-- [[ LOGIC ]] --
function UnBindAll() -- Removes all previously binded functions
	for i in ipairs(BindedInputs) do
		table.remove(BindedInputs, i)
	end
end

function InputEmulator:SetMode(EmulatorMode)
	if EmulatorMode == "Gamepad" then
		CurEmulatorMode = EMULATOR_MODE.Gamepad
		UnBindAll() 
	elseif EmulatorMode == "Keyboard" then
		CurEmulatorMode = EMULATOR_MODE.Keyboard
		UnBindAll()
	elseif EmulatorMode == "Tablet" then
		CurEmulatorMode = EMULATOR_MODE.Tablet
		UnBindAll()
	end
end

function InputEmulator:Bind(BindName, InputType, CallBack, GamepadNum)
	
	if type(InputType) == "table" then
		local InputObjs = {}
		for _,v in ipairs(InputType) do -- Support for a list of inputs
			table.insert(InputObjs, v)
		end
		InputType = InputObjs
	end
	
	if CurEmulatorMode == EMULATOR_MODE.Keyboard then
		table.insert(BindedInputs, {BindName, InputType, CallBack}) -- The name of the bind is [1], the InputType { KeyCode or UserInputType } is [2] and the callback function is [3]
	elseif CurEmulatorMode == EMULATOR_MODE.Gamepad then
		table.insert(BindedInputs, {BindName, InputType, CallBack, GamepadNum}) -- The name of the bind is [1], the keycode is [2], the callback function is [3] and the Gamepad number is [4]
	elseif CurEmulatorMode == EMULATOR_MODE.Tablet then
		-- JOSHHHHHHH
	end
end

function InputEmulator:UnBind(BindName)
	for i in ipairs(BindedInputs) do
		if BindedInputs[i][1] == BindName then
			table.remove(BindedInputs, i)
			break
		end
	end
end





function InputEvt(InputObj)
	
	if CurEmulatorMode == EMULATOR_MODE.Keyboard then
		for _,v in ipairs(BindedInputs) do
			
			if type(v[2]) ~= "table" then
				if v[2] == InputObj.KeyCode or v[2] == InputObj.UserInputType then -- or statement is there to register mouse events 
					if v[3] then
						v[3](InputObj)
					else
						warn('WARNING!' .. v[2].Name .. ' function is missing or nil.')
					end
				end
			else
				for _,input in ipairs(v[2]) do -- Support for a list of inputs
					if input == InputObj.KeyCode or input == InputObj.UserInputType then -- or statement is there to register mouse events 
						v[3](InputObj)
					end
				end
			end
		end
	elseif CurEmulatorMode == EMULATOR_MODE.Gamepad then
		for _,v in ipairs(BindedInputs) do
			if type(v[2]) ~= "table" then
				if UserInputSvc:IsGamepadButtonDown(v[4], v[2]) then
					v[3](InputObj)
				end
			else
				for _,input in ipairs(v[2]) do -- Support for a list of inputs
					if UserInputSvc:IsGamepadButtonDown(v[4], input) then
						v[3](InputObj)
					end
				end
			end
		end
	elseif CurEmulatorMode == EMULATOR_MODE.Tablet then
		-- JOSH GET OVER HERE
	end
end

-- [[ BINDING EVENTS ]] --

UserInputSvc.InputBegan:Connect(InputEvt)
UserInputSvc.InputChanged:Connect(InputEvt)

return InputEmulator
