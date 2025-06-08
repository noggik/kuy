local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Window = Fluent:CreateWindow({
    Title = "Mining tycoon" .. Fluent.Version,
    SubTitle = "Creat by Xin",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Player = Window:AddTab({ Title = "Player", Icon = "user" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

do
    Tabs.Player:AddParagraph({
        Title = "ความไวตัวละคร",
        Content = "ปรับเยอะวิิ่งไว"
    })

    local SensitivitySlider = Tabs.Player:AddSlider("CharacterSensitivity", {
        Title = "ความไวตัวละคร",
        Description = "ปรับความไวการวิ่ง (1-100)",
        Default = 50,
        Min = 1,
        Max = 100,
        Rounding = 1,
        Callback = function(Value)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                local humanoid = LocalPlayer.Character.Humanoid
                humanoid.WalkSpeed = 16 * (Value / 50)
                print("ความไวการวิ่งถูกปรับเป็น:", Value, "WalkSpeed:", humanoid.WalkSpeed)
            end
        end
    })

    SensitivitySlider:OnChanged(function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            humanoid.WalkSpeed = 16 * (Value / 50)
            print("ความไวตัวละครเปลี่ยนเป็น:", Value)
        end
    end)

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

    local function onCharacterAdded(character)
        local humanoid = character:WaitForChild("Humanoid")
        local currentValue = Options.CharacterSensitivity.Value or 50
        humanoid.WalkSpeed = 16 * (currentValue / 50)
        print("ตัวละครใหม่เกิด - ปรับความไวเป็น:", currentValue)
    end

    if LocalPlayer.Character then
        onCharacterAdded(LocalPlayer.Character)
    end
    LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
end

do
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)

    SaveManager:IgnoreThemeSettings()

    SaveManager:SetIgnoreIndexes({})

    InterfaceManager:SetFolder("PlayerControlScript")
    SaveManager:SetFolder("PlayerControlScript/configs")

    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)
end

Window:SelectTab(1)

Fluent:Notify({
    Title = "Player Control",
    Content = "สคริปต์โหลดสำเร็จแล้ว!",
    SubContent = "ใช้แท็บ Player เพื่อปรับความไวตัวละคร",
    Duration = 5
})

SaveManager:LoadAutoloadConfig()
