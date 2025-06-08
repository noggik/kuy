local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Get local player
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Fluent:CreateWindow({
    Title = "Player Control " .. Fluent.Version,
    SubTitle = "Character Sensitivity Control",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Create tabs
local Tabs = {
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Player Tab Content
do
    -- Add paragraph explaining the sensitivity control
    Tabs.Player:AddParagraph({
        Title = "ความไวตัวละคร",
        Content = "ปรับความไวในการเคลื่อนไหวของตัวละคร\nค่าสูงขึ้น = เคลื่อนไหวไวขึ้น"
    })

    -- Character Sensitivity Slider
    local SensitivitySlider = Tabs.Player:AddSlider("CharacterSensitivity", {
        Title = "ความไวตัวละคร",
        Description = "ปรับความไวการเคลื่อนไหว (1-100)",
        Default = 50,
        Min = 1,
        Max = 100,
        Rounding = 1,
        Callback = function(Value)
            -- Apply sensitivity to character
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local humanoid = LocalPlayer.Character.Humanoid
                -- Adjust WalkSpeed based on sensitivity (16 is default Roblox walkspeed)
                humanoid.WalkSpeed = 16 * (Value / 50) -- 50 is middle value, so 50 = normal speed
                print("ความไวตัวละครถูกปรับเป็น:", Value, "WalkSpeed:", humanoid.WalkSpeed)
            end
        end
    })

    -- Update sensitivity when slider changes
    SensitivitySlider:OnChanged(function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            humanoid.WalkSpeed = 16 * (Value / 50)
            print("ความไวตัวละครเปลี่ยนเป็น:", Value)
        end
    end)

    -- Add a button to reset sensitivity to default
    Tabs.Player:AddButton({
        Title = "รีเซ็ตความไว",
        Description = "รีเซ็ตความไวกลับเป็นค่าเริ่มต้น",
        Callback = function()
            SensitivitySlider:SetValue(50)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end
            Fluent:Notify({
                Title = "รีเซ็ตสำเร็จ",
                Content = "ความไวตัวละครถูกรีเซ็ตแล้ว",
                Duration = 3
            })
        end
    })

    -- Add current speed display
    Tabs.Player:AddParagraph({
        Title = "ข้อมูลปัจจุบัน",
        Content = "ความเร็วปัจจุบัน: จะแสดงเมื่อมีตัวละคร"
    })

    -- Function to update character sensitivity when character spawns
    local function onCharacterAdded(character)
        local humanoid = character:WaitForChild("Humanoid")
        -- Apply current slider value to new character
        local currentValue = Options.CharacterSensitivity.Value or 50
        humanoid.WalkSpeed = 16 * (currentValue / 50)
        print("ตัวละครใหม่เกิด - ปรับความไวเป็น:", currentValue)
    end

    -- Connect to character spawning
    if LocalPlayer.Character then
        onCharacterAdded(LocalPlayer.Character)
    end
    LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
end

-- Settings Tab Content (using SaveManager and InterfaceManager)
do
    -- Hand the library over to our managers
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)

    -- Ignore keys that are used by ThemeManager
    SaveManager:IgnoreThemeSettings()

    -- You can add indexes of elements the save manager should ignore
    SaveManager:SetIgnoreIndexes({})

    -- Set folders for saving configs
    InterfaceManager:SetFolder("PlayerControlScript")
    SaveManager:SetFolder("PlayerControlScript/configs")

    -- Build interface and config sections in Settings tab
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)
end

-- Select the Player tab by default
Window:SelectTab(1)

-- Show notification when script loads
Fluent:Notify({
    Title = "Player Control",
    Content = "สคริปต์โหลดสำเร็จแล้ว!",
    SubContent = "ใช้แท็บ Player เพื่อปรับความไวตัวละคร",
    Duration = 5
})

-- Load autoload config if available
SaveManager:LoadAutoloadConfig()
