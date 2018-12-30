--[[ PARENTED to MAIN.lua ]]--

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
function FlushTbl() -- Removes all previously binded functions
	for i,_ in ipairs(BindedInputs) do
		table.remove(BindedInputs, i)
	end
end

function InputEmulator:SetMode(EmulatorMode)
	if EmulatorMode == "Gamepad" then
		CurEmulatorMode = EMULATOR_MODE.Gamepad
		FlushTbl() 
	elseif EmulatorMode == "Keyboard" then
		CurEmulatorMode = EMULATOR_MODE.Keyboard
		FlushTbl()
	elseif EmulatorMode == "Tablet" then
		CurEmulatorMode = EMULATOR_MODE.Tablet
		FlushTbl()
	end
end

function InputEmulator:Bind(BindName, KeyCode, CallBack, GamepadNum)
	if CurEmulatorMode == EMULATOR_MODE.Keyboard then
		table.insert(BindedInputs, {BindName, KeyCode, CallBack}) -- The name of the bind is [1], the keycode is [2] and the callback function is [3]
	elseif CurEmulatorMode == EMULATOR_MODE.Gamepad then
		table.insert(BindedInputs, {BindName, KeyCode, CallBack, GamepadNum}) -- The name of the bind is [1], the keycode is [2], the callback function is [3] and the Gamepad number is [4]
	elseif CurEmulatorMode == EMULATOR_MODE.Tablet then
		-- NOT DONE REEEE
	end
end

function InputEmulator:UnBind(BindName)
	for i,_ in ipairs(BindedInputs) do
		if BindedInputs[i][3] == BindName then
			table.remove(BindedInputs, i)
			break
		end
	end
end

function InputEmulator:CreateCursor() -- Will be used to emulate multiple joysticks and fingers
	local CursorObj = {}
	
	function CursorObj:BindInputFrom()
		
	end
	
	return CursorObj
end

function InputEvt(InputObj)
	if CurEmulatorMode == EMULATOR_MODE.Keyboard then
		for _,v in ipairs(BindedInputs) do
			if v[2] == InputObj.KeyCode or v[2] == InputObj.UserInputType then -- or statement is there to register mouse events 
				v[3](InputObj)
			end
		end
	elseif CurEmulatorMode == EMULATOR_MODE.Gamepad then
		for _,v in ipairs(BindedInputs) do
			if UserInputSvc:IsGamepadButtonDown(v[4], v[2]) then
				v[3](InputObj)
			end
		end
	elseif CurEmulatorMode == EMULATOR_MODE.Tablet then
		-- NOT DONE
	end
end

-- [[ BINDING EVENTS ]] --

UserInputSvc.InputBegan:Connect(InputEvt)
UserInputSvc.InputChanged:Connect(InputEvt)

return InputEmulator
