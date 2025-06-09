local MacLib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()
local Window = MacLib:Window({
	Title = "Xin bro",
	Subtitle = "ของฟรีไอสัส",
	Size = UDim2.fromOffset(580, 460),
	DragStyle = 1, -- 1: Uses a move icon to drag, ideal for PC. 2: Uses the entire UI to drag, ideal for Mobile.
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
	Title = "Power by Xin",
	Description = "Loading script",
	Lifetime = 5,
	--[[
	Scale <number>
	SizeX = <number>
	Style <string: "None", "Confirm", "Cancel"> -- The type of button that the user interacts with, input "None" for no interactable (or leave nil), input "Confirm" for a checkmark, and input "Cancel" for a crossmark.
	Callback <function(): void>
	]]--
})

Window:Dialog({
	Title = "Discord",
	Description = "https://discord.gg/NVnd8gED",
	Buttons = {
		{
			Name = "ok",
			Callback = function()
				print("Confirmed!")
			end,
		},
		{
			Name = "No"
		}
	}
})

local TabGroup = Window:TabGroup()
local Tab = TabGroup:Tab({
	Name = "Main",
	Image = "127897217937601" -- Image can be at maximum 16 pixels wide and 16 pixels tall.
})
