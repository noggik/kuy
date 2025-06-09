local MacLib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()
local Window = MacLib:Window({
	Title = "KUY",
	Subtitle = "Maclip content",
	Size = UDim2.fromOffset(580, 460),
	DragStyle = 2, -- 1: Uses a move icon to drag, ideal for PC. 2: Uses the entire UI to drag, ideal for Mobile.
	DisabledWindowControls = {},
	ShowUserInfo = true,
	Keybind = Enum.KeyCode.LeftControl,
	AcrylicBlur = true,
})
--[[
:Unload() -- Destroy the window
.onUnloaded(function(): void) -- Called before the window is unloaded / closed

:SetState(<boolean>) -- Set window visibility
:GetState(: boolean) -- Get window visibility

:SetNotificationsState(<boolean>) -- Set notification visibility
:GetNotificationsState(: boolean) -- Get notification visibility

:SetAcrylicBlurState(<boolean>) -- Set UI Blur enabled
:GetAcrylicBlurState(: boolean) -- Get UI Blur enabled

:SetUserInfoState(<boolean>) -- Show or redact user info
:GetUserInfoState(: boolean) -- Get User Info Visibility

:SetKeybind(<enum>) -- Set window visibility keybind

:SetSize(<UDim2>) -- Sets the UI size
:GetSize(: UDim2) -- Returns the current UI Size

:SetScale(<number>) -- Sets the scale of the UI, 1 is the 100& scale (default), 1.5 is 150% scale, 2 is 200%, you get it. ( This uses the UIScale instance, which has several engine bugs and can cause visual issues with certain elements.)
:GetScale(: number) -- Returns the current scale of the UI

:UpdateTitle(<string>)
:UpdateSubtitle(<string>)
]]--

Window:Notify({
	Title = "Notify",
	Description = "Desc",
	Lifetime = 5,
	--[[
	Scale <number>
	SizeX = <number>
	Style <string: "None", "Confirm", "Cancel"> -- The type of button that the user interacts with, input "None" for no interactable (or leave nil), input "Confirm" for a checkmark, and input "Cancel" for a crossmark.
	Callback <function(): void>
	]]--
})

Window:Dialog({
	Title = "aa",
	Description = "are u gay.",
	Buttons = {
		{
			Name = "yep",
			Callback = function()
				print("Confirmed!")
			end,
		},
		{
			Name = "Cancel"
		}
	}
})

local TabGroup = Window:TabGroup()
local Tab = TabGroup:Tab({
	Name = "NN",
	Image = "127897217937601" -- Image can be at maximum 16 pixels wide and 16 pixels tall.
})
local Section = Tab:Section({
	Side = "Left"
	--<string: "Left", "Right">
})
Section:Button({
	Name = "Kill All",
	Callback = function()
		print("Killed everyone.")
	end,
})
--[[
:UpdateName(<string>)
:SetVisiblity(<boolean>)
]]--
Section:Input({
	Name = "Target",
	Placeholder = "Username",
	AcceptedCharacters = function(input)
		return input:gsub("[^a-zA-Z0-9]", "") -- AlphaNumeric sub
	end,
	Callback = function(input)
		print("Target set: ".. input)
	end,
}, "TargetInput")

--Slider
Section:Slider({
	Name = "Walkspeed",
	Default = 16,
	Minimum = 0,
	Maximum = 100,
	DisplayMethod = "Percent",
	Callback = function(Value)
		print("Changed to ".. Value)
	end,
}, "WalkspeedSlider")
--Togglr
Section:Toggle({
	Name = "Flight",
	Default = false,
	Callback = function(value)
		Window:Notify({
			Title = "Kuzu Hub",
			Description = (value and "Enabled " or "Disabled ") .. "Flight"
		})
	end,
}, "FlightToggle")
--Keybind
Section:Keybind({
	Name = "Reset Inventory",
	Callback = function(binded)
		Window:Notify({
			Title = "Kuzu Hub",
			Description = "Successfully Reset Inventory",
			Lifetime = 3
		})
	end,
	onBinded = function(bind)
		Window:Notify({
			Title = "Kuzu Hub",
			Description = "Rebinded Reset Inventory to "..tostring(bind.Name),
			Lifetime = 3
		})
	end,
}, "ResetInventoryBind")

--dropdwon
Section:Dropdown({
	Name = "Give Weapons",
	Search = true,
	Multi = true,
	Required = false,
	Options = {"AK-47", "M4A1", "Desert Eagle", "AWP", "MP5", "SPAS-12"},
	Default = {"M4A1", "AWP"},
	Callback = function(Value)
		local Values = {}
		for _, State in next, Value do
			if State then
				table.insert(Values, _)
			end
		end
		print("Selected Weapons:", table.concat(Values, ", "))
	end,
}, "GiveWeaponsDropdown")

--[[
:UpdateName(<string>)
:SetVisiblity(<boolean>)
:UpdateSelection(<string or number or table>) -- string/number for single, table for multi
:InsertOptions(<table>)
:RemoveOptions(<table>)
:IsOption(<string>: boolean)
:GetOptions(: table) -- Returns a table of every option and if it's true or false (Example: {"Option 1" = true, "Option 2" = false, "Option 3" = false} etc..)
:ClearOptions()
]]--

Section:Header({
	Text = "kuy"
}, nil)

Section:Paragraph({
	Header = "<string>",
	Body = "<string>"
}, nil)
Section:Label({
	Text = "S"
}, nil)
Section:SubLabel({
	Text = "Saaa"
}, nil)
--[[
:UpdateName(<string>)
:SetVisiblity(<boolean>)
]]


--Line
Section:Divider()
--[[
:Remove()
:SetVisiblity(<boolean>)
]]
Section:Spacer()
